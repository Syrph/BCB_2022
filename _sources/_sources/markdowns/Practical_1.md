## Basics in R

### 1. Introduction and resources

The aim of this practical is to revise some basic functions in `R`
relating to data management and plotting. We will then look at handling
spatial data.

#### Working directory and using scripts

The first step when starting a new session is to set your working
directory. Think of it as the ‘folder’ that you work out of on your
computer. Unless you specify differently, anything that you read in or
save will be in this folder. The working directory is set using the
function `setwd()` and the path to the folders location, for example:

`setwd("C:/Users/rb417/Desktop/BCB_Practicals")`

You can also see what folder you’re currently in:

`getwd()`

I recommend storing all the files you need for the practicals in one
folder called “BCB\_Practicals”, and setting your working directory to
this folder at the start of each R session. If you’re in `RStudio` you
can also use `Tools -> Global Options` to change your default working
directory to your preferred folder.

Remember that you can find the R help for a particular function by using
`?function` or `??function` e.g. `?setwd`. Also recall that `ls()` lists
and `rm(list=ls())` clears your workspace.

You can open a new script by going to `File -> New File -> R script`.
Also on windows you can type `CTRL + SHIFT + N`. Remember that when you
save this script you need to add .R (Practical1.R). Save often! Although
you can write commands directly into the console window, using a script
allows you to save a record of your code that can easily be re-run. This
is particularly useful if you find a mistake later on, or want to update
models with new data.

To run a single line of your script at a time in windows, a convenient
short cut is `CTRL + ENTER`.

#### Installing and using packages for practicals

Throughout the practicals we will be using different R packages to
tackle different tasks. If you’re using `RStudio Cloud` all the
necessary packages should come pre-installed. If you are using your own
laptop you will need to install packages like so:

``` r
# Install ggplot2 for making fancy plots.
#install.packages("ggplot2")
```

You can also upgrade packages in the same way if you need to.

### 2. Revision of data types

We’ll start with some basics data manipulation in R to get started.

For anyone unfamiliar, ‘\#’ proceeds comments in scripts that won’t be
acted on by R, which allows us to label our scripts. Comments are very
useful! Try and make as many comments as possible, and use more detail
than you think you need. You’d be suprised how quickly you can forget
what a function or script does, so detailed comments are a lifesaver!

``` r
# We'll first try defining some basic variables

# A number
a <- 5.7
a
```

    ## [1] 5.7

``` r
class(a)
```

    ## [1] "numeric"

``` r
# A string
b <- "hello"
b
```

    ## [1] "hello"

``` r
class(b)
```

    ## [1] "character"

``` r
# A logical object
c <- TRUE
c
```

    ## [1] TRUE

``` r
class(c)
```

    ## [1] "logical"

In R variables are stored as vectors. Often vectors will be lists of
variables such as 1,2,3,4,5. However, even single variables are still
stored as vectors! Try `is.vector()` on each of the variables you just
created to see! Vectors are one of the most basic (and useful) ways of
storing data in R.

Now we’ll try creating some basic vectors and manipulating them.

``` r
# Generates a sequence from 0 to 9 by intervals of 1. Try ?seq() for more information
d <- seq(0, 9, 1) 
d
```

    ##  [1] 0 1 2 3 4 5 6 7 8 9

``` r
# Cocatenate variables into one vector
e <- c(0,1,2,3,4,5,6,7,8,9)
e
```

    ##  [1] 0 1 2 3 4 5 6 7 8 9

`c()` is one of the most used functions in R! It allows you to join
together two objects. For example:

``` r
f <- c(d,e)
f
```

    ##  [1] 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9

``` r
# Vectors can also be strings or logicals
g <- c("red","blue","green")
g
```

    ## [1] "red"   "blue"  "green"

``` r
class(g)
```

    ## [1] "character"

``` r
h <- c(TRUE, TRUE, FALSE)
h
```

    ## [1]  TRUE  TRUE FALSE

``` r
class(h)
```

    ## [1] "logical"

``` r
# find the length of a vector
length(e) 
```

    ## [1] 10

``` r
# Indexing is an easy way to pull out certain elements of a vector based on their position
e[1] # the first element
```

    ## [1] 0

``` r
e[5] # the fifth element
```

    ## [1] 4

``` r
e[10] # the tenth element
```

    ## [1] 9

``` r
# Indexing can also pull out groups of variables

e[1:5] # elements 1 to 5
```

    ## [1] 0 1 2 3 4

``` r
e[c(1,4)] # elements 1 and 4
```

    ## [1] 0 3

``` r
e[-4] # e without the fourth element
```

    ## [1] 0 1 2 4 5 6 7 8 9

Vectors can be combined into a matrix.

``` r
numbers <- c(1,2,3,4,5)
other.numbers <- c(6,7,8,9,10)
all.numbers <- cbind(numbers, other.numbers) # cbind is short for column bind, which joins two vectors together as columns
all.numbers
```

    ##      numbers other.numbers
    ## [1,]       1             6
    ## [2,]       2             7
    ## [3,]       3             8
    ## [4,]       4             9
    ## [5,]       5            10

``` r
class(all.numbers)
```

    ## [1] "matrix" "array"

Dataframes are special case of matrices, where each column can be a
different type. Often this is how ecological data will be collected and
stored. This is also most often what you will be handling in R.

``` r
numbers <- c(1,2,3,4,5)
characters <- c("a","b","c","d","e")
both.types <- cbind(numbers, characters)
both.types
```

    ##      numbers characters
    ## [1,] "1"     "a"       
    ## [2,] "2"     "b"       
    ## [3,] "3"     "c"       
    ## [4,] "4"     "d"       
    ## [5,] "5"     "e"

``` r
class(both.types)
```

    ## [1] "matrix" "array"

What happened there? ‘both.types’ was a matrix and not a dataframe. Be
careful combining strings and numbers together without specifying that
you want a dataframe. R will coerce the numbers in strings, so each
value is represented as “1”, “2”, “3”… rather than as actual numbers.

``` r
both.types[numbers]
```

    ## [1] "1" "2" "3" "4" "5"

``` r
class(both.types[numbers])
```

    ## [1] "character"

Instead try being more explicit.

``` r
both.types <- data.frame(numbers, characters)
both.types
```

    ##   numbers characters
    ## 1       1          a
    ## 2       2          b
    ## 3       3          c
    ## 4       4          d
    ## 5       5          e

``` r
class(both.types)
```

    ## [1] "data.frame"

``` r
class(both.types$numbers)
```

    ## [1] "numeric"

\*\*An important note: It’s tempting to name variables as single letters
(a, b, c) as we did at the beginning of the practical. However, for
anything slightly more complex than what we’ve done this becomes
confusing very quickly. It’s much better to use longer variables like
‘numbers’ or ‘letters’. This describes what the variable is, and makes
it easier for yourself and others to read your code and understand it!
An easy way to separate words is to use periods ‘.’ or underscores
’\_’.\*\*

Dataframes have lots of useful functions that make them easy to use.
First we’ll make a slightly longer dataframe.

``` r
small.numbers <- seq(1, 10, 1)
large.numbers <- seq(100, 1000, 100)

all.numbers <- data.frame(small.numbers, large.numbers)
all.numbers
```

    ##    small.numbers large.numbers
    ## 1              1           100
    ## 2              2           200
    ## 3              3           300
    ## 4              4           400
    ## 5              5           500
    ## 6              6           600
    ## 7              7           700
    ## 8              8           800
    ## 9              9           900
    ## 10            10          1000

``` r
# Get the top 6 values
head(all.numbers)
```

    ##   small.numbers large.numbers
    ## 1             1           100
    ## 2             2           200
    ## 3             3           300
    ## 4             4           400
    ## 5             5           500
    ## 6             6           600

``` r
# Get the bottom 6 values
tail(all.numbers)
```

    ##    small.numbers large.numbers
    ## 5              5           500
    ## 6              6           600
    ## 7              7           700
    ## 8              8           800
    ## 9              9           900
    ## 10            10          1000

``` r
#Get the structure of the dataframe
str(both.types)
```

    ## 'data.frame':    5 obs. of  2 variables:
    ##  $ numbers   : num  1 2 3 4 5
    ##  $ characters: chr  "a" "b" "c" "d" ...

``` r
# Get the number of rows and columns
nrow(all.numbers)
```

    ## [1] 10

``` r
ncol(all.numbers)
```

    ## [1] 2

``` r
# Change the column names
colnames(all.numbers) <- c("small_numbers", "large_numbers")
colnames(all.numbers)
```

    ## [1] "small_numbers" "large_numbers"

``` r
# Change just one column name
colnames(all.numbers)[1] <- "one_to_ten"
colnames(all.numbers)
```

    ## [1] "one_to_ten"    "large_numbers"

Indexing dataframes is similar to indexing vectors. The only difference
is now there is two dimensions, separated with commas. You can also
leave either dimension blank to select all the rows or columns.

``` r
# First row and first column
all.numbers[1,1]
```

    ## [1] 1

``` r
# First column
all.numbers[,1]
```

    ##  [1]  1  2  3  4  5  6  7  8  9 10

``` r
# First row (because columns can contain different data types, selecting across a row returns a dataframe)
all.numbers[1,]
```

    ##   one_to_ten large_numbers
    ## 1          1           100

``` r
# You can also specify columns in a dataframe by using column names in two ways:

#Get the small numbers
all.numbers$one_to_ten
```

    ##  [1]  1  2  3  4  5  6  7  8  9 10

``` r
#Get the large numbers (the comma specifies to take them from all rows. Try adding in indexes to the left of the comma)
all.numbers[,"large_numbers"]
```

    ##  [1]  100  200  300  400  500  600  700  800  900 1000

### 3. Reading, writing and .Rdata files

Because we’re working with jupyter notebooks we won’t cover reading and
writing in much detail. Briefly, you can export data (especially
dataframes) using a few simple functions:

As a tab-separated text file

`write.table(dataframe.to.export, file="data.txt",sep="\t", row.names=FALSE)`

As a comma-separated file

`write.csv(dataframe.to.export, file="data.csv", row.names=FALSE)`

To read files back in:

`new.data <- read.table("data.txt",header=TRUE,sep="\t")`

`new.data <- read.csv("data.csv")`

Objects can also be saved as .RData and loaded back into R at a later
time using save() and load(). This is handy when models may take a long
time to run, and you don’t have to rerun them everytime you start a new
R session.

### 4. Plotting data

R can be used to produce a wide array of plots and has a large capacity
for customisation. We will touch upon some basic plots which are useful
to visual data during your analysis. For more advanced plots, most
biologists use the package *ggplot2*. A useful guide is the R cookbook,
that includes information on customising plots:
<http://www.cookbook-r.com/Graphs/>

We’ll start with a scatterplot.

``` r
# Create some data
x<-(1:10)
y<-seq(2,20,2)

# Plot a basic scatter plot
plot(x, y, pch=16, col="red", main="My plot", xlab="x values", ylab="y values")
```

![](Practical_1_files/figure-gfm/unnamed-chunk-31-1.png)<!-- -->

`pch` stands for ‘point character’ and is the symbol to denote values.
Try changing it to other values!

You can also get R to plot the scatter plot as a single line using
`type = "l"`

``` r
plot(x, y, col="red", main="My plot", xlab="x values", ylab="y values", type = "l")
```

![](Practical_1_files/figure-gfm/unnamed-chunk-32-1.png)<!-- -->

Some of the most useful plots for visualling the spread of data are
histograms and density plots. R comes built in with functions for
sampling distributions we can use for plots.

``` r
# Sample fifty points randomly from a normal distribution (try taking more or less samples to create smoother curves)
normal.distribution <-rnorm(50)

# Plot a histogram
hist(normal.distribution, main = "My histogram", xlab = "sample value")
```

![](Practical_1_files/figure-gfm/unnamed-chunk-33-1.png)<!-- -->

``` r
# Plot a density plot instead (where frequency of samples is normalised to sum to 1)
plot(density(normal.distribution), main = "My distribution", xlab = "sample value")
```

![](Practical_1_files/figure-gfm/unnamed-chunk-33-2.png)<!-- -->

``` r
# You can change the grapical parameters to plot graphs side by side
par(mfrow=c(1,2))
hist(normal.distribution, main = "My histogram", xlab = "sample value")
plot(density(normal.distribution), main = "My distribution", xlab = "sample value")
```

![](Practical_1_files/figure-gfm/unnamed-chunk-34-1.png)<!-- -->

``` r
# To reset your graph parameters to the default, simply turn off the open graphical device
dev.off()
```

    ## null device 
    ##           1

When plotting histograms, you can also use the arguement `breaks = n` to
manually set the number of breaks. Plots can also be saved as objects
for future use the same way as assigning any object. Also look at the
functions barplot() and boxplot().

You can export your plots using pdf(), jpeg() or png()

``` r
# Opens a new graphical device called 'my.plot.name.jpg' in the current working directory
jpeg("My.plot.name.jpg")

# Create a plot as usual
hist(normal.distribution, main = "My histogram", xlab = "sample value")

# Turn off the device to save any changes
dev.off()
```

    ## png 
    ##   2

### 5. Handling spatial data

As conservation biologists, you’ll often be required to handle spatial
data. This might be for plotting species’ ranges, predicting
distributions, redlist criteria, and many other reasons. There are two
common methods for handling spatial data, using GIS software such as
ARCGIS, or using R. Whilst GIS software is tempting because of its
visual interface, I would recomend using R. Because you can easily save
and rerun your scripts, you can perform repeatable analyses that isn’t
always possible when clicking buttons in a visual interface. You can
also upload your scripts when you publish papers, so that others can
verify your results. Furthermore, you’ll often have to do statistical
tests on your spatial data, and R has a multitude of packages to achieve
this. For this practical we’ll introduce you to handling simple spatial
data.

Spatial data is available in a number of formats. Shapefiles contain
spatial vector data for example spatial lines, points or polygons.
Rasters contain a grid of values in pixels. In this session we will look
at some examples.

First we will look at plotting rasters from the WorldClim dataset
(Hijmans et al. 2005). Specifically, we want bioclim variables which are
often used to describe species’ environmental niches. Google for more
info!

``` r
# Load the raster package for spatial data
library(raster)

# getData is a function from the raster package that allows us to download some spatial data. 
bio <- getData("worldclim", var="bio", res=10)

# Get the class for our rasters
class(bio)
```

    ## [1] "RasterStack"
    ## attr(,"package")
    ## [1] "raster"

``` r
# Return details of our rasters
bio
```

    ## class      : RasterStack 
    ## dimensions : 900, 2160, 1944000, 19  (nrow, ncol, ncell, nlayers)
    ## resolution : 0.1666667, 0.1666667  (x, y)
    ## extent     : -180, 180, -60, 90  (xmin, xmax, ymin, ymax)
    ## crs        : +proj=longlat +datum=WGS84 +no_defs 
    ## names      :  bio1,  bio2,  bio3,  bio4,  bio5,  bio6,  bio7,  bio8,  bio9, bio10, bio11, bio12, bio13, bio14, bio15, ... 
    ## min values :  -269,     9,     8,    72,   -59,  -547,    53,  -251,  -450,   -97,  -488,     0,     0,     0,     0, ... 
    ## max values :   314,   211,    95, 22673,   489,   258,   725,   375,   364,   380,   289,  9916,  2088,   652,   261, ...

We’ve downloaded 19 raster layers, with different information on
rainfall, temperature, and other environmental predictors. They are
organised in a ‘stack’, which is like a list of raster layers. As you
can see rasters have dimensions (the number of cells), a resolution (the
size of each cell), an extent (where it is located geographically) and a
crs, coordinate reference system (the set of coordinates used). When
working with spatial data you must ensure all files use the same
coordinate system. If different objects use different coordinate systems
you will need to reproject them to the same system using a function such
as `spTransform()`.

We can also use indexing to extract a specfic raster:

``` r
# Using one set of [] returns a 'list' of length 1 with the raster inside.
class(bio[12])
```

    ## [1] "matrix" "array"

``` r
# Using two sets of [] returns the actual raster layer.
class(bio[[12]])
```

    ## [1] "RasterLayer"
    ## attr(,"package")
    ## [1] "raster"

``` r
# Return the raster layer
bio[[12]]
```

    ## class      : RasterLayer 
    ## dimensions : 900, 2160, 1944000  (nrow, ncol, ncell)
    ## resolution : 0.1666667, 0.1666667  (x, y)
    ## extent     : -180, 180, -60, 90  (xmin, xmax, ymin, ymax)
    ## crs        : +proj=longlat +datum=WGS84 +no_defs 
    ## source     : bio12.bil 
    ## names      : bio12 
    ## values     : 0, 9916  (min, max)

Remember to use two square brackets to get the actual raster.

Now let’s try plotting our raster.

``` r
# Create a scale of 100 rainbow colours
rainbow_colours <- rainbow(100)

# plot annual precipitation (mm) with our colours
plot(bio[[12]], col=rainbow_colours)
```

![](Practical_1_files/figure-gfm/unnamed-chunk-39-1.png)<!-- -->

You can also create blank rasters of the desired extent and resolution.
The following code creates a raster of the same extent and resolution as
the precipitation raster. We can also assign values to the cells, such
as 0 in this case.

``` r
# Create a blank raster
blank_raster <- raster(res=0.1666667,xmn=-180,xmx=180,ymn=-60,ymx=90,
                  crs="+proj=longlat +datum=WGS84 +towgs84=0,0,0")

# We can assign values to all the cells
values(blank_raster) <- 0

# Return the raster
blank_raster
```

    ## class      : RasterLayer 
    ## dimensions : 900, 2160, 1944000  (nrow, ncol, ncell)
    ## resolution : 0.1666667, 0.1666667  (x, y)
    ## extent     : -180, 180.0001, -60.00003, 90  (xmin, xmax, ymin, ymax)
    ## crs        : +proj=longlat +datum=WGS84 +no_defs 
    ## source     : memory
    ## names      : layer 
    ## values     : 0, 0  (min, max)

Rasters can also be cropped to a certain extent. For example if we just
wanted to consider Egypt. First we’ll download the country information
as a spatial polygon. Spatial polygons are similar to rasters, but only
has an extent and crs, rather than cells with values.

``` r
# Download country boundary (http://www.gadm.org/)
Egypt <- getData("GADM", country="EGY", level=0) 

# Return our polygon (notice the lack of cell values and resolution)
Egypt
```

    ## class       : SpatialPolygonsDataFrame 
    ## features    : 1 
    ## extent      : 24.6981, 36.24875, 21.72539, 31.66792  (xmin, xmax, ymin, ymax)
    ## crs         : +proj=longlat +datum=WGS84 +no_defs 
    ## variables   : 2
    ## names       : GID_0, NAME_0 
    ## value       :   EGY,  Egypt

``` r
# Plot the polygon
plot(Egypt) 
```

![](Practical_1_files/figure-gfm/unnamed-chunk-41-1.png)<!-- -->

Now we can crop our rainfall layer to just Egypt.

``` r
# Crop precipitation raster to just show Egypt
Egypt_rain <- crop(bio[[12]], Egypt) 

# Plot our new rainfall map
plot(Egypt_rain)
```

![](Practical_1_files/figure-gfm/unnamed-chunk-42-1.png)<!-- -->

If you want to make the resolution higher, download the bioclim
variables again and change the resolution.

Next we will use IUCN range maps (IUCN 2015) to look at species
richness. This example is from the package letsR (Vilela, Villalobos &
Poisot 2015). This example uses IUCN data available the frog genus
Phyllomedusa.

``` r
# Load the library letsR
library(letsR)

# The data function loads the Phyllomedusa data directly into the R environment
data(Phyllomedusa)

# This is a SpatialPolygonsDataFrame containing the occurences of 32 species
Phyllomedusa 
```

    ## class       : SpatialPolygonsDataFrame 
    ## features    : 46 
    ## extent      : -78.42399, -35.0976, -34.9093, 11.45836  (xmin, xmax, ymin, ymax)
    ## crs         : NA 
    ## variables   : 4
    ## names       :              binomial, presence, origin, seasonal 
    ## min values  : Phyllomedusa araguari,        1,      1,        1 
    ## max values  :  Phyllomedusa venusta,        1,      1,        1

Let’s look at a specific species, Phyllomedusa ayeaye, as an example.

``` r
# Retrieve the polygon that matches the bionomial name "Phyllomedusa ayeaye". Notice the double =, which means equal to. One = works the same as <- 
Phyllomedusa_ayeaye <- Phyllomedusa[Phyllomedusa@data$binomial == "Phyllomedusa ayeaye",]

# Look at the attributes table
Phyllomedusa_ayeaye
```

    ## class       : SpatialPolygonsDataFrame 
    ## features    : 3 
    ## extent      : -47.30213, -46.274, -21.82913, -20.06817  (xmin, xmax, ymin, ymax)
    ## crs         : NA 
    ## variables   : 4
    ## names       :            binomial, presence, origin, seasonal 
    ## min values  : Phyllomedusa ayeaye,        1,      1,        1 
    ## max values  : Phyllomedusa ayeaye,        1,      1,        1

One of the cool things we can do with this presence absence data is make
distribution maps based on presences and absences.

``` r
# Creates presence absence grid using the P. ayeaye example. We can specify min and max values for x and y to zoom in our map. Try it without them.
# Resol tells the function to use 1 degree of latitude as the resolution for the grid.
P_ayeaye_presab <- lets.presab(Phyllomedusa_ayeaye, xmn=-90, xmx=-20, ymn=-50, ymx=20, resol=0.5)

# Plot the map
plot(P_ayeaye_presab)
```

![](Practical_1_files/figure-gfm/unnamed-chunk-45-1.png)<!-- -->

Phyllomedusa ayeaye has a tiny range! If we want to make a more
impressive map, we can use data on all 32 species to create a map of
species richness.

``` r
# Run the function with the spatialpolygon dataframe of all 32 species.
species_richness <- lets.presab(Phyllomedusa, xmn=-90, xmx=-20, ymn=-50, ymx=20, resol=1)

# Plot it
plot(species_richness)
```

![](Practical_1_files/figure-gfm/unnamed-chunk-46-1.png)<!-- -->

Of course, you can play around with plot settings to create some
impressive maps!

### 6. Using the Tidyverse

We have chosen to teach the BCB practicals predominantly using base `R`.
This is because anyone new to `R` needs to learn how base `R` works
first. However, more and more researchers are choosing to use a group of
packages for data handling called the `tidyverse`. These packages
provide a slightly different way of coding in `R`, which makes data
handling easier. I’ve already mentioned `ggplot2`, a `tidyverse`
package, and one of the most useful in `R`!. We’ll cover a few key
packages for some of the practical tasks, but if you’d like to know
about coding in the ‘tidy’ way:

<https://www.tidyverse.org/>
