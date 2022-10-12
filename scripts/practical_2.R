## ----setup, include=FALSE-------------------------------------------------------------------------------------------
knitr::opts_chunk$set(fig.width=7, fig.height=7, dpi=300)


## ----results = "hold"-----------------------------------------------------------------------------------------------
# Clear your workspace before starting a new project.
rm(list=ls())


## ----results = "hold"-----------------------------------------------------------------------------------------------
# Load the duck latitudinal and body mass data.
duck_data <- read.csv("data/duck_data.csv", header = TRUE) 

# Check it's been imported.
str(duck_data)
head(duck_data)

# Remove any NAs in the data (make sure to check you're not loosing too much data!)
duck_data <- na.omit(duck_data)


## -------------------------------------------------------------------------------------------------------------------
# The abs function takes absolute value.
duck_data$abs_latitude <- abs(duck_data$latitude)


## -------------------------------------------------------------------------------------------------------------------
# Create a basic plot for data visualisation.
# Notice we can add a data argument instead of using $
plot(body_mass ~ abs_latitude, data = duck_data)


## -------------------------------------------------------------------------------------------------------------------
# We'll use a histogram to look at the spread.
hist(duck_data$body_mass)


## -------------------------------------------------------------------------------------------------------------------
# Create a new variable and take logs.
duck_data$log_BM <- log(duck_data$body_mass)
hist(duck_data$log_BM)


## -------------------------------------------------------------------------------------------------------------------
# Create a new plot.
plot(log_BM ~ abs_latitude, data = duck_data)


## -------------------------------------------------------------------------------------------------------------------
# Run a basic linear model. We separate our dependant variables from predictors using a tilda ~
duck_model <- lm(log_BM ~ abs_latitude, data = duck_data)

# Inspect our linear model.
summary(duck_model)


## -------------------------------------------------------------------------------------------------------------------
# Create some data.
x <- c(12, 18, 21, 36, 44, 54, 59)
y <- c(2, 4, 7, 11, 12, 14, 15)

# Create a linear model based only on the mean of y.
mean <- lm(y ~ 1)

# Create a linear model where x predicts y.
linear <- lm(y ~ x)

# Create a plot window with one row and two columns.
par(mfrow = c(1, 2))

# Plot our data for the mean.
plot(x,y, xlim = c(0, 60), ylim =c(0, 15), main = "Mean") 

# Add the line of the linear model based on the mean.
abline(mean, col="red")

# Add in lines to show the distance from each point to mean line (the residuals).
segments(x, y, x, predict(mean))

# Do the same to plot our data with the linear model based on x.
plot(x,y, xlim = c(0,60), ylim =c(0,15), main = "Linear")  
abline(linear, col="blue")
segments(x, y, x, predict(linear))


## -------------------------------------------------------------------------------------------------------------------
# Get the summary of our model.
summary(duck_model)


## -------------------------------------------------------------------------------------------------------------------
# Plot our model.
plot(log_BM ~ abs_latitude, data = duck_data)
abline(duck_model)


## -------------------------------------------------------------------------------------------------------------------
# Plot a density curve of the residuals.
plot(density(duck_model$residuals))


## ----results="hold"-------------------------------------------------------------------------------------------------
# Load phylogenetic packages.
library(ape)
library(caper)

# Read in the tree.
duck_tree <- read.tree("data/duck_tree.tre")
plot(duck_tree, cex=0.3)


## -------------------------------------------------------------------------------------------------------------------
# We need to change the Jetz names so that they match the tip labels.
duck_data$jetz_name <- gsub(" ", "_", duck_data$jetz_name)

# We specify the phylogeny we need, the data, and which column has the tip label names in.
duck_comp <- comparative.data(phy = duck_tree, data = duck_data, names.col = "jetz_name")


## -------------------------------------------------------------------------------------------------------------------
# Return the data.
head(duck_comp$data)


## -------------------------------------------------------------------------------------------------------------------
# Plot the phylogeny.
plot(duck_comp$phy, cex=0.3)


## -------------------------------------------------------------------------------------------------------------------
# Run a PGLS model.
duck_pgls <- pgls(log_BM ~ abs_latitude, data = duck_comp, lambda = "ML")


## -------------------------------------------------------------------------------------------------------------------
# You can see the summary the same way.
summary(duck_pgls)


## -------------------------------------------------------------------------------------------------------------------
# Load the package geiger that has the rescale function. You'll have to install it if you're in Rstudio on your own laptops.
library(geiger)

# We'll create six trees with different lambda values .
lambda_1_tree <- rescale(duck_tree, "lambda", 1)
lambda_0.8_tree <- rescale(duck_tree, "lambda", 0.8)
lambda_0.6_tree <- rescale(duck_tree, "lambda", 0.6)
lambda_0.4_tree <- rescale(duck_tree, "lambda", 0.4)
lambda_0.2_tree <- rescale(duck_tree, "lambda", 0.2)
lambda_0_tree <- rescale(duck_tree, "lambda", 0)

# Now we'll plot them alongside each other to see the difference.

# Change the number of plots and resize the window.
par(mfrow = c(2,3))
options(repr.plot.width=15, repr.plot.height=15)

plot(lambda_1_tree, show.tip.label = FALSE, direction = "downwards", main = "1.0")
plot(lambda_0.8_tree, show.tip.label = FALSE, direction = "downwards", main = "0.8")
plot(lambda_0.6_tree, show.tip.label = FALSE, direction = "downwards", main = "0.6")
plot(lambda_0.4_tree, show.tip.label = FALSE, direction = "downwards", main = "0.4")
plot(lambda_0.2_tree, show.tip.label = FALSE, direction = "downwards", main = "0.2")
plot(lambda_0_tree, show.tip.label = FALSE, direction = "downwards", main = "0.0")


## -------------------------------------------------------------------------------------------------------------------
# Change the plot margins to fit the plot in.
par(mar = c(7, 5, 5, 2))

# Get the potential values of lambda.
lambda_likelihood <- pgls.profile(duck_pgls, which = "lambda")

# Plot them.
plot(lambda_likelihood)


## -------------------------------------------------------------------------------------------------------------------
# Read in the avonet data.
avonet_data <- read.csv("data/avonet_data.csv")
str(avonet_data)
head(avonet_data)


## -------------------------------------------------------------------------------------------------------------------
# Load the dplyr package to use filter.
library(dplyr)

# Filter will subset our trait data based on the Jetz family column.
accip_data <- avonet_data %>% filter(jetz_family == "Accipitridae")


## -------------------------------------------------------------------------------------------------------------------
# First we need to get absolute latitude.
accip_data$abs_latitude <- abs(accip_data$centroid_latitude)

# Read in the tree.
bird_tree <- read.tree("data/all_birds.tre")

# Get the tips we don't want.
drop_tips <- setdiff(bird_tree$tip.label, accip_data$jetz_name)

# Drop the tips.
accip_tree <- drop.tip(bird_tree, drop_tips)

# Create a comparative data object.
accip_comp <- comparative.data(phy = accip_tree, data = accip_data, names.col = "jetz_name")

# Run the pgls.
accip_pgls <- pgls(range_size ~ abs_latitude, data = accip_comp, lambda = "ML")

# Get the summary.
summary(accip_pgls)


## -------------------------------------------------------------------------------------------------------------------
# Change the plot margins to fit the plot in.
par(mar = c(7, 5, 5, 2))

# Get the potential values of lambda.
lambda_likelihood <- pgls.profile(accip_pgls, which = "lambda")

# Plot them.
plot(lambda_likelihood)


## ----results = "hold"-----------------------------------------------------------------------------------------------
# First load in the spatial packages we'll need.
library(raster)
library(sf)

# Load the data into our environment.
load("data/accipitridae_ranges.RData")

# Inspect the maps.
class(accip_ranges)
head(accip_ranges)


## -------------------------------------------------------------------------------------------------------------------
#  Take the range polygon from the first row.
plot(accip_ranges$Shape[1], axes=TRUE)


## :align: center

## :width: 600px


## -------------------------------------------------------------------------------------------------------------------
# And lets add a column to our data for storing if it's a small or large range.
accip_data$range_large <- NA

# We'll use a basic loop that goes from 1 to 237.
row_numbers <- 1:nrow(accip_data)

# The curly brackets show the beginning and the end of the loop.
for (x in row_numbers){
  
  # Pull out the range size we want for each iteration (x) of the loop.
  range <- accip_data$range_size[x]
  
  # Calculate if it's small range or a large range.
  if (range > 1000000){
    range_large <- 1
  } else {
    range_large <- 0
  }
  
  # Lastly we want to add our new value to the dataframe.
  accip_data$range_large[x] <- range_large
}


## You can also run each line of a loop one by one to better understand what's happening.

## Just set `x <- 1` and then skip the for() line to see the other lines one at a time.


## -------------------------------------------------------------------------------------------------------------------
# Load fasterize package.
library(fasterize)

# Combine the two datasets into one object so we have range size info and the polygons together. 
# This turns our sf object into a normal dataframe.
Accip_all <- left_join(accip_data, accip_ranges, by = c("jetz_name" = "SCINAME"))

# Start by creating an empty raster stack to store our data in.
raster_template <- raster(ncols=2160, nrows = 900, ymn = -60)

# 'fasterize' needs objects to be an sf class so we'll convert it back.
Accip_all <- st_sf(Accip_all)

# Use the fasterize function with the raster template. We want to use the 
# range_large field, and the function min takes the smallest value when they overlap. 
# (so small ranges are shown on top of large ranges)
range_raster <- fasterize(Accip_all, raster_template, field = "range_large", fun = "min")

# Plot the new map.
plot(range_raster, col=rainbow(2))


## -------------------------------------------------------------------------------------------------------------------
library(tidyr)
library(ggplot2)

# Convert the raster into a raster dataframe.
raster_data <- as.data.frame(range_raster, xy=TRUE) %>% drop_na()
colnames(raster_data) <- c("long", "lat", "index")

# Add labels for the range sizes so that ggplot colours them as discrete, rather than a continuous number.
raster_data$ranges[raster_data$index == 0] <- "Small"
raster_data$ranges[raster_data$index == 1] <- "Large"

# We can then plot this in ggplot. We have to first create the colour scheme for our map.
myColors <- c("grey80", "red")

# Assign names to these colors that correspond to each range size.
names(myColors) <- unique(raster_data$ranges)

# Create the colour scale.
colScale <- scale_fill_manual(name = "Range Sizes", values = myColors)


## -------------------------------------------------------------------------------------------------------------------
# Create a plot with ggplot (the plus signs at the end of a line carry over to the next line).
range_plot <- ggplot() +
  # borders imports all the country outlines onto the map. 
  # colour changes the colour of the outlines, 
  # fill changes the colour of the insides of the countries.
  # This will grey out any terrestrial area which isn't part of a range.
  borders(ylim = c(-60,90), fill = "grey90", colour = "grey90") +
  
  # Borders() xlim is -160/200 to catch the edge of Russia. We need to reset the 
  # xlim to -180/180 to fit our raster_stack.
  xlim(-180, 180) + 
  
  # Add the range information on top.
  geom_tile(aes(x=long, y=lat, fill= ranges), data=raster_data) +
  # Add colours.
  colScale +
  # Add title.
  ggtitle("Small range sizes in the Accipitidae") + 
  # Add the classic theme (things like gridlines, font etc.)
  theme_classic() +
  # Add axes labels.
  ylab("Latitude") + 
  xlab("Longitude") + 
  # coord_fixed() makes ggplot keep our aspect ratio the same.
  coord_fixed() 

# Return the plot so we can view it.
options(repr.plot.width=15, repr.plot.height=10)
range_plot


## -------------------------------------------------------------------------------------------------------------------
# Open up a new plotting device which will save a photo.
jpeg("my_map.jpeg")

# Add the plot to the plotting device.
range_plot

# Turn off the plotting device to save it.
dev.off()


## -------------------------------------------------------------------------------------------------------------------
# First lets create a bin range (from 0 to 90 which is max latitude) and size (by=5).
range <- seq(0, 90, by=5) 

# Create labels for our bins. We want to skip zero, as the labels refer to the upper limits of each break. 
labels <- seq(5, 90, 5)

# We can now 'cut' up our latitude and put them into bins. 
# This function adds an extra column, and adds a label for which bin each species should be in.
accip_data$lat.bins <- cut(accip_data$abs_latitude, breaks=range, labels=labels) 

# The cut function creates the labels as factors, so we'll turn them back into numbers to plot. 
# We turn them into characters first because as.numeric will convert factors into their level order, 
# rather than their value.
accip_data$lat.bins <- as.numeric(as.character(accip_data$lat.bins))

# Plot our bins as a histogram
hist(accip_data$lat.bins, breaks = 7) 


## -------------------------------------------------------------------------------------------------------------------
# Get the frequency of each bin
species_richness <- count(accip_data, lat.bins)
colnames(species_richness)[2] <- "richness"
species_richness


## -------------------------------------------------------------------------------------------------------------------
# The only difference with running a glm is now we have to specify the family as well.
accip_model <- glm(richness ~ lat.bins, data = species_richness, family = "poisson")
summary(accip_model)


## Richness \sim e^{(4.232\ -\ 0.049\ \times lat.bins)}


## Richness \sim \frac{e^{4.232}} {e^{0.049 \times lat.bins}}


## -------------------------------------------------------------------------------------------------------------------
# We first plot raw values as just a scatter plot.
plot(richness ~ lat.bins, data = species_richness)

# And then add a line of the fitted values of the model.
lines(species_richness$lat.bins, accip_model$fitted.values)


## -------------------------------------------------------------------------------------------------------------------
# We need the predictions from our model. Type "response" gives us y after the log-link.
predictions <- predict(accip_model, type = "response", se.fit = TRUE)

# Add the predictions to our dataframe.
species_richness$fit <- predictions$fit
species_richness$y_max <- predictions$fit + predictions$se.fit
species_richness$y_min <- predictions$fit - predictions$se.fit

# Create a normal scatter plot.
ggplot(species_richness, aes(x = lat.bins, y = richness)) + geom_point() +
  
  # Add in the main model line. Turn se off so we add it manually after.
  geom_smooth(aes(y = fit), fullrange=FALSE, se = FALSE) + 
  
  # Now add the standard errors.
  geom_ribbon(aes(ymin = y_min, ymax = y_max), alpha = 0.2, fill = "blue") +
  
  # Add labels.
  xlab("Latitude") + ylab("Species Richness") +
  
  # Lastly add a theme to remove the grey background and grid lines.
  theme_classic()


## ----fig.width = 12, fig.height = 6---------------------------------------------------------------------------------
# Use the fasterize function with the raster template, summing species for species richness.
SR_raster <- fasterize(Accip_all, raster_template, fun = "sum")

# Convert the raster into a raster dataframe.
raster_data <- as.data.frame(SR_raster, xy=TRUE) %>% drop_na()
colnames(raster_data) <- c("long", "lat", "richness")

# Plot with ggplot.
richness_plot <- ggplot() +
  borders(ylim = c(-60,90), fill = "grey90", colour = "grey90") +
  xlim(-180, 180) + 
  geom_tile(aes(x=long, y=lat, fill= richness), data=raster_data) +
  
  # Here we add a name to the legend, and set manual colours for either end of a gradient.
  # \n adds a new line.
  scale_fill_gradientn(name = "Species\nRichness", colors = c("skyblue", "red")) +  
  
  # You should be getting used to this code!
  theme_classic() + # Most of preset theme.
  theme(text = element_text(face = "bold")) +  # Extra theme just for the bold.
  ylab("Latitude") + 
  xlab("Longitude") + 
  coord_fixed()

# Return the plot so we can view it.
richness_plot

