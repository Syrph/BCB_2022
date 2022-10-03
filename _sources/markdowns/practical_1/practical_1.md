## Basics in R

### 1. Introduction and resources

The aim of this practical is to revise some basic functions in `R`
relating to data management and plotting. We will then look at handling
spatial data. One aim of this practical is to make sure everyone’s set
up is working well and fix any problems!

#### Working directory

The first step when starting a new session is to set your working
directory. Think of it as the ‘folder’ that you work out of on your
computer. Unless you specify differently, anything that you read in or
save will be in this folder. We can find out what working directory we
are in using the function `getwd()`:

``` r
# Get the current working directory. (Mine will be different to yours!)
getwd()
```

    ## [1] "C:/Users/rb417/Desktop/BCB_Backup/bcb_notebook_2021/markdowns/practical_1"

The working directory is set using the function `setwd()` and the path
to the folders location, for example:

`setwd("C:/Users/rb417/Desktop/BCB_Practicals")`

If you’re using RStudio Cloud, you should already be in the correct
directory, but if you’re working on your laptop I recommend storing all
the files you need for the practicals in one folder called
“BCB\_practicals”. You should then set your working directory to this
folder at the start of each R session.

```{tip}
If you're in `RStudio` you can also use 
`Tools -> Global Options` to change your default working directory to your 
preferred folder. This means every time you open RStudio you will already be in
correct place to begin.
```

#### Using scripts

You can open a new script by going to `File -> New File -> R script`.
Also on windows you can type `CTRL + SHIFT + N`. Save often! Although
you can write commands directly into the console window, using a script
allows you to save a record of your code that can easily be re-run. This
is particularly useful if you find a mistake later on, or want to update
models with new data. This is also a lifesaver when R crashes!

For anyone unfamiliar, ‘\#’ proceeds comments in scripts that won’t be
acted on by R, which allows us to label our scripts. Comments are very
useful! Try and make as many comments as possible, and use more detail
than you think you need. You’d be surprised how quickly you can forget
what a function or script does, so detailed comments are a lifesaver!

Spaces are also important for adding to scripts! Try and space out lines
of code with spaces, and add spaces wherever possible to make code
easier to run. For example:

``` r
# A nice script to say hi #

# Create a message.
my_message <- "Hello World."

# Print my message in the console.
print(my_message)
```

    ## [1] "Hello World."

If you start writing your scripts in this way from early on, you’ll find
future work much easier!

#### Installing and using packages for practicals

Throughout the practicals we will be using different R packages to
tackle different tasks. If you’re using `RStudio Cloud` all the
necessary packages should come pre-installed. If you are using your own
laptop you will need to install packages like so:

``` r
# Install ggplot2 for making fancy plots.
install.packages("ggplot2")
```

You can also upgrade packages in the same way if you need to.

Once we’ve installed packages they don’t automatically get loaded into
your `R` session. Instead you need to tell `R` to load them **every
time** you start a new `R` session and want to use functions from these
packages. To load the package `ggplot2` into your current `R` session:

``` r
library(ggplot2)
```

### 2. Revision of data types

We’ll start with some basic data manipulation in R to get started.

#### Vectors

``` r
# We'll first try defining some basic variables.

# A number.
a <- 5.7

# Running the variable returns it to the console.
a

# The class function tells us what type of variable.
class(a)
```

    ## [1] 5.7
    ## [1] "numeric"

```{tip}
To run a single line of your script at a time in windows, a convenient short 
cut is `CTRL + ENTER`.
```

``` r
# A string.
b <- "hello"
b
class(b)
```

    ## [1] "hello"
    ## [1] "character"

``` r
# A logical object.
c <- TRUE
c
class(c)
```

    ## [1] TRUE
    ## [1] "logical"

In R variables are stored as vectors. Often vectors will be lists of
variables such as 1,2,3,4,5. However, even single variables are still
stored as vectors! Try `is.vector()` on each of the variables you just
created to see! Vectors are one of the most basic (and useful) ways of
storing data in R.

Now we’ll try creating some longer vectors and manipulating them.

``` r
# Generates a sequence from 0 to 9 by intervals of 1. Try ?seq() for more information.
d <- seq(0, 9, 1) 
d
```

    ##  [1] 0 1 2 3 4 5 6 7 8 9

```{tip}
Remember that you can find the R help for a particular function by using 
`?function` e.g. `?seq`. You can also use `help(seq)` for the same effect.
```

``` r
# Concatenate variables into one vector.
e <- c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
e
```

    ##  [1] 0 1 2 3 4 5 6 7 8 9

`c()` is one of the most used functions in R! It allows you to join
together two objects. For example:

``` r
# Combine d and e into one vector.
f <- c(d, e)
f
```

    ##  [1] 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9

Vectors can also be strings or logicals.

``` r
# Create a vector of strings.
g <- c("red", "blue", "green")
g
class(g)
```

    ## [1] "red"   "blue"  "green"
    ## [1] "character"

``` r
# And a vector of logicals.
h <- c(TRUE, TRUE, FALSE)
h
class(h)
```

    ## [1]  TRUE  TRUE FALSE
    ## [1] "logical"

We can perform many operations on vectors.

``` r
# Find the length of a vector.
length(e) 

# Find the mean of the vector.
mean(e)

# Find the variance of the vector.
var(e)
```

    ## [1] 10
    ## [1] 4.5
    ## [1] 9.166667

Indexing is an easy way to pull out certain elements of a vector based
on their position.

``` r
# Return the first element of e.
e[1]

# Return the fifth element of e.
e[5]

# Return the tenth element of e.
e[10]
```

    ## [1] 0
    ## [1] 4
    ## [1] 9

Indexing can also pull out groups of variables.

``` r
# Elements 1 to 5.
e[1:5]

# Elements 1 and 4.
e[c(1,4)]

# e without the fourth element.
e[-4]
```

    ## [1] 0 1 2 3 4
    ## [1] 0 3
    ## [1] 0 1 2 4 5 6 7 8 9

#### Matrices and dataframes

Often we will need to use structures that are more complex than vectors
for storing data. The most simple is a matrix, with rows and columns all
with the same class of data. E.g. a matrix of numbers or strings.

Vectors can easily be combined into a matrix using `cbind` (short for
column bind).

``` r
# Create two vectors.
numbers <- c(1,2,3,4,5)
other_numbers <- c(6,7,8,9,10)

# Use the cbind function to bind together the two vectors as columns.
all_numbers <- cbind(numbers, other_numbers)

# View our new matrix.
all_numbers
```

    ##      numbers other_numbers
    ## [1,]       1             6
    ## [2,]       2             7
    ## [3,]       3             8
    ## [4,]       4             9
    ## [5,]       5            10

``` r
# Look at the class of our new variable.
class(all_numbers)
```

    ## [1] "matrix" "array"

Dataframes are special case of matrices, where each column can be a
different type. Often this is how ecological data will be collected and
stored. This is also most often what you will be handling in R.

``` r
# Create a vector of numbers.
numbers <- c(1,2,3,4,5)

# Create a vector of strings.
characters <- c("a","b","c","d","e")

# Bind both types together.
both_types <- cbind(numbers, characters)
both_types
```

    ##      numbers characters
    ## [1,] "1"     "a"       
    ## [2,] "2"     "b"       
    ## [3,] "3"     "c"       
    ## [4,] "4"     "d"       
    ## [5,] "5"     "e"

``` r
# Get the class.
class(both_types)
```

    ## [1] "matrix" "array"

What happened there? ‘both\_types’ was a matrix and not a dataframe. Be
careful combining strings and numbers together without specifying that
you want a dataframe. R will coerce the numbers in strings, so each
value is represented as “1”, “2”, “3”… rather than as actual numbers.

``` r
# Return values from the column called numbers.
both_types[, "numbers"]

# Check the class of the column called numbers.
class(both_types[, "numbers"])
```

    ## [1] "1" "2" "3" "4" "5"
    ## [1] "character"

Instead try being more explicit.

``` r
# Create a dataframe of both vectors.
both_types <- data.frame(numbers, characters)
both_types
```

    ##   numbers characters
    ## 1       1          a
    ## 2       2          b
    ## 3       3          c
    ## 4       4          d
    ## 5       5          e

``` r
# Get the class of both_types.
class(both_types)

# Get the class of the numbers column.
class(both_types$numbers)
```

    ## [1] "data.frame"
    ## [1] "numeric"

```{tip}
**An important note:** It's tempting to name variables as single letters (a, b, c) as we did at the beginning of the practical. However, for anything slightly more complex than what we've done this becomes confusing very quickly. It's much better to use longer variables like 'numbers' or 'letters'. This describes what the variable is, and makes it easier for yourself and others to read your code and understand it! An easy way to separate words is to use periods '.' or underscores '_'.
```

Dataframes have lots of useful functions that make them easy to use.
First we’ll make a slightly longer dataframe.

``` r
# Create two vectors.
small_numbers <- seq(1, 10, 1)
large_numbers <- seq(100, 1000, 100)

# Create a dataframe of the two vectors.
all_numbers <- data.frame(small_numbers, large_numbers)
all_numbers
```

    ##    small_numbers large_numbers
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
# Get the top 6 values.
head(all_numbers)
```

    ##   small_numbers large_numbers
    ## 1             1           100
    ## 2             2           200
    ## 3             3           300
    ## 4             4           400
    ## 5             5           500
    ## 6             6           600

``` r
# Get the bottom 6 values.
tail(all_numbers)
```

    ##    small_numbers large_numbers
    ## 5              5           500
    ## 6              6           600
    ## 7              7           700
    ## 8              8           800
    ## 9              9           900
    ## 10            10          1000

``` r
# Get the structure of the dataframe.
str(both_types)
```

    ## 'data.frame':    5 obs. of  2 variables:
    ##  $ numbers   : num  1 2 3 4 5
    ##  $ characters: chr  "a" "b" "c" "d" ...

``` r
# Get the number of rows and columns.
nrow(all_numbers)
ncol(all_numbers)
```

    ## [1] 10
    ## [1] 2

``` r
# Change the column names.
colnames(all_numbers) <- c("small_numbers", "large_numbers")
colnames(all_numbers)
```

    ## [1] "small_numbers" "large_numbers"

``` r
# Change just one column name.
colnames(all_numbers)[1] <- "one_to_ten"
colnames(all_numbers)
```

    ## [1] "one_to_ten"    "large_numbers"

Indexing dataframes is similar to indexing vectors. The only difference
is now there is two dimensions, separated with commas. You can also
leave either dimension blank to select all the rows or columns.

``` r
# First row and first column.
all_numbers[1,1]
```

    ## [1] 1

``` r
# First column.
all_numbers[,1]
```

    ##  [1]  1  2  3  4  5  6  7  8  9 10

``` r
# First row (because columns can contain different data types, selecting across 
# a row returns a dataframe).
all_numbers[1,]
```

    ##   one_to_ten large_numbers
    ## 1          1           100

You can also specify columns in a dataframe by using column names in two
ways:

``` r
# Get the small numbers.
all_numbers$one_to_ten

# Get the large numbers (the comma specifies to take them from all rows. 
# Try adding in indexes to the left of the comma).
all_numbers[,"large_numbers"]
```

    ##  [1]  1  2  3  4  5  6  7  8  9 10
    ##  [1]  100  200  300  400  500  600  700  800  900 1000

### 3. Reading, writing and .RData files

`R` can read files in lots of formats, including comma-delimited and
tab-delimited files. Excel (and many other applications) can output
files in this format (it’s an option in the `Save As` dialogue box under
the `File` menu).

To practice some plotting we’ll read in some bird trait data from the
AVONET database:

``` r
# Read in the avonet data. The file pathway is in quotation marks.
avonet_data <- read.csv("data/avonet_data.csv", header = TRUE)
```

You can use `read.delim` for tab delimited files or `read.csv` for comma
delimited files (**c**omma **s**eparated **v**alues). `header = TRUE`,
indicates that the first line of the data contains column headings. We
include the relative file pathway, so we’re saying we want to look in
our current working directory for the `data/` folder, and then look
inside for the `avonet_data.csv` file.

It’s always good practice to check the data after it’s been read in.

``` r
# Get the structure.
str(avonet_data)
```

    ## 'data.frame':    9872 obs. of  25 variables:
    ##  $ birdlife_name       : chr  "Accipiter albogularis" "Accipiter badius" "Accipiter bicolor" "Accipiter brachyurus" ...
    ##  $ birdlife_common_name: chr  "Pied Goshawk" "Shikra" "Bicolored Hawk" "New Britain Sparrowhawk" ...
    ##  $ jetz_name           : chr  "Accipiter_albogularis" "Accipiter_badius" "Accipiter_bicolor" "Accipiter_brachyurus" ...
    ##  $ jetz_order          : chr  "Accipitriformes" "Accipitriformes" "Accipitriformes" "Accipitriformes" ...
    ##  $ jetz_family         : chr  "Accipitridae" "Accipitridae" "Accipitridae" "Accipitridae" ...
    ##  $ redlist_cat         : chr  "LC" "LC" "LC" "VU" ...
    ##  $ beak_length_culmen  : num  27.7 20.6 25 22.5 21.1 20 20.5 19.2 20 25.4 ...
    ##  $ beak_length_nares   : num  17.8 12.1 13.7 14 12.1 11.9 11.5 10.6 11.2 13.9 ...
    ##  $ beak_width          : num  10.6 8.8 8.6 8.9 8.7 6.6 8.3 7.7 8.6 8.6 ...
    ##  $ beak_depth          : num  14.7 11.6 12.7 11.9 11.1 12 10.9 9.6 11 13.2 ...
    ##  $ tarsus_length       : num  62 43 58.1 61.2 46.4 48.7 52.6 60.3 43.6 62 ...
    ##  $ wing_length         : num  235 187 230 202 218 ...
    ##  $ kipps_distance      : num  81.8 62.5 56.6 64.1 87.8 42.9 38.9 81.3 49.5 77.8 ...
    ##  $ secondary1          : num  160 127 175 138 130 ...
    ##  $ hand_wing_index     : num  33.9 32.9 24.6 31.7 40.2 25.8 24 37.8 30 32.3 ...
    ##  $ tail_length         : num  169 141 186 141 154 ...
    ##  $ mass                : num  249 131 288 142 186 ...
    ##  $ habitat_density     : int  1 2 2 1 1 1 1 1 1 2 ...
    ##  $ migration           : int  2 3 2 2 3 1 2 2 2 3 ...
    ##  $ trophic_level       : chr  "Carnivore" "Carnivore" "Carnivore" "Carnivore" ...
    ##  $ trophic_niche       : chr  "Vertivore" "Vertivore" "Vertivore" "Vertivore" ...
    ##  $ primary_lifestyle   : chr  "Insessorial" "Insessorial" "Generalist" "Insessorial" ...
    ##  $ centroid_latitude   : num  -8.15 8.23 -10.1 -5.45 45.24 ...
    ##  $ centroid_longitude  : num  158.5 45 -60 150.7 45.3 ...
    ##  $ range_size          : num  37461 22374973 14309701 35581 2936752 ...

`str` shows the structure of the data frame (this can be a really useful
command when you have a big data file). It also tells you what kind of
variables `R` thinks you have (characters, integers, numeric, factors
etc.). Some `R` functions need the data to be certain kinds of variables
so it’s useful to check this.

The `head` function is also useful to check the data is correct.

``` r
# See the first 5 rows.
head(avonet_data, 5)
```

    ##           birdlife_name    birdlife_common_name             jetz_name      jetz_order  jetz_family
    ## 1 Accipiter albogularis            Pied Goshawk Accipiter_albogularis Accipitriformes Accipitridae
    ## 2      Accipiter badius                  Shikra      Accipiter_badius Accipitriformes Accipitridae
    ## 3     Accipiter bicolor          Bicolored Hawk     Accipiter_bicolor Accipitriformes Accipitridae
    ## 4  Accipiter brachyurus New Britain Sparrowhawk  Accipiter_brachyurus Accipitriformes Accipitridae
    ## 5    Accipiter brevipes      Levant Sparrowhawk    Accipiter_brevipes Accipitriformes Accipitridae
    ##   redlist_cat beak_length_culmen beak_length_nares beak_width beak_depth tarsus_length wing_length
    ## 1          LC               27.7              17.8       10.6       14.7          62.0       235.2
    ## 2          LC               20.6              12.1        8.8       11.6          43.0       186.7
    ## 3          LC               25.0              13.7        8.6       12.7          58.1       229.6
    ## 4          VU               22.5              14.0        8.9       11.9          61.2       202.2
    ## 5          LC               21.1              12.1        8.7       11.1          46.4       217.6
    ##   kipps_distance secondary1 hand_wing_index tail_length  mass habitat_density migration trophic_level
    ## 1           81.8      159.5            33.9       169.0 248.8               1         2     Carnivore
    ## 2           62.5      127.4            32.9       140.6 131.2               2         3     Carnivore
    ## 3           56.6      174.8            24.6       186.3 287.5               2         2     Carnivore
    ## 4           64.1      138.1            31.7       140.8 142.0               1         2     Carnivore
    ## 5           87.8      129.9            40.2       153.5 186.5               1         3     Carnivore
    ##   trophic_niche primary_lifestyle centroid_latitude centroid_longitude  range_size
    ## 1     Vertivore       Insessorial             -8.15             158.49    37461.21
    ## 2     Vertivore       Insessorial              8.23              44.98 22374973.00
    ## 3     Vertivore        Generalist            -10.10             -59.96 14309701.27
    ## 4     Vertivore       Insessorial             -5.45             150.68    35580.71
    ## 5     Vertivore        Generalist             45.24              45.33  2936751.80

Briefly, you can export data (especially dataframes) using a few simple
functions:

As a tab-separated text file

`write.table(dataframe_to_export, file="data.txt", sep="\t", row.names=FALSE)`

As a comma-separated file

`write.csv(dataframe_to_export, file="data.csv", row.names=FALSE)`

Objects can also be saved as .RData and loaded back into R at a later
time using save() and load(). This is handy when models may take a long
time to run, and you don’t have to rerun them every time you start a new
R session. Later on we’ll use .RData files to plot maps of bird ranges.

### 4. Plotting data

R can be used to produce a wide array of plots and has a large capacity
for customisation. We will touch upon some basic plots which are useful
to visual data during your analysis. For more advanced plots, most
biologists use the package *ggplot2*. A useful guide is the R cookbook,
that includes information on customising plots:
<http://www.cookbook-r.com/Graphs/>

We’ll start with a scatter plot to explore the relationship between body
mass and tarsus length. We might expect heavier birds to have longer
legs so we should potentially see a strong pattern. We’ll look in the
passeriforme order as most birds in this group have a similar body plan.

``` r
# First subset all our bird data for just passerine birds.
passerines <- subset(avonet_data, avonet_data$jetz_order == "Passeriformes")

# Remove any missing values.
passerines <- na.omit(passerines)

# Plot a basic scatter plot.
plot(passerines$mass, passerines$tarsus_length, pch=16, col="blue", 
     main="My plot", xlab="Body Mass", ylab="Tarsus Length")
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-41-1.png
:align: center
:width: 600px
```

`pch` stands for ‘point character’ and is the symbol to denote values.
Try changing it to other values!

There might be a pattern there but it’s hard to tell. This is because
body size across species is often log-normally distributed, with lots of
small species and a few large ones. We can check this by using some very
useful plots: histograms and density plots.

``` r
# Plot a histogram.
hist(passerines$mass, main = "My histogram", xlab = "Body Mass", breaks = 50)
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-42-1.png
:align: center
:width: 600px
```

``` r
# Plot a density plot instead (where frequency of samples is normalised to sum to 1).
plot(density(passerines$mass), main = "My distribution", xlab = "Body Mass")
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-42-2.png
:align: center
:width: 600px
```

You can change the graphical parameters to plot graphs side by side.

``` r
# The par function changes parameters. mfrow = c(1,2) means we want 1 row and 2 columns.
par(mfrow =c (1,2))

# Plot both plots as normal.
hist(passerines$mass, main = "My histogram", xlab = "Body Mass", breaks = 50)
plot(density(passerines$mass), main = "My distribution", xlab = "Body Mass")
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-43-1.png
:align: center
:width: 600px
```

```{tip}
When plotting histograms, you can also use the argument `breaks = n` to 
manually set the number of breaks.
```

``` r
# To reset your graph parameters to the default, simply turn off the open graphical device.
dev.off()
```

    ## RStudioGD 
    ##         2

So it’s true that there are many small species and few large. We can
take the natural log of body mass to better see if a pattern exists
between mass and tarsus.

``` r
# Create a new column with the log of body mass.
passerines$log_mass <- log(passerines$mass)

# See the new distribution.
hist(passerines$log_mass, main = "My histogram", xlab = "Log Mass", breaks = 50)
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-46-1.png
:align: center
:width: 600px
```

``` r
# Look at the scatter plot.
plot(passerines$log_mass, passerines$tarsus_length, pch=16, col="blue", 
     main="My plot", xlab="Body Mass", ylab="Tarsus Length")
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-46-2.png
:align: center
:width: 600px
```

Now we can see there’s a clear pattern! Exploring data like this is a
key part of any analysis.

We can export plots using `pdf()`, `jpeg()` or `png()`.

``` r
# Opens a new graphical device called 'my_plot.jpg' in the current working directory.
jpeg("my_plot.jpg")

# Create a plot as usual.
plot(passerines$log_mass, passerines$tarsus_length, pch=16, col="blue", 
     main="My plot", xlab="Body Mass", ylab="Tarsus Length")

# Turn off the device to save any changes.
dev.off()
```

    ## RStudioGD 
    ##         2

### 5. Handling spatial data

As conservation biologists, you’ll often be required to handle spatial
data. This might be for plotting species’ ranges, predicting
distributions, redlist criteria, and many other reasons. There are two
common methods for handling spatial data, using GIS software such as
ARCGIS, or using R. Whilst GIS software is tempting because of its
visual interface, I would recommend using R. Because you can easily save
and rerun your scripts, you can perform repeatable analyses that isn’t
always possible when clicking buttons in a visual interface. You can
also upload your scripts when you publish papers, so that others can
verify your results. Furthermore, you’ll often have to do statistical
tests on your spatial data, and R has a multitude of packages to achieve
this. For this practical we’ll introduce you to handling simple spatial
data.

```{tip}
One time you might want to use GIS software is for exploring your GIS data. It's 
easier to interactively explore maps using software before loading it into R. If 
you do need software, QGIS is free and open source, so you can continue to use it
after you've finished your degree!
```

Spatial data is available in a number of formats. Shapefiles contain
spatial vector data for example spatial lines, points or polygons.
Rasters contain a grid of values in pixels. In this session we will look
at some examples.

#### Rasters

First we will look at plotting rasters from the WorldClim dataset
(Hijmans et al. 2005). Specifically, we want bioclim variables which are
often used to describe species’ environmental niches. Google for more
info!

``` r
# Load the raster package for spatial data.
library(raster)

# getData is a function from the raster package that allows us to download some spatial data. 
bio <- getData("worldclim", var="bio", res=10)

# Get the class for our rasters.
class(bio)
```

    ## [1] "RasterStack"
    ## attr(,"package")
    ## [1] "raster"

``` r
# Return details of our rasters.
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

We can also use indexing to extract a specific raster:

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
# Return the raster layer.
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
# Create a scale of 100 rainbow colours.
rainbow_colours <- rainbow(100)

# Plot annual precipitation (mm) with our colours.
plot(bio[[12]], col=rainbow_colours)
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-51-1.png
:align: center
:width: 600px
```

You can also create blank rasters of the desired extent and resolution.
The following code creates a raster of the same extent and resolution as
the precipitation raster. We can also assign values to the cells, such
as 0 in this case.

``` r
# Create a blank raster in longitude and latitude that matches our bioclim data.
blank_raster <- raster(res=0.1666667, xmn=-180, xmx=180, ymn=-60, ymx=90,
                  crs="+proj=longlat +datum=WGS84 +towgs84=0,0,0")

# We can assign values to all the cells.
values(blank_raster) <- seq(from = 1, to = ncell(blank_raster), by = 1)

# Return the raster.
blank_raster
```

    ## class      : RasterLayer 
    ## dimensions : 900, 2160, 1944000  (nrow, ncol, ncell)
    ## resolution : 0.1666667, 0.1666667  (x, y)
    ## extent     : -180, 180.0001, -60.00003, 90  (xmin, xmax, ymin, ymax)
    ## crs        : +proj=longlat +datum=WGS84 +no_defs 
    ## source     : memory
    ## names      : layer 
    ## values     : 1, 1944000  (min, max)

``` r
# Plot the raster.
plot(blank_raster)
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-52-1.png
:align: center
:width: 600px
```

#### Spatial polygons

A polygon is another way that R stores spatial data. It records the
coordinates of each corner, which it can use to calculate the full
shape. Polygons also all have a coordinate reference system (such as
longitude and latitude) which is how R knows where the shapes belong in
the world. Unlike rasters, polygons only have an outline of an area, so
they don’t have cells with values.

To see some polygons we’ll use bird range data from the family
Accipitridae, which are birds of prey. For convenience we’ve saved the
range data as an `.RData` object, as we briefly mentioned in section 3.

``` r
# First load in the spatial packages we'll need.
library(sf)

# Load the data into our environment.
load("data/accipitridae_ranges.RData")

# Inspect the maps.
class(accip_ranges)
```

    ## [1] "sf"         "data.frame"

``` r
head(accip_ranges)
```

    ## Simple feature collection with 6 features and 3 fields
    ## Geometry type: MULTIPOLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: -17.53522 ymin: -29.47375 xmax: 167.2831 ymax: 55.85556
    ## Geodetic CRS:  WGS 84
    ##             ID               SCINAME DATE_                          Shape
    ## 10764 22695535 Accipiter_albogularis  2014 MULTIPOLYGON (((167.2819 -9...
    ## 1     22695490      Accipiter_badius  2013 MULTIPOLYGON (((-17.4704 14...
    ## 14087 22695605  Accipiter_brachyurus  2018 MULTIPOLYGON (((152.9669 -4...
    ## 13013 22695499    Accipiter_brevipes  2009 MULTIPOLYGON (((19.3891 39....
    ## 10777 22695494     Accipiter_butleri  2014 MULTIPOLYGON (((93.531 8.01...
    ## 6618  22695486 Accipiter_castanilius  2013 MULTIPOLYGON (((7.090881 6....

You can see that the range maps are stored in a spatial dataframe,
called an `sf` class of object. We have information about ranges stored
as text, and the spatial data stored as multipolygons. A multipolygon is
just a group of polygons, and is easiest to understand by plotting.

``` r
#  Take the range polygon from the first row.
plot(accip_ranges$Shape[1], axes=TRUE)
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-54-1.png
:align: center
:width: 600px
```

So we can see a multipolygon is just a collection of individual ranges,
with coordinates we can see on each axis.

#### Plotting maps

We can do cool things with polygons, like converting them into maps of
species richness! We’ll do this for the Accipitridae family by
overlapping ranges.

First we’re going to convert our sf dataframe of polygons into a raster
image. To do this we’ll use a function called called `fasterize`. This
package provides an updated version of the function `rasterize()`, but
much faster! Both functions take a set of polygons, and transform them
into rasters, using a template with the right size and resolution. We
can also tell `fasterize` how to deal with overlapping ranges, which
we’ll use to build a map of species richness.

``` r
# Load fasterize package.
library(fasterize)

# Start by creating an empty raster stack to store our data in.
raster_template <- raster(ncols=2160, nrows = 900, ymn = -60)

# Create a map of species richness by summing overlapping ranges.
range_raster <- fasterize(accip_ranges, raster_template, fun = "sum")

# Plot the new map.
plot(range_raster, col=heat.colors(50))
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-55-1.png
:align: center
:width: 600px
```

So now we can see where the highest species richness is. However, it
doesn’t look very pretty and countries without any ranges are left off
the map. We can make a much clearer map using `ggplot2`.

``` r
library(tidyr)
library(ggplot2)

# Convert the raster into a raster dataframe. This will be coordinates of the 
# raster pixels (cols x and y) and the value of the raster pixels. 
raster_data <- as.data.frame(range_raster, xy=TRUE) 

# Remove NAs with no information (like parts of the sea)
raster_data <- na.omit(raster_data)

# Change the column names to something sensible.
colnames(raster_data) <- c("long", "lat", "richness")
```

Now that our raster information is stored in a dataframe, we can use
`ggplot2`. When we make plots, we first initialise a plot using
`ggplot()`, and then add more instructions on top using `+`.

``` r
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
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-57-1.png
:align: center
:width: 600px
```

That looks much better than the first. Later you’ll experiment with your
own maps for your report. Try changing the colour scheme on this one!

You can save your plots as a file using different formats like a jpeg.
Watch out for how the map transforms when it’s saved and edit your plots
accordingly.

``` r
# Open up a new plotting device which will save a photo.
jpeg("my_map.jpeg")

# Add the plot to the plotting device.
range_plot

# Turn off the plotting device to save it.
dev.off()
```

    ## RStudioGD 
    ##         2

Of course, you can play around with plot settings to create some
impressive maps!

> Extra task: Can you recreate the plots from section 4 using ggplot2?
> You can use the R cookbook to learn more!
> <http://www.cookbook-r.com/Graphs/> If you’re stuck don’t be afraid to
> ask demonstrators for advice.

::::{admonition} Show the answer…  
:class: dropdown

``` r
# A basic ggplot structure. Main data for plotting goes inside ggplot()
ggplot(passerines) + geom_point(aes(x = log_mass, y = tarsus_length))
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-59-1.png
:align: center
:width: 600px
```

Can you customise it further with axes labels? Change the colour? Try
adding alpha = 0.5 inside geom\_point. What does it do? Also try out
histograms and density plots! The `ggpubr` package makes nice themes!

::::

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
