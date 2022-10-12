## ----setup, include=FALSE-------------------------------------------------------------------------------------------
knitr::opts_chunk$set(fig.width=7, fig.height=7, dpi=300)


## -------------------------------------------------------------------------------------------------------------------
# Get the current working directory. (Mine will be different to yours!)
getwd()


## If you're in `RStudio` you can also use

## `Tools -> Global Options` to change your default working directory to your

## preferred folder. This means every time you open RStudio you will already be in

## correct place to begin.


## -------------------------------------------------------------------------------------------------------------------
# A nice script to say hi #

# Create a message.
my_message <- "Hello World."

# Print my message in the console.
print(my_message)


## ----eval=FALSE-----------------------------------------------------------------------------------------------------
## # Install ggplot2 for making fancy plots.
## install.packages("ggplot2")


## -------------------------------------------------------------------------------------------------------------------
library(ggplot2)


## ----eval=FALSE-----------------------------------------------------------------------------------------------------
## # Install packages for the BCB practicals.
## source("install.R")


## Installing packages can often throw up errors, especially if you're using a Mac

## to run spatial packages (like we use in this practical). Please ask for help if

## you run into issues, demonstrators will be on hand! Once the packages are installed,

## you shouldn't have any issues running them in the future.


## ----results = "hold"-----------------------------------------------------------------------------------------------
# We'll first try defining some basic variables.

# A number.
a <- 5.7

# Running the variable returns it to the console.
a

# The class function tells us what type of variable.
class(a)


## To run a single line of your script at a time in windows, a convenient short

## cut is `CTRL + ENTER`.


## ----results = "hold"-----------------------------------------------------------------------------------------------
# A string.
b <- "hello"
b
class(b)


## ----results = "hold"-----------------------------------------------------------------------------------------------
# A logical object.
c <- TRUE
c
class(c)


## -------------------------------------------------------------------------------------------------------------------
# Generates a sequence from 0 to 9 by intervals of 1. Try ?seq() for more information.
d <- seq(0, 9, 1) 
d


## Remember that you can find the R help for a particular function by using

## `?function` e.g. `?seq`. You can also use `help(seq)` for the same effect.


## -------------------------------------------------------------------------------------------------------------------
# Concatenate variables into one vector.
e <- c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
e


## -------------------------------------------------------------------------------------------------------------------
# Combine d and e into one vector.
f <- c(d, e)
f


## ----results = "hold"-----------------------------------------------------------------------------------------------
# Create a vector of strings.
g <- c("red", "blue", "green")
g
class(g)


## ----results = "hold"-----------------------------------------------------------------------------------------------
# And a vector of logicals.
h <- c(TRUE, TRUE, FALSE)
h
class(h)


## ----results = "hold"-----------------------------------------------------------------------------------------------
# Find the length of a vector.
length(e) 

# Find the mean of the vector.
mean(e)

# Find the variance of the vector.
var(e)


## ----results = "hold"-----------------------------------------------------------------------------------------------
# Return the first element of e.
e[1]

# Return the fifth element of e.
e[5]

# Return the tenth element of e.
e[10]


## ----results = "hold"-----------------------------------------------------------------------------------------------
# Elements 1 to 5.
e[1:5]

# Elements 1 and 4.
e[c(1,4)]

# e without the fourth element.
e[-4]


## -------------------------------------------------------------------------------------------------------------------
# Create two vectors.
numbers <- c(1,2,3,4,5)
other_numbers <- c(6,7,8,9,10)

# Use the cbind function to bind together the two vectors as columns.
all_numbers <- cbind(numbers, other_numbers)

# View our new matrix.
all_numbers


## -------------------------------------------------------------------------------------------------------------------
# Look at the class of our new variable.
class(all_numbers)


## -------------------------------------------------------------------------------------------------------------------
# Create a vector of numbers.
numbers <- c(1,2,3,4,5)

# Create a vector of strings.
characters <- c("a","b","c","d","e")

# Bind both types together.
both_types <- cbind(numbers, characters)
both_types


## -------------------------------------------------------------------------------------------------------------------
# Get the class.
class(both_types)


## ----results = "hold"-----------------------------------------------------------------------------------------------
# Return values from the column called numbers.
both_types[, "numbers"]

# Check the class of the column called numbers.
class(both_types[, "numbers"])


## -------------------------------------------------------------------------------------------------------------------
# Create a dataframe of both vectors.
both_types <- data.frame(numbers, characters)
both_types


## ----results = "hold"-----------------------------------------------------------------------------------------------
# Get the class of both_types.
class(both_types)

# Get the class of the numbers column.
class(both_types$numbers)


## **An important note:** It's tempting to name variables as single letters (a, b, c) as we did at the beginning of the practical. However, for anything slightly more complex than what we've done this becomes confusing very quickly. It's much better to use longer variables like 'numbers' or 'letters'. This describes what the variable is, and makes it easier for yourself and others to read your code and understand it! An easy way to separate words is to use periods '.' or underscores '_'.


## -------------------------------------------------------------------------------------------------------------------
# Create two vectors.
small_numbers <- seq(1, 10, 1)
large_numbers <- seq(100, 1000, 100)

# Create a dataframe of the two vectors.
all_numbers <- data.frame(small_numbers, large_numbers)
all_numbers


## -------------------------------------------------------------------------------------------------------------------
# Get the top 6 values.
head(all_numbers)


## -------------------------------------------------------------------------------------------------------------------
# Get the bottom 6 values.
tail(all_numbers)


## -------------------------------------------------------------------------------------------------------------------
# Get the structure of the dataframe.
str(both_types)


## ----results = "hold"-----------------------------------------------------------------------------------------------
# Get the number of rows and columns.
nrow(all_numbers)
ncol(all_numbers)


## -------------------------------------------------------------------------------------------------------------------
# Change the column names.
colnames(all_numbers) <- c("small_numbers", "large_numbers")
colnames(all_numbers)


## -------------------------------------------------------------------------------------------------------------------
# Change just one column name.
colnames(all_numbers)[1] <- "one_to_ten"
colnames(all_numbers)


## -------------------------------------------------------------------------------------------------------------------
# First row and first column.
all_numbers[1,1]


## -------------------------------------------------------------------------------------------------------------------
# First column.
all_numbers[,1]


## -------------------------------------------------------------------------------------------------------------------
# First row (because columns can contain different data types, selecting across 
# a row returns a dataframe).
all_numbers[1,]


## ----results = "hold"-----------------------------------------------------------------------------------------------
# Get the small numbers.
all_numbers$one_to_ten

# Get the large numbers (the comma specifies to take them from all rows. 
# Try adding in indexes to the left of the comma).
all_numbers[,"large_numbers"]


## -------------------------------------------------------------------------------------------------------------------
# Read in the avonet data. The file pathway is in quotation marks.
avonet_data <- read.csv("data/avonet_data.csv", header = TRUE)


## -------------------------------------------------------------------------------------------------------------------
# Get the structure.
str(avonet_data)


## -------------------------------------------------------------------------------------------------------------------
# See the first 5 rows.
head(avonet_data, 5)


## -------------------------------------------------------------------------------------------------------------------
# First subset all our bird data for just passerine birds.
passerines <- subset(avonet_data, avonet_data$jetz_order == "Passeriformes")

# Remove any missing values.
passerines <- na.omit(passerines)

# Plot a basic scatter plot.
plot(passerines$mass, passerines$tarsus_length, pch=16, col="blue", 
     main="My plot", xlab="Body Mass", ylab="Tarsus Length")


## -------------------------------------------------------------------------------------------------------------------
# Plot a histogram.
hist(passerines$mass, main = "My histogram", xlab = "Body Mass", breaks = 50)

# Plot a density plot instead (where frequency of samples is normalised to sum to 1).
plot(density(passerines$mass), main = "My distribution", xlab = "Body Mass")


## -------------------------------------------------------------------------------------------------------------------
# The par function changes parameters. mfrow = c(1,2) means we want 1 row and 2 columns.
par(mfrow =c (1,2))

# Plot both plots as normal.
hist(passerines$mass, main = "My histogram", xlab = "Body Mass", breaks = 50)
plot(density(passerines$mass), main = "My distribution", xlab = "Body Mass")


## When plotting histograms, you can also use the argument `breaks = n` to

## manually set the number of breaks.


## -------------------------------------------------------------------------------------------------------------------
# To reset your graph parameters to the default, simply turn off the open graphical device.
dev.off()


## -------------------------------------------------------------------------------------------------------------------
# Create a new column with the log of body mass.
passerines$log_mass <- log(passerines$mass)

# See the new distribution.
hist(passerines$log_mass, main = "My histogram", xlab = "Log Mass", breaks = 50)

# Look at the scatter plot.
plot(passerines$log_mass, passerines$tarsus_length, pch=16, col="blue", 
     main="My plot", xlab="Body Mass", ylab="Tarsus Length")


## -------------------------------------------------------------------------------------------------------------------
# Opens a new graphical device called 'my_plot.jpg' in the current working directory.
jpeg("my_plot.jpg")

# Create a plot as usual.
plot(passerines$log_mass, passerines$tarsus_length, pch=16, col="blue", 
     main="My plot", xlab="Body Mass", ylab="Tarsus Length")

# Turn off the device to save any changes.
dev.off()


## One time you might want to use GIS software is for exploring your GIS data. It's

## easier to interactively explore maps using software before loading it into R. If

## you do need software, QGIS is free and open source, so you can continue to use it

## after you've finished your degree!


## -------------------------------------------------------------------------------------------------------------------
# Load the raster package for spatial data.
library(raster)

# getData is a function from the raster package that allows us to download some spatial data. 
bio <- getData("worldclim", var="bio", res=10)

# Get the class for our rasters.
class(bio)

# Return details of our rasters.
bio


## -------------------------------------------------------------------------------------------------------------------
# Using one set of [] returns a 'list' of length 1 with the raster inside.
class(bio[12])

# Using two sets of [] returns the actual raster layer.
class(bio[[12]])

# Return the raster layer.
bio[[12]]


## -------------------------------------------------------------------------------------------------------------------
# Create a scale of 100 rainbow colours.
rainbow_colours <- rainbow(100)

# Plot annual precipitation (mm) with our colours.
plot(bio[[12]], col=rainbow_colours)


## -------------------------------------------------------------------------------------------------------------------
# Create a blank raster in longitude and latitude that matches our bioclim data.
blank_raster <- raster(res=0.1666667, xmn=-180, xmx=180, ymn=-60, ymx=90,
                  crs="+proj=longlat +datum=WGS84 +towgs84=0,0,0")

# We can assign values to all the cells.
values(blank_raster) <- seq(from = 1, to = ncell(blank_raster), by = 1)

# Return the raster.
blank_raster

# Plot the raster.
plot(blank_raster)


## -------------------------------------------------------------------------------------------------------------------
# First load in the spatial packages we'll need.
library(sf)

# Load the data into our environment.
load("data/accipitridae_ranges.RData")

# Inspect the maps.
class(accip_ranges)
head(accip_ranges)


## -------------------------------------------------------------------------------------------------------------------
#  Take the range polygon from the first row.
plot(accip_ranges$Shape[1], axes=TRUE)


## -------------------------------------------------------------------------------------------------------------------
# Load fasterize package.
library(fasterize)

# Start by creating an empty raster stack to store our data in.
raster_template <- raster(ncols=2160, nrows = 900, ymn = -60)

# Create a map of species richness by summing overlapping ranges.
range_raster <- fasterize(accip_ranges, raster_template, fun = "sum")

# Plot the new map.
plot(range_raster, col=heat.colors(50))


## -------------------------------------------------------------------------------------------------------------------
library(tidyr)
library(ggplot2)

# Convert the raster into a raster dataframe. This will be coordinates of the 
# raster pixels (cols x and y) and the value of the raster pixels. 
raster_data <- as.data.frame(range_raster, xy=TRUE) 

# Remove NAs with no information (like parts of the sea)
raster_data <- na.omit(raster_data)

# Change the column names to something sensible.
colnames(raster_data) <- c("long", "lat", "richness")


## ----fig.width = 12, fig.height = 6---------------------------------------------------------------------------------
# Create a plot with ggplot (the plus signs at the end of a line carry over to the next line).
range_plot <- ggplot(raster_data) +
  
  # borders imports all the country outlines onto the map. 
  # colour changes the colour of the outlines.
  # fill changes the colour of the insides of the countries.
  # this will grey out any terrestrial area which isn't part of a range.
  borders(ylim = c(-60,90), fill = "grey90", colour = "grey90") +
  
  # Borders() xlim is -160/200 to catch the edge of russia. 
  # We need to reset the xlim to -180/180 to fit our raster_stack.
  xlim(-180, 180) + 
  
  # Add the range information on top.
  geom_tile(aes(x=long, y=lat, fill= richness)) +
  
  # Add a colour blind friendly scale.
  scale_fill_viridis_c() +
  
  # Add title.
  ggtitle("Accipitidae Species Richness") + 
  
  # Add the classic theme (things like gridlines, font etc.)
  theme_classic() +
  
  # Add axes labels.
  ylab("Latitude") + 
  xlab("Longitude") + 
  
  # coord_fixed() makes ggplot keep our aspect ratio the same.
  coord_fixed() 

# Change the size of the plot window and return the plot.
#options(repr.plot.width=15, repr.plot.height=10)
range_plot


## -------------------------------------------------------------------------------------------------------------------
# Open up a new plotting device which will save a photo.
jpeg("my_map.jpeg")

# Add the plot to the plotting device.
range_plot

# Turn off the plotting device to save it.
dev.off()


## -------------------------------------------------------------------------------------------------------------------
# A basic ggplot structure. Main data for plotting goes inside ggplot()
ggplot(passerines) + geom_point(aes(x = log_mass, y = tarsus_length))



## We have chosen to teach the BCB practicals predominantly using base `R`. This is because anyone new to `R` needs to learn how base `R` works first. However, more and more researchers are choosing to use a group of packages for data handling called the `tidyverse`. These packages provide a slightly different way of coding in `R`, which makes data handling easier. I've already mentioned `ggplot2`, a `tidyverse` package, and one of the most useful in `R`!. We'll cover a few key packages for some  of the practical tasks, but if you'd like to know about coding in the 'tidy' way:

## 

## https://www.tidyverse.org/

## 


## -------------------------------------------------------------------------------------------------------------------
# Load packages.
library(ape)
library(phytools)


## -------------------------------------------------------------------------------------------------------------------
# First we set a seed. This isn't specific to phylogenies, but means we use the 
# same random numbers every time. This is because random numbers from your 
# computer are generated using the internal clock. Google it for more info!
set.seed(0)

# rtree creates a random tree.
plot(rtree(10), "unrooted")

# Plot clade label.
rect(1.3,2.0,2.5,2.7, border = "grey")
text(2.8, 2.5, "Clade")

# Plot node label.
arrows(0.35,0.9,0.75,1, length = 0.125, angle = 20, code = 1)
text(1.0, 1, "Node")

# Plot edge label.
arrows(0.65,1.45,0.15,1.4, length = 0.125, angle = 20, code = 1)
text(-0.1, 1.4, "Edge")

# Plot tip label.
arrows(-0.15,2.8,-0.45,2.95, length = 0.125, angle = 20, code = 1)
text(-0.6, 3, "Tip")


## -------------------------------------------------------------------------------------------------------------------
# You can also read in trees directly from text by specifying the branch 
# lengths after each node/tip. More info below!
tree <- read.tree(text = "(((Homo:1, Pan:1):1, Gorilla:1):1, Pongo:1);")
plot(tree)

# Plot root label.
lines(c(-0.5,0), c(3.18,3.18))
arrows(0.03,3.18,0.35,3.18, length = 0.125, angle = 20, code = 1)
text(0.5, 3.18, "Root")


## -------------------------------------------------------------------------------------------------------------------
# Read in a text tree and plot.
tree <- read.tree(text = "(((Homo:6.3, Pan:6.3):2.5, Gorilla:8.8):6.9, Pongo:15.7);")
plot(tree)

# Add an axis along the bottom.
axisPhylo()


## -------------------------------------------------------------------------------------------------------------------
# Read in the tree from a file in the data folder.
fishtree <- read.tree("data/elopomorph.tre")


## Be sure you are always in the right directory. Remember you can navigate in `R`

## using `setwd()`, `getwd()` and `list.files()` (to see what's in the current directory).


## -------------------------------------------------------------------------------------------------------------------
# Return the object.
fishtree

# Get the structure of the object.
str(fishtree)


## -------------------------------------------------------------------------------------------------------------------
# Plot the tree. 
plot(fishtree, cex = 0.5)


## -------------------------------------------------------------------------------------------------------------------
# Zoom into the tree.
zoom(fishtree, grep("Gymnothorax", fishtree$tip.label), subtree = FALSE, cex = 0.8)


## -------------------------------------------------------------------------------------------------------------------
# Pull out the Gymnothorax tips.
zoom(fishtree, grep("Gymnothorax", fishtree$tip.label), subtree = TRUE, cex = 0.8)


## -------------------------------------------------------------------------------------------------------------------
# Change the plotting parameters back to 1 row and 1 column.
par(mfrow = c(1, 1))


## If you're plots are coming out weird, resetting the plotting device is a good first

## move. Use `dev.off()` first and see if it fixes it. A minor warning that it will

## delete all the previous plots, but this is why we use scripts!


## -------------------------------------------------------------------------------------------------------------------
# Help function.
?plot.phylo


## Remeber that using the question mark (`?`) can also be done for every function.

## The help pages may look confusing/intimidating at first but you quickly get used

## to the set up.


## -------------------------------------------------------------------------------------------------------------------
plot(fishtree, type = "unrooted", edge.color = "deeppink", tip.color = "springgreen",  cex = 0.7)


## -------------------------------------------------------------------------------------------------------------------
# Read in the turdidae (thrush) tree.
turdidae_tree <- read.nexus("data/turdidae_birdtree.nex")


## -------------------------------------------------------------------------------------------------------------------
# Sample a random tree. Because we set our seed earlier this will be the same 
# random tree for everyone. 
ran_turdidae_tree <- sample(turdidae_tree, size=1)[[1]]

# Use the plot tree function from phytools to plot a fan tree.
plotTree(ran_turdidae_tree, type="fan", fsize=0.4, lwd=0.5,ftype="i")


## -------------------------------------------------------------------------------------------------------------------
# Lets see the first 10 species.
head(ran_turdidae_tree$tip.label, 10)


## -------------------------------------------------------------------------------------------------------------------
# Create an string object of the name we want to remove.
drop_pattern <- "Myadestes"

# sapply will iterate a given function over a vector (check out apply, lapply, apply for more info).
# In this case, we're using the grep function to ask if any species name in our tip label list matches the drop pattern. 
tip_numbers <- sapply(drop_pattern, grep, ran_turdidae_tree$tip.label)

# We then use the tip numbers to select only the tips we want.
drop_species <- ran_turdidae_tree$tip.label[tip_numbers]
drop_species


## -------------------------------------------------------------------------------------------------------------------
# drop.tip will remove any matching tips from the tree.
ran_turdidae_tree_NM <- drop.tip(ran_turdidae_tree, drop_species)

# Plot the tree.
plotTree(ran_turdidae_tree_NM, type="fan", fsize=0.4, lwd=0.5, ftype="i")


## -------------------------------------------------------------------------------------------------------------------
# Set diff will find all the tips that don't match drop_species.
species_we_dont_want <- setdiff(ran_turdidae_tree$tip.label, drop_species)

# Set diff will find all the tips that don't match drop_species, and then drop.tip will remove them
pruned_birdtree <- drop.tip(ran_turdidae_tree, species_we_dont_want)

# Plot the smaller tree.
plotTree(pruned_birdtree, ftype="i")


## You can save your new revised tree. This can save time reading in a big tree just

## to remove tips. You'll notice in later practicals that the phylogenetic tree for

## all birds is large, and takes a while to read into R, so it's worth saving pruned trees!

## You can save trees using `write.tree`, the same as you would save a dataframe.


## -------------------------------------------------------------------------------------------------------------------
# Load packages from the tidyverse. 
library(stringr)
library(dplyr)


## -------------------------------------------------------------------------------------------------------------------
# Copy a list of all the tips from the tree.
bird_tips <- ran_turdidae_tree$tip.label

# Split the labels into two strings where there's an underscore 
# (simplfy returns the splits as separate columns in a dataframe)
bird_genera <- bird_tips %>% str_split(pattern = "_", simplify= TRUE)
colnames(bird_genera) <- c("Genus", "Species")

# Pull out the rows that have an distinct genus name. 
# This will be the first instance in the dataframe for that genus.
bird_genera <- as.data.frame(bird_genera) %>% distinct(Genus, .keep_all = TRUE)
bird_genera


## -------------------------------------------------------------------------------------------------------------------
# Combine the columns and add back in the underscore so they match the labels in the tree.
genera_tips <- paste(bird_genera$Genus, bird_genera$Species, sep="_")

# Pull out the tips we want to drop.
drop_tips <- setdiff(ran_turdidae_tree$tip.label, genera_tips)

# Remove all the species except one per genus.
genera_tree <- drop.tip(ran_turdidae_tree, drop_tips)
plotTree(genera_tree, ftype="i")


## -------------------------------------------------------------------------------------------------------------------
# It's definitely worth checking that the labels match up properly when you change tip labels.
par(mfrow=c(1, 2))
plotTree(genera_tree, ftype="i")

# Swap species names for genera.
genera_tree$tip.label <- bird_genera$Genus
plotTree(genera_tree, ftype="i")


## -------------------------------------------------------------------------------------------------------------------
# Read in the data and check it worked.
turdidae_data <- read.csv("data/turdidae_data.csv")
str(turdidae_data)


## -------------------------------------------------------------------------------------------------------------------
# Replace the blank space with an underscore.
turdidae_data$jetz_name <- turdidae_data$jetz_name %>% str_replace(" ", "_")
head(turdidae_data)


## -------------------------------------------------------------------------------------------------------------------
# %in% returns a list of logicals (TRUE or FALSE) for each object in the vector.
turdidae_data$jetz_name %in% ran_turdidae_tree$tip.label


## -------------------------------------------------------------------------------------------------------------------
# See which species are NOT in the tip labels.
index <- !(turdidae_data$jetz_name %in% ran_turdidae_tree$tip.label)
turdidae_data[index,]


## -------------------------------------------------------------------------------------------------------------------
# Get the species that ARE in the tips.
index <- turdidae_data$jetz_name %in% ran_turdidae_tree$tip.label

# Select only these species.
turdidae_data <- turdidae_data[index,]


## -------------------------------------------------------------------------------------------------------------------
# Get the tips we don't want.
drop_tips <- setdiff(ran_turdidae_tree$tip.label, turdidae_data$jetz_name)

# Drop species.
turdi_tree <- drop.tip(ran_turdidae_tree, drop_tips)
plotTree(turdi_tree, ftype="i")


## -------------------------------------------------------------------------------------------------------------------
# Load ggtree for plotting phylogenies.
library(ggtree)


## -------------------------------------------------------------------------------------------------------------------
# Create a plot of the tree with a circular layout.
turdidae_plot <- ggtree(turdi_tree, layout = "circular")

# Return the plot. This will show our plot.
turdidae_plot


## -------------------------------------------------------------------------------------------------------------------
# Create a plot of the tree with a circular layout.
turdidae_plot <- ggtree(turdi_tree, layout = "circular") + geom_tiplab()

# Return the plot. This will show our plot.
turdidae_plot


## -------------------------------------------------------------------------------------------------------------------
# Create a plot of the tree with a circular layout.
turdidae_plot <- ggtree(turdi_tree, layout = "circular") + geom_tiplab(size = 1.5)

# Return the plot. This will show our plot.
turdidae_plot


## -------------------------------------------------------------------------------------------------------------------
# Add a column that's the node number matching the tree.
turdidae_data$node <- nodeid(turdi_tree, turdidae_data$jetz_name)

# Join our data and tree together.
turdi_tree_data <-  full_join(turdi_tree, turdidae_data, by = "node")


## -------------------------------------------------------------------------------------------------------------------
(turdidae_plot <- ggtree(turdi_tree_data, layout="fan", open.angle = 15, aes(colour=habitat)) + 
   geom_tiplab(size = 1.5) +
   scale_color_manual(values = c("firebrick", "navy", "forest green"), breaks=c("Dense", "Semi-Open", "Open")))


## Notice when we put an extra `()` around the entire line of code, it saves the plot

## as an object, and prints the plot at the same time.


## -------------------------------------------------------------------------------------------------------------------
# There's lots of code here for the theme, which puts the legend in the middle.
(turdidae_plot <- ggtree(turdi_tree_data, layout="fan", open.angle = 15, size = 0.7) + 
   
   # Make sure the tip labels are coloured black, and offset from the tree.
   geom_tiplab(size = 1.5, colour = "black", offset = 1) + 
   
   # Add the tip points.
   geom_tippoint(mapping=aes(colour=body_mass), size=2, show.legend=TRUE) + 
   
   # This is all for legend placement and size.
   theme(legend.title=element_blank(), 
        legend.position = c(0.65,0.45), legend.direction = "horizontal", legend.title.align = 1,
        legend.key.width = unit(1.2, "cm"), legend.key.height = unit(0.16, "cm"), 
        legend.text = element_text(size = 14), legend.margin = NULL) +
   
   # Add the colour scheme.
   scale_colour_viridis_c(name = "Body Mass"))


## -------------------------------------------------------------------------------------------------------------------
# Use the ggtree extra package for adding plots to circular trees.
library(ggtreeExtra)
(turdidae_plot <- ggtree(turdi_tree_data, layout="fan", size = 0.7) +
    
    # Geom fruit allows us to specify the ggplot geom we want.
    geom_fruit(geom=geom_bar,
               mapping=aes(y=node, x=body_mass),
               pwidth=0.38,
               orientation="y", 
               stat="identity", fill="navy", colour="navy", width=0.2) + 
    # We can remove some of the white space around our plot by setting the margins to negative values.
  theme(plot.margin=margin(-80,-80,-80,-80)))


