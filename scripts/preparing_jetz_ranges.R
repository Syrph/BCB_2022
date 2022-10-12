##############################################################################
                        #### Fix Jetz range maps #####


rm(list=ls())
getwd()
library(sf)
library(lwgeom)
library(sm) # Dunno if i need this one?
library(doParallel)

# Load in the Jetz data.
load("data/jetz_ranges.RData")

# Subset the maps for just correct presence.
jetz_ranges <- subset(jetz_ranges, jetz_ranges$PRESENCE %in% c(1,2,3) &
                        jetz_ranges$ORIGIN %in% c(1,2) &
                        jetz_ranges$SEASONAL %in% c(1))


#  Cores galore.
registerDoParallel(cores = 15)

# Turn off the bane of my life.
sf_use_s2(FALSE)

# Loop that shit.
new_jetz_ranges <- foreach(split = isplit(jetz_ranges, jetz_ranges$SCINAME), .combine = rbind,
                           .packages = c("sf", "sm", "lwgeom", "raster")) %dopar%{
                             # Turn off again just in case?
                             sf_use_s2(FALSE)

                             # Pull out the thing we want.
                             spec <- split$value

                             # Make valid and convert to multipolygon each range.
                             for (j in 1:length(spec$Shape)) {
                               spec$Shape[j] <- lwgeom_make_valid(spec$Shape[j])
                               try(spec$Shape[j] <- st_cast(spec$Shape[j], 'MULTIPOLYGON'))
                             }

                             # Change the class of the whole column.
                             try(spec$Shape <- st_cast(spec$Shape, 'MULTIPOLYGON'))

                             # Change the offcial format of the object.
                             class(spec$Shape)[1] <- "sfc_MULTIPOLYGON"

                             # Create the one range.
                             spec$Shape[1] <- lwgeom_make_valid(st_union(spec$Shape))

                             # Get rid of confusing columns.
                             new_spec <- spec[1,c(1,2,3,16)]

                             # Return new spec.
                             return(new_spec)
                           }

# Cast everything to multipolygons.
new_jetz_ranges$Shape <- st_cast(new_jetz_ranges$Shape, 'MULTIPOLYGON')

# Export fixed Jetz maps.
save(corvid_ranges, file = "corvid.RData")


# library(fasterize)
#
#
# # Start by creating an empty raster stack to store our data in.
# raster_template <- raster(ncols=2160, nrows = 900, ymn = -60)
#
# # Create a map of species richness by summing overlapping ranges.
# species_raster <- fasterize(new_jetz_ranges, raster_template, fun = "sum")
#
# # Plot the new map.
# plot(species_raster, col=heat.colors(50))
#
#
#

#
# library(tidyr)
# library(ggplot2)
# library(raster)
# # Convert the raster into a raster dataframe. This will be coordinates of the
# # raster pixels (cols x and y) and the value of the raster pixels.
# raster_data <- as.data.frame(range_raster, xy=TRUE)
#
# # Remove NAs with no information (like parts of the sea)
# raster_data <- na.omit(raster_data)
#
# # Change the column names to something sensible.
# colnames(raster_data) <- c("long", "lat", "richness")
#
# # Create a plot with ggplot (the plus signs at the end of a line carry over to the next line).
# range_plot <- ggplot(raster_data) +
#
#   # borders imports all the country outlines onto the map.
#   # colour changes the colour of the outlines.
#   # fill changes the colour of the insides of the countries.
#   # this will grey out any terrestrial area which isn't part of a range.
#   borders(ylim = c(-60,90), fill = "grey90", colour = "grey90") +
#
#   # Borders() xlim is -160/200 to catch the edge of russia.
#   # We need to reset the xlim to -180/180 to fit our raster_stack.
#   xlim(-180, 180) +
#
#   # Add the range information on top.
#   geom_tile(aes(x=long, y=lat, fill= richness)) +
#
#   # Add a colour blind friendly scale.
#   scale_fill_viridis_c() +
#
#   # Add title.
#   ggtitle("Accipitidae Species Richness") +
#
#   # Add the classic theme (things like gridlines, font etc.)
#   theme_classic() +
#
#   # Add axes labels.
#   ylab("Latitude") +
#   xlab("Longitude") +
#
#   # coord_fixed() makes ggplot keep our aspect ratio the same.
#   coord_fixed()
#
# # Change the size of the plot window and return the plot.
# #options(repr.plot.width=15, repr.plot.height=10)
# range_plot
#
# library(magrittr)
# avonet_data %<>% filter(jetz_name %in% new_jetz_ranges$SCINAME)
#
# # And lets add a column to our data for storing if it's a small or large range.
# avonet_data$range_large <- NA
#
# # We'll use a basic loop that goes from 1 to 237.
# row_numbers <- 1:nrow(avonet_data)
#
# # The curly brackets show the beginning and the end of the loop.
# for (x in row_numbers){
#
#   # Pull out the range size we want for each iteration (x) of the loop.
#   range <- avonet_data$range_size[x]
#
#   # Calculate if it's small range or a large range.
#   if (range > 1000000){
#     range_large <- 1
#   } else {
#     range_large <- 0
#   }
#
#   # Lastly we want to add our new value to the dataframe.
#   avonet_data$range_large[x] <- range_large
# }
#
#
#
# # Load fasterize package.
# library(fasterize)
#
# # Combine the two datasets into one object so we have range size info and the polygons together.
# # This turns our sf object into a normal dataframe.
# Accip_all <- left_join(avonet_data, new_jetz_ranges, by = c("jetz_name" = "SCINAME"))
#
# # Start by creating an empty raster stack to store our data in.
# raster_template <- raster(ncols=2160, nrows = 900, ymn = -60)
#
# # 'fasterize' needs objects to be an sf class so we'll convert it back.
# Accip_all <- st_sf(Accip_all)
#
# # Use the fasterize function with the raster template. We want to use the
# # range_large field, and the function min takes the smallest value when they overlap.
# # (so small ranges are shown on top of large ranges)
# range_raster <- fasterize(Accip_all, raster_template, field = "range_size", fun = "sum")
# ?fasterize
# # Plot the new map.
# plot(range_raster, col=rainbow(2))
#
#
# library(tidyr)
# library(ggplot2)
#
# # Convert the raster into a raster dataframe.
# raster_data <- as.data.frame(range_raster, xy=TRUE) %>% drop_na()
# colnames(raster_data) <- c("long", "lat", "index")
#
# # Add labels for the range sizes so that ggplot colours them as discrete, rather than a continuous number.
# raster_data$ranges[raster_data$index == 0] <- "Small"
# raster_data$ranges[raster_data$index == 1] <- "Large"
#
# # We can then plot this in ggplot. We have to first create the colour scheme for our map.
# myColors <- c("grey80", "red")
#
# # Assign names to these colors that correspond to each range size.
# names(myColors) <- unique(raster_data$ranges)
#
# # Create the colour scale.
# colScale <- scale_fill_manual(name = "Range Sizes", values = myColors)
#
# # Create a plot with ggplot (the plus signs at the end of a line carry over to the next line).
# range_plot <- ggplot() +
#   # borders imports all the country outlines onto the map.
#   # colour changes the colour of the outlines,
#   # fill changes the colour of the insides of the countries.
#   # This will grey out any terrestrial area which isn't part of a range.
#   borders(ylim = c(-60,90), fill = "grey90", colour = "grey90") +
#
#   # Borders() xlim is -160/200 to catch the edge of Russia. We need to reset the
#   # xlim to -180/180 to fit our raster_stack.
#   xlim(-180, 180) +
#
#   # Add the range information on top.
#   geom_tile(aes(x=long, y=lat, fill= ranges), data=raster_data) +
#   # Add colours.
#   colScale +
#   # Add title.
#   ggtitle("Small range sizes in the Accipitidae") +
#   # Add the classic theme (things like gridlines, font etc.)
#   theme_classic() +
#   # Add axes labels.
#   ylab("Latitude") +
#   xlab("Longitude") +
#   # coord_fixed() makes ggplot keep our aspect ratio the same.
#   coord_fixed()
#
# # Return the plot so we can view it.
# options(repr.plot.width=15, repr.plot.height=10)
# range_plot
#
#
#
#
#
#
# plot(range_raster)
#
# test_raster <- range_raster / species_raster
#
# plot(test_raster)
#
#
# # raster pixels (cols x and y) and the value of the raster pixels.
# raster_data <- as.data.frame(test_raster, xy=TRUE)
#
# # Remove NAs with no information (like parts of the sea)
# raster_data <- na.omit(raster_data)
#
# # Change the column names to something sensible.
# colnames(raster_data) <- c("long", "lat", "richness")
#
# # Create a plot with ggplot (the plus signs at the end of a line carry over to the next line).
# range_plot <- ggplot(raster_data) +
#
#   # borders imports all the country outlines onto the map.
#   # colour changes the colour of the outlines.
#   # fill changes the colour of the insides of the countries.
#   # this will grey out any terrestrial area which isn't part of a range.
#   borders(ylim = c(-60,90), fill = "grey90", colour = "grey90") +
#
#   # Borders() xlim is -160/200 to catch the edge of russia.
#   # We need to reset the xlim to -180/180 to fit our raster_stack.
#   xlim(-180, 180) +
#
#   # Add the range information on top.
#   geom_tile(aes(x=long, y=lat, fill= richness)) +
#
#   # Add a colour blind friendly scale.
#   scale_fill_viridis_c() +
#
#   # Add title.
#   ggtitle("Accipitidae Species Richness") +
#
#   # Add the classic theme (things like gridlines, font etc.)
#   theme_classic() +
#
#   # Add axes labels.
#   ylab("Latitude") +
#   xlab("Longitude") +
#
#   # coord_fixed() makes ggplot keep our aspect ratio the same.
#   coord_fixed()
#
# # Change the size of the plot window and return the plot.
# #options(repr.plot.width=15, repr.plot.height=10)
# range_plot
#
#
