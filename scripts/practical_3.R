## ----setup, include=FALSE-------------------------------------------------------------------------------------------
knitr::opts_chunk$set(fig.width=7, fig.height=7, dpi=300)


## -------------------------------------------------------------------------------------------------------------------
# Read in the avonet data again.
trait_data <- read.csv("data/avonet_data.csv")
str(trait_data)


## -------------------------------------------------------------------------------------------------------------------
# Load dplyr so we can filter.
library(dplyr)
accip_data <- trait_data %>% filter(jetz_family == "Accipitridae")


## -------------------------------------------------------------------------------------------------------------------
# This operator | means OR. EW means extinct in the wild.
accip_data %>% filter(redlist_cat == "EX" | redlist_cat == "EW")


## -------------------------------------------------------------------------------------------------------------------
# Load phylogenetic packages.
library(ape)
library(caper)

# Load in and plot the tree.
bird_tree <- read.tree("data/all_birds.tre")
plot(bird_tree, cex=0.01)


## -------------------------------------------------------------------------------------------------------------------
# Get the tips we don't want.
drop_tips <- setdiff(bird_tree$tip.label, accip_data$jetz_name)

# Drop the tips.
bird_tree <- drop.tip(bird_tree, drop_tips)


## -------------------------------------------------------------------------------------------------------------------
# We first transform our tree into a matrix of distances from each tip to tip. 
# This step is optional but stops a warning from ed.calc, which prefers a matrix.
bird_matrix <- clade.matrix(bird_tree)

# Now we can run the ed.calc function, which calculates ED scores for each species. 
# The output gives two dataframes, but we only want the species names and scores so we use $spp
ED <- ed.calc(bird_matrix)$spp
head(ED)


## -------------------------------------------------------------------------------------------------------------------
# By adding 1 to our scores, this prevents negative logs when our ED scores are below 1.
ED$EDlog <- log(1+ED$ED)

# We can normalise our scores so they're scaled between 0 and 1.
ED$EDn <- (ED$EDlog - min(ED$EDlog)) / (max(ED$EDlog) - min(ED$EDlog))
head(ED)


## -------------------------------------------------------------------------------------------------------------------
# Find the highest ED score.
ED[ED$EDn == max(ED$EDn),]


## -------------------------------------------------------------------------------------------------------------------
# Join the last two columns of UK_Jetz to ED scores. 
# This time we'll use the 'by' argument rather than change the column names.
accip_EDGE <- left_join(accip_data, ED,  by = c("jetz_name" = "species"))

# Head but we'll view just the first and last few columns.
head(accip_EDGE)[,c(2:3, 26:29)]


## EDGE=ln⁡(1+ED)+GE×ln⁡(2)


## -------------------------------------------------------------------------------------------------------------------
# The log function uses natural logarithms by default.
accip_EDGE$EDGE <- accip_EDGE$EDlog + accip_EDGE$extinct_prob * log(2)
head(accip_EDGE)[,c(2:3, 26:30)]


## -------------------------------------------------------------------------------------------------------------------
# Find the highest EDGE score.
accip_EDGE[accip_EDGE$EDGE == max(accip_EDGE$EDGE), c(2:3, 26:30)]

# Find the EDGE score for our previous highest species.
accip_EDGE[accip_EDGE$EDn == max(accip_EDGE$EDn), c(2:3, 26:30)]


## -------------------------------------------------------------------------------------------------------------------
# Plot a histogram of EDGE values.
hist(accip_EDGE$EDGE, breaks = 20)


## -------------------------------------------------------------------------------------------------------------------
# WE can use the select function to pull out only the columns we want to view.
# Because there's another function called select, we specify it's from dplyr.
accip_EDGE %>% filter(EDGE > 3) %>% dplyr::select(birdlife_common_name, jetz_name, redlist_cat, EDGE)


## In the above code we used the pipe operator `%>%` twice! This is why it's called a pipe.

## We can get the end product of each function to "flow" down to the next, like water

## down a pipe!


## -------------------------------------------------------------------------------------------------------------------
# Split the traits into beak shape traits, body shape traits, and body mass.
beak_traits <- accip_data %>% dplyr::select(beak_length_culmen, beak_width, beak_depth)
body_traits <- accip_data %>% dplyr::select(tarsus_length, wing_length, tail_length)
body_mass <- log(accip_data$mass)

# Look at the correlations between traits, including body mass.
pairs(cbind(beak_traits, body_mass))
pairs(cbind(body_traits, body_mass))


## We won't go into much detail on how a PCA works, as we want to focus on understanding the role of functional distinctivness in conservation. If you'd like to know in more detail, StatQuest has a great 5 minute [video](https://www.youtube.com/watch?v=HMOI_lkzW08&ab_channel=StatQuestwithJoshStarmer).


## -------------------------------------------------------------------------------------------------------------------
# First standardize the traits so they're all on a similar scale.
beak_traits <- scale(beak_traits)
body_traits <- scale(body_traits)

# Run a PCA of each set of traits separately.
beak_pca <- princomp(beak_traits)
body_pca <- princomp(body_traits)

# Look at the variation explained by each axes.
summary(beak_pca)
summary(body_pca)


## -------------------------------------------------------------------------------------------------------------------
# Return the loadings.
loadings(beak_pca)
loadings(body_pca)


## -------------------------------------------------------------------------------------------------------------------
# Plot PC1 against mass.
par(mfrow = c(1,2))
plot(beak_pca$scores[,1] ~ body_mass)
plot(body_pca$scores[,1] ~ body_mass)


## -------------------------------------------------------------------------------------------------------------------
# Create a matrix. Add in the rownames for the species.
traits_matrix <- cbind(beak_pca$scores[,2], body_pca$scores[,2], scale(log(accip_data$mass)))
rownames(traits_matrix) <- accip_data$jetz_name

# Converts traits into 'distance' in trait space.
distance_matrix <- dist(traits_matrix)


## -------------------------------------------------------------------------------------------------------------------
# Create the tree.
trait_tree <- nj(distance_matrix)

# Test to see if it's worked. The tree looks different to a normal one because tips 
# don't line up neatly at the present time period like with evolutionary relationships.
plot(trait_tree, cex=0.4)


## -------------------------------------------------------------------------------------------------------------------
# Create a matrix of distance from tip to tip.
tree_matrix <- clade.matrix(trait_tree)

# Calculate FD scores.
FD <- ed.calc(tree_matrix)$spp

# Change the name to FD.
colnames(FD)[2] <- "FD"
head(FD)


## -------------------------------------------------------------------------------------------------------------------
# Calculate the scores again.
FD$FDlog <- log(1+FD$FD)
FD$FDn <- (FD$FDlog - min(FD$FDlog)) / (max(FD$FDlog) - min(FD$FDlog))

# Find the highest FD score.
FD[FD$FDn == max(FD$FDn),]


## -------------------------------------------------------------------------------------------------------------------
# Get the top 5% of FD scores.
FD[FD$FD > quantile(FD$FD, 0.95),]


## ecoDGE=ln⁡(1+FD)+GE×ln⁡(2)


## -------------------------------------------------------------------------------------------------------------------
# Join FD and GE scores.
accip_ecoDGE <- left_join(accip_data, FD, by = c("jetz_name" = "species"))

# Calculate ecoDGE scores.
accip_ecoDGE$ecoDGE <- accip_ecoDGE$FDlog + accip_ecoDGE$extinct_prob * log(2)
head(accip_ecoDGE)[,c(2:3, 6, 27:30)]


## -------------------------------------------------------------------------------------------------------------------
# Find the highest ecoDGE score.
accip_ecoDGE[accip_ecoDGE$ecoDGE == max(accip_ecoDGE$ecoDGE), c(2:3, 6, 27:30)]


## -------------------------------------------------------------------------------------------------------------------
# Find the ecoDGE score for Gypaetus barbatus.
accip_ecoDGE[accip_ecoDGE$jetz_name == "Gypaetus_barbatus", c(2:3, 6, 27:30)]


## -------------------------------------------------------------------------------------------------------------------
# Get the top 5% of ecoDGE scores.
accip_ecoDGE[accip_ecoDGE$ecoDGE > quantile(accip_ecoDGE$ecoDGE, 0.95), c(2:3, 6, 27:30)]


## EcoEDGE= (0.5×EDn + 0.5×FDn) + GE×ln⁡(2)


## -------------------------------------------------------------------------------------------------------------------
# Merge FD and ED scores.
accip_EcoEDGE <- left_join(accip_EDGE, accip_ecoDGE)

# Calculate EcoEDGE scores.
accip_EcoEDGE$EcoEDGE <- (0.5*accip_EcoEDGE$EDn + 0.5*accip_EcoEDGE$FDn) + accip_EcoEDGE$extinct_prob*log(2)

# Select just the relevant columns.
accip_EcoEDGE <- accip_EcoEDGE %>% dplyr::select(birdlife_common_name, jetz_name, 
                                                 redlist_cat, extinct_prob, EDGE, ecoDGE, EcoEDGE)

# Check it's worked.
head(accip_EcoEDGE)


## -------------------------------------------------------------------------------------------------------------------
# Get the highest scoring species.
accip_EcoEDGE[accip_EcoEDGE$EcoEDGE == max(accip_EcoEDGE$EcoEDGE),]

# Get the top 10% of EcoEDGE scores.
accip_EcoEDGE[accip_EcoEDGE$EcoEDGE > quantile(accip_EcoEDGE$EcoEDGE, 0.9),]

# See the spread.
hist(accip_EcoEDGE$EcoEDGE, breaks = 20)


## For your coursework, you should cite both the original [EDGE reference](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0000296), as well as the [EcoEDGE reference](https://onlinelibrary.wiley.com/doi/full/10.1111/ddi.12320).

## 

## In general, most of the papers linked in this practical will be useful citations you should think about including.


## -------------------------------------------------------------------------------------------------------------------
# First load in the spatial packages we'll need.
library(raster)
library(sf)
library(fasterize)

# Load the data into our environment.
load("data/accipitridae_ranges.RData")

# Inspect the maps.
class(accip_ranges)
head(accip_ranges)


## -------------------------------------------------------------------------------------------------------------------
# Combine the two datasets into one object. (This turns our maps into a normal dataframe)
accip_ranges <- left_join(accip_EcoEDGE, accip_ranges, by = c("jetz_name" = "SCINAME"))

# Create an empty raster stack to store our data in.
raster_template <- raster(ncols=2160, nrows = 900, ymn = -60)

# 'fasterize' needs objects to be an sf class so we'll convert it back into an sf dataframe.
accip_ranges <- st_sf(accip_ranges)

# Use the fasterize function with the raster template. 
# We want to use the GE field, and the function max takes the highest value when they overlap.
GE_raster <- fasterize(accip_ranges, raster_template, field = "extinct_prob", fun = "max")

# Plot the new map. Colour ramp palette is another way to make a palette.
# The second brackets (50) is the number of colours to create from the function.
green_to_red <- colorRampPalette(c("forestgreen", "khaki", "firebrick"))(20)
plot(as.factor(GE_raster), col=green_to_red)


## You can use `colors()` to see the list of all the named colours to play with.


## -------------------------------------------------------------------------------------------------------------------
library(tidyr)
library(ggplot2)

# Convert the raster into a raster dataframe. 
# Remove rows with NA values from this dataframe.
raster_data <- as.data.frame(GE_raster, xy=TRUE) %>% drop_na()
colnames(raster_data) <- c("long", "lat", "index")

# Turn the GE score values to a factor to give a discrete raster rather than continuous values.
raster_data$index <- as.factor(raster_data$index)

# we can then plot this in ggplot. We have to first create the colour scheme for our map.
# The six character codes (hexcodes) signify a colour. There are many stock colours 
# (i.e. "grey80" yellow" "orange" "red") but hexcodes give more flexibility.
# Find colour hexcodes here: https://www.rapidtables.com/web/color/RGB_Color.html
myColors <- c("grey80", "grey80", "#FCF7B7", "#FFD384", "#FFA9A9")

# Assign names to these colours that correspond to each GE score. 
# We also use the sort() function to make sure the numbers are in ascending order.
names(myColors) <- unique(sort(raster_data$index))

# Create the colour scale.
colScale <- scale_fill_manual(name = "Extinction\nProbability", values = myColors)

# Create a plot with ggplot (the plus signs at the end of a line carry over to the next line).
GE_plot <- ggplot() +
  
  # Add the borders again.
  borders(ylim = c(-60,90), fill = "grey90", colour = "grey90") +
  
  # We need to reset the xlim to -180/180 again.
  xlim(-180, 180) +

  # Add the GE information on top.
  geom_tile(aes(x = long, y = lat, fill = index), data = raster_data) +
  
  # Add the formatting again!
  colScale +
  ggtitle("Accipitridae Threat Map") +
  theme_classic() +
  ylab("Latitude") +
  xlab("Longitude") + 
  coord_fixed()

# Resize the plotting window and return the plot so we can view it.
options(repr.plot.width=15, repr.plot.height=10)
GE_plot


## Fasterize doesn't have a mean function option, but we can get around this by dividing one raster by another.

## We first need to sum all the extinction probabilities, and then divide by species richness. Look back at

## [Practical 1](https://syrph.github.io/BCB_2022/markdowns/practical_1/practical_1.html#plotting-maps) for a reminder of how to create a species richness raster. Then it's as easy as:

## 

##   `average_raster <- sum_raster / richness_raster`

## 

## 


## -------------------------------------------------------------------------------------------------------------------
# Sum all the extinction probabilities.
sum_raster <- fasterize(accip_ranges, raster_template, field = "extinct_prob", fun = "sum")

# Use the sum function with no field for richness. (Assumes each range = 1).
richness_raster <- fasterize(accip_ranges, raster_template, fun = "sum")

# Divide the total by number of species to get average.
average_raster <- sum_raster / richness_raster

# Plot the new map.
plot(average_raster)


## -------------------------------------------------------------------------------------------------------------------
# Plot the map after logging cell values.
plot(log(average_raster), col = green_to_red)


## -------------------------------------------------------------------------------------------------------------------

# With GGplot. 
raster_data <- as.data.frame(average_raster, xy=TRUE) %>% drop_na()
colnames(raster_data) <- c("long", "lat", "index")

# We'll log the values, and then rescale from 0 to 1 so it's relative probabilities.
raster_data$index <- log(raster_data$index)
raster_data$index <- (raster_data$index - min(raster_data$index)) / (max(raster_data$index) - min(raster_data$index))

ggplot() +
  
  # Add the borders again.
  borders(ylim = c(-60,90), fill = "grey90", colour = "grey90") +
  xlim(-180, 180) +

  # Add the GE information on top.
  geom_tile(aes(x = long, y = lat, fill = index), data = raster_data) +
  
  # Add the formatting again!
  # Add a continuous colour scheme in ggplot.
  scale_fill_gradientn(colours = green_to_red, name = "Relative\nExtinction\nRisk") +
  ggtitle("Accipitridae Threat Map") +
  theme_classic() +
  ylab("Latitude") +
  xlab("Longitude") + 
  coord_fixed()


