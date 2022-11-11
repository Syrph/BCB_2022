## Basics & Phylogenetics in R

### 1. Introduction and resources

The aim of this practical is to revise some basic functions in `R`
relating to data management and plotting. We will then look at handling
spatial data and phylogenies, two skills essential for macroecology. One
aim of this practical is to make sure everyone’s set up is working well
and fix any problems!

We will review importing phylogenetic trees as data files, displaying
phylogenetic trees visually, and some basic evolutionary computations
that can be conducted with phylogenetic trees. This practical will
deliver some of the important background for Coursework 1.

Parts (sections 6,7) of this practical are written by [Natalie
Cooper](http://nhcooper123.github.io/). The original can be found
[here](https://github.com/nhcooper123/TeachingMaterials/blob/master/PhD_Museum/VisualisingPhylo.Rmd).

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

    ## [1] "C:/Users/rb417/Dropbox/PhD/Teaching/BCB_2022/bcb_notebook_2022/markdowns/practical_1"

The working directory is set using the function `setwd()` and the path
to the folders location, for example:

`setwd("C:/Users/rb417/Desktop/BCB_Practicals")`

For the duration of the BCB course, I recommend storing all the files
you need for the practicals in one folder called “BCB_practicals”. You
should then set your working directory to this folder at the start of
each R session.

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
tackle different tasks. One of the strengths of using `R` is that there
are a ton of packages designed for ecological analysis. This can
streamline analysis, and means researchers can easily use similar
methods for different research projects.

`R` comes with a few essential packages pre-installed, but normally you
will have to install them like so:

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

Because we know which packages are in the practicals, we can save time
and install them all now. We’ll use the script `install.R`. You can open
it up and run each line of code manually, or you can run the script all
in one go using source:

``` r
# Install packages for the BCB practicals.
source("install.R")
```

```{tip}
Installing packages can often throw up errors, especially if you're using a Mac 
to run spatial packages (like we use in this practical). Please ask for help if 
you run into issues, demonstrators will be on hand! Once the packages are installed, 
you shouldn't have any issues running them in the future.
```

### 2. Revision of data types

We’ll start with some basic data manipulation in R to get started. For
anyone already quite familiar with `R`, feel free to skim over this
section.

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

What happened there? ‘both_types’ was a matrix and not a dataframe. Be
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

To practice reading in data and plotting, we’ll use the bird trait data
from the AVONET database.

```{tip}
AVONET is a global database of bird traits created by researchers at Imperial College, 
 with vital help from collaborators in countries all over the world. You'll use the database 
 for all three practicals, and the coursework projects, so it's worth checking out the publication
[**here**](https://doi.org/10.1111/ele.13898). The citation you should use in your reports is:  

Tobias, J.A., Sheard, C., Pigot, A.L., Devenish, A.J.M., Yang, J., Sayol, F. et al. (2022) AVONET: morphological, ecological and geographical data for all birds. *Ecology Letters*, 25, 581–597.
  
```

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

    ## 'data.frame':    9872 obs. of  28 variables:
    ##  $ birdlife_name       : chr  "Accipiter albogularis" "Accipiter badius" "Accipiter bicolor" "Accipiter brachyurus" ...
    ##  $ birdlife_common_name: chr  "Pied Goshawk" "Shikra" "Bicolored Hawk" "New Britain Sparrowhawk" ...
    ##  $ jetz_name           : chr  "Accipiter_albogularis" "Accipiter_badius" "Accipiter_bicolor" "Accipiter_brachyurus" ...
    ##  $ jetz_order          : chr  "Accipitriformes" "Accipitriformes" "Accipitriformes" "Accipitriformes" ...
    ##  $ jetz_family         : chr  "Accipitridae" "Accipitridae" "Accipitridae" "Accipitridae" ...
    ##  $ redlist_cat         : chr  "LC" "LC" "LC" "VU" ...
    ##  $ extinct_prob        : num  0.0606 0.0606 0.0606 0.2425 0.0606 ...
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
    ##  $ beak_shape          : num  -0.594 -0.538 -0.442 -0.499 -0.487 ...
    ##  $ body_shape          : num  -0.028 -0.227 -0.342 0.267 -0.271 ...

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

    ##           birdlife_name    birdlife_common_name             jetz_name      jetz_order  jetz_family redlist_cat
    ## 1 Accipiter albogularis            Pied Goshawk Accipiter_albogularis Accipitriformes Accipitridae          LC
    ## 2      Accipiter badius                  Shikra      Accipiter_badius Accipitriformes Accipitridae          LC
    ## 3     Accipiter bicolor          Bicolored Hawk     Accipiter_bicolor Accipitriformes Accipitridae          LC
    ## 4  Accipiter brachyurus New Britain Sparrowhawk  Accipiter_brachyurus Accipitriformes Accipitridae          VU
    ## 5    Accipiter brevipes      Levant Sparrowhawk    Accipiter_brevipes Accipitriformes Accipitridae          LC
    ##   extinct_prob beak_length_culmen beak_length_nares beak_width beak_depth tarsus_length wing_length kipps_distance
    ## 1     0.060625               27.7              17.8       10.6       14.7          62.0       235.2           81.8
    ## 2     0.060625               20.6              12.1        8.8       11.6          43.0       186.7           62.5
    ## 3     0.060625               25.0              13.7        8.6       12.7          58.1       229.6           56.6
    ## 4     0.242500               22.5              14.0        8.9       11.9          61.2       202.2           64.1
    ## 5     0.060625               21.1              12.1        8.7       11.1          46.4       217.6           87.8
    ##   secondary1 hand_wing_index tail_length  mass habitat_density migration trophic_level trophic_niche primary_lifestyle
    ## 1      159.5            33.9       169.0 248.8               1         2     Carnivore     Vertivore       Insessorial
    ## 2      127.4            32.9       140.6 131.2               2         3     Carnivore     Vertivore       Insessorial
    ## 3      174.8            24.6       186.3 287.5               2         2     Carnivore     Vertivore        Generalist
    ## 4      138.1            31.7       140.8 142.0               1         2     Carnivore     Vertivore       Insessorial
    ## 5      129.9            40.2       153.5 186.5               1         3     Carnivore     Vertivore        Generalist
    ##   centroid_latitude centroid_longitude  range_size beak_shape body_shape
    ## 1             -8.15             158.49    37461.21 -0.5939811 -0.0279868
    ## 2              8.23              44.98 22374973.00 -0.5381898 -0.2265797
    ## 3            -10.10             -59.96 14309701.27 -0.4418864 -0.3419256
    ## 4             -5.45             150.68    35580.71 -0.4985385  0.2672395
    ## 5             45.24              45.33  2936751.80 -0.4866800 -0.2710666

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
to visual data during your analysis. For more advanced plots useful in
your coursework, most biologists use the package *ggplot2*. A useful
guide is the R cookbook, that includes information on customising plots:
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

```{image} practical_1_files/figure-gfm/unnamed-chunk-44-1.png
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

```{image} practical_1_files/figure-gfm/unnamed-chunk-45-1.png
:align: center
:width: 600px
```

``` r
# Plot a density plot instead (where frequency of samples is normalised to sum to 1).
plot(density(passerines$mass), main = "My distribution", xlab = "Body Mass")
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-45-2.png
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

```{image} practical_1_files/figure-gfm/unnamed-chunk-46-1.png
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

    ## null device 
    ##           1

So it’s true that there are many small species and few large. We can
take the natural log of body mass to better see if a pattern exists
between mass and tarsus.

``` r
# Create a new column with the log of body mass.
passerines$log_mass <- log(passerines$mass)

# See the new distribution.
hist(passerines$log_mass, main = "My histogram", xlab = "Log Mass", breaks = 50)
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-49-1.png
:align: center
:width: 600px
```

``` r
# Look at the scatter plot.
plot(passerines$log_mass, passerines$tarsus_length, pch=16, col="blue", 
     main="My plot", xlab="Body Mass", ylab="Tarsus Length")
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-49-2.png
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

    ## png 
    ##   2

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
spatial vector data such as spatial lines, points or polygons. Rasters
contain a grid of values in cells. This is very similar to pixels in a
normal image. In this session we will look at polygons and rasters.

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
```

    ## Warning in getData("worldclim", var = "bio", res = 10): getData will be removed in a future version of raster
    ## . Please use the geodata package instead

``` r
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

```{image} practical_1_files/figure-gfm/unnamed-chunk-54-1.png
:align: center
:width: 600px
```

You can also create blank rasters of the desired extent and resolution.
The following code creates a raster of the same extent and resolution as
the precipitation raster. We can also assign values to the cells.

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

```{image} practical_1_files/figure-gfm/unnamed-chunk-55-1.png
:align: center
:width: 600px
```

#### Spatial polygons

A polygon is another way that R stores spatial data. It records the
coordinates of each corner, which it can use to calculate the full
shape. Polygons also have a coordinate reference system (such as
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
a group of single polygons, and is easiest to understand by plotting.

``` r
#  Take the range polygon from the first row.
plot(accip_ranges$Shape[1], axes=TRUE)
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-57-1.png
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
into rasters, using a template raster with the right size and
resolution. We can also tell `fasterize` how to deal with overlapping
ranges, which we’ll use to build a map of species richness.

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

```{image} practical_1_files/figure-gfm/unnamed-chunk-58-1.png
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

```{image} practical_1_files/figure-gfm/unnamed-chunk-60-1.png
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

    ## png 
    ##   2

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

```{image} practical_1_files/figure-gfm/unnamed-chunk-62-1.png
:align: center
:width: 600px
```

Can you customise it further with axes labels? Change the colour? Try
adding alpha = 0.5 inside geom_point. What does it do? Also try out
histograms and density plots! The `ggpubr` package makes nice themes!

::::

```{tip}
We have chosen to teach the BCB practicals predominantly using base `R`. This is because anyone new to `R` needs to learn how base `R` works first. However, more and more researchers are choosing to use a group of packages for data handling called the `tidyverse`. These packages provide a slightly different way of coding in `R`, which makes data handling easier. I've already mentioned `ggplot2`, a `tidyverse` package, and one of the most useful in `R`!. We'll cover a few key packages for some  of the practical tasks, but if you'd like to know about coding in the 'tidy' way: 

https://www.tidyverse.org/
```

### 6. An introduction to phylogenetic trees

This section will review some basic aspects of phylogenetic trees and
introduce how trees are handled at the level of software. Because you
are now interacting with phylogenetic trees for things like plotting, it
is also helpful to know some of the names for parts of phylogenetic
trees used in computer science.

To plot phylogenies (or use any specialized analysis) in R, you need one
or more additional packages from the basic R installation. For this
practical you will need to load the following packages:

``` r
# Load packages.
library(ape)
library(phytools)
```

#### Tree parameters

A phylogenetic tree is an ordered, multifurcating graph with labelled
**tips** (or **leaves**) (and sometimes labelled histories). It
represents the relative degrees of relationships of species (i.e. tips
or OTUs). The graph consists of a series of **branches** (or **edges**)
with join successively towards **nodes** (or **vertices**, *sing.*
**vertex**). Each node is subtended by a single branch, representing the
lineage of ancestors leading to a node. The node is thus the common
ancestor of two or more descendant branches. All the descendant branches
of a given node (and all of the their respective descendants) are said
to form a **clade** (or **monophyletic group**).

``` r
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
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-65-1.png
:align: center
:width: 600px
```

When we select a node to act as the base of a tree, the tree is said to
be **rooted**. At the bottom of a tree, is the **root node** (or simply
the **root**).

``` r
# You can also read in trees directly from text by specifying the branch 
# lengths after each node/tip. More info below!
tree <- read.tree(text = "(((Homo:1, Pan:1):1, Gorilla:1):1, Pongo:1);")
plot(tree)

# Plot root label.
lines(c(-0.5,0), c(3.18,3.18))
arrows(0.03,3.18,0.35,3.18, length = 0.125, angle = 20, code = 1)
text(0.5, 3.18, "Root")
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-66-1.png
:align: center
:width: 600px
```

Phylogenetic trees of the kind shown above are fairly simple and lack
information about time or character changes occurring along a branch. We
can assign branch length in the form of either time or the amount of
change/substitution along a branch. A tree with **branch lengths**
depicted can be called a **phylogram**.

When (an implied) dimension of time is being considered, all the tips of
the tree must be at the level representing the time in which they are
observed. For trees where all the species are extant, the tips are flush
at the top. This representation is called an **ultrametric** tree.

``` r
# Read in a text tree and plot.
tree <- read.tree(text = "(((Homo:6.3, Pan:6.3):2.5, Gorilla:8.8):6.9, Pongo:15.7);")
plot(tree)

# Add an axis along the bottom.
axisPhylo()
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-67-1.png
:align: center
:width: 600px
```

#### Informatic representations of tree

To perform any useful calculations on a tree, we need both a
computer-readable tree format and (in part) to understand how trees are
constructed in computer memory.

#### Text based formats

Storage of trees for transfer between different software is essential.
This is most commonly achieved with a text-based format stored in a
file. The most common file format for representing phylogenetic trees is
**Newick format**. This consists of clades represented within
parentheses. Commas separate each lade. Either tip names or symbols
representing the tips are nested within the lowest orders of
parentheses. Each tip or branch can be associated with a branch length
scalar that follows a colon.

For example:

`"(((Homo, Pan), Gorilla), Pongo);"`

Or with branch length:

`"(((Homo:6.3, Pan:6.3):2.5, Gorilla:8.8):6.9, Pongo:15.7);"`

Trees are also increasing use of XML formats such as PhyloXML and NeXML.

In this practical we are going to use the `elopomorph.tre` newick tree.
You can open it with a simple text editor to see the newick tree
structure.

#### Reading in a phylogeny from a file

Now let’s visualise some phylogenies! We’ll use the Elopomorpha (eels
and similar fishes) tree to start as it is simple.

To load a tree you need the function `read.tree`. Just like we did with
text but instead we point to a file location. `read.tree` can read any
newick format trees (see above) like the `elopomorph.tre` file.

``` r
# Read in the tree from a file in the data folder.
fishtree <- read.tree("data/elopomorph.tre")
```

```{tip}
Be sure you are always in the right directory. Remember you can navigate in `R` 
using `setwd()`, `getwd()` and `list.files()` (to see what's in the current directory). 
```

Let’s examine the tree by typing:

``` r
# Return the object.
fishtree
```

    ## 
    ## Phylogenetic tree with 62 tips and 61 internal nodes.
    ## 
    ## Tip labels:
    ##   Moringua_edwardsi, Kaupichthys_nuchalis, Gorgasia_taiwanensis, Heteroconger_hassi, Venefica_proboscidea, Anguilla_rostrata, ...
    ## 
    ## Rooted; includes branch lengths.

``` r
# Get the structure of the object.
str(fishtree)
```

    ## List of 4
    ##  $ edge       : int [1:122, 1:2] 63 64 64 65 66 67 68 68 69 70 ...
    ##  $ edge.length: num [1:122] 0.0105 0.0672 0.00537 0.00789 0.00157 ...
    ##  $ Nnode      : int 61
    ##  $ tip.label  : chr [1:62] "Moringua_edwardsi" "Kaupichthys_nuchalis" "Gorgasia_taiwanensis" "Heteroconger_hassi" ...
    ##  - attr(*, "class")= chr "phylo"
    ##  - attr(*, "order")= chr "cladewise"

`fishtree` is a fully resolved tree with branch lengths. There are 62
species and 61 internal nodes. We can plot the tree by using the
`plot.phylo` function of `ape`. Note that we can just use the function
`plot` to do this as `R` knows if we ask it to plot a phylogeny to use
`plot.phylo` instead!

``` r
# Plot the tree. 
plot(fishtree, cex = 0.5)
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-71-1.png
:align: center
:width: 600px
```

`cex = 0.5` reduces the size of the tip labels so we can read them.
(just about)

We can also zoom into different sections of the tree that you’re
interested in:

``` r
# Zoom into the tree.
zoom(fishtree, grep("Gymnothorax", fishtree$tip.label), subtree = FALSE, cex = 0.8)
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-72-1.png
:align: center
:width: 600px
```

The `grep` function is a generic function in `R` that allows to *grab*
any element in an object containing the desired characters. In this
example, `grep` is going to search for all the elements in
`fishtree$tip.label` that contains `Gymnothorax`
(e.g. `Gymnothorax_kidako`, `Gymnothorax_reticularis`). Try using only
`grep("thorax", fishtree$tip.label)` to see if it also only selects the
members of the *Gymnothorax* genus.

In this example, we just display the tree for the *Gymnothorax* genus
but you can also see how the species fit into the rest of the tree using
`subtree = TRUE`:

``` r
# Pull out the Gymnothorax tips.
zoom(fishtree, grep("Gymnothorax", fishtree$tip.label), subtree = TRUE, cex = 0.8)
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-73-1.png
:align: center
:width: 600px
```

Note that `zoom` is a specific plotting function that will automatically
set the plotting window to display two plots at once. This might create
some conflicts if you’re using RStudio. The bug can be easily solved
though by typing `dev.off()` to reinitialise the plotting window and
then proceed to the normal `zoom(...)` function as written above.

You can also reset this to one plot only per window by using:

``` r
# Change the plotting parameters back to 1 row and 1 column.
par(mfrow = c(1, 1))
```

```{tip}
If you're plots are coming out weird, resetting the plotting device is a good first
move. Use `dev.off()` first and see if it fixes it. A minor warning that it will 
delete all the previous plots, but this is why we use scripts!
```

To get further options for the plotting of phylogenies:

``` r
# Help function.
?plot.phylo
```

```{tip}
Remeber that using the question mark (`?`) can also be done for every function. 
The help pages may look confusing/intimidating at first but you quickly get used
to the set up.
```

Note that although you can use `plot` to plot the phylogeny, you need to
specify `plot.phylo` to find out the options for plotting trees. You can
change the style of the tree (`type`), the color of the branches and
tips (`edge.color`, `tip.color`), and the size of the tip labels
(`cex`). Here’s an fun/hideous example!

``` r
plot(fishtree, type = "unrooted", edge.color = "deeppink", tip.color = "springgreen",  cex = 0.7)
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-78-1.png
:align: center
:width: 600px
```

### 7. Manipulating phylogenetic trees in `R`

There are a range of ways in which we can manipulate trees in R. To
start lets take a look at the bird family Turdidae.

``` r
# Read in the turdidae (thrush) tree.
turdidae_tree <- read.nexus("data/turdidae_birdtree.nex")
```

As this multiphylo object (i.e. contains 100 different trees) we need to
first choose one random tree before we start.

``` r
# Sample a random tree. Because we set our seed earlier this will be the same 
# random tree for everyone. 
ran_turdidae_tree <- sample(turdidae_tree, size=1)[[1]]

# Use the plot tree function from phytools to plot a fan tree.
plotTree(ran_turdidae_tree, type="fan", fsize=0.4, lwd=0.5,ftype="i")
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-80-1.png
:align: center
:width: 600px
```

First, lets see what species are in the tree.

``` r
# Lets see the first 10 species.
head(ran_turdidae_tree$tip.label, 10)
```

    ##  [1] "Zoothera_everetti"        "Zoothera_naevia"          "Zoothera_pinicola"        "Hylocichla_mustelina"    
    ##  [5] "Catharus_aurantiirostris" "Catharus_mexicanus"       "Catharus_dryas"           "Catharus_fuscater"       
    ##  [9] "Catharus_ustulatus"       "Catharus_bicknelli"

We can remove species from the tree that we don’t want to include. This
is useful when we are missing data for a species, or we have a larger
tree with species we don’t need.

Lets say we want to drop all species with the Myadestes genus. In this
instance we first find all the associated tip.labels.

``` r
# Create an string object of the name we want to remove.
drop_pattern <- "Myadestes"

# sapply will iterate a given function over a vector (check out apply, lapply, apply for more info).
# In this case, we're using the grep function to ask if any species name in our tip label list matches the drop pattern. 
tip_numbers <- sapply(drop_pattern, grep, ran_turdidae_tree$tip.label)

# We then use the tip numbers to select only the tips we want.
drop_species <- ran_turdidae_tree$tip.label[tip_numbers]
drop_species
```

    ##  [1] "Myadestes_genibarbis"   "Myadestes_ralloides"    "Myadestes_melanops"     "Myadestes_coloratus"   
    ##  [5] "Myadestes_palmeri"      "Myadestes_elisabeth"    "Myadestes_townsendi"    "Myadestes_obscurus"    
    ##  [9] "Myadestes_occidentalis" "Myadestes_unicolor"     "Myadestes_lanaiensis"

Now, we create a new tree, with the Myadestes tips dropped from it.

``` r
# drop.tip will remove any matching tips from the tree.
ran_turdidae_tree_NM <- drop.tip(ran_turdidae_tree, drop_species)

# Plot the tree.
plotTree(ran_turdidae_tree_NM, type="fan", fsize=0.4, lwd=0.5, ftype="i")
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-83-1.png
:align: center
:width: 600px
```

Alternatively, lets say we want to extract the clade within the tree
that includes the pre identified selected range of species. We’ll now
keep the drop species and remove everything else.

``` r
# Set diff will find all the tips that don't match drop_species.
species_we_dont_want <- setdiff(ran_turdidae_tree$tip.label, drop_species)

# Set diff will find all the tips that don't match drop_species, and then drop.tip will remove them
pruned_birdtree <- drop.tip(ran_turdidae_tree, species_we_dont_want)

# Plot the smaller tree.
plotTree(pruned_birdtree, ftype="i")
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-84-1.png
:align: center
:width: 600px
```

```{tip}
You can save your new revised tree. This can save time reading in a big tree just
to remove tips. You'll notice in later practicals that the phylogenetic tree for
all birds is large, and takes a while to read into R, so it's worth saving pruned trees!
You can save trees using `write.tree`, the same as you would save a dataframe.
```

For some analyses, you might want to work with on a genus level tree.
This can easily be done by a few key steps. We can do this using base
`R`, but we’ll use some packages from the `tidyverse` that have some
very useful functions. First load `stringr` (for manipulating strings)
and `dplyr` (for manipulating dataframes). You’ll see that it masks
functions from other packages like stats. If you need those functions
you can use code like this: `stats::filter()` to specify the package you
want.

``` r
# Load packages from the tidyverse. 
library(stringr)
library(dplyr)
```

``` r
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
```

    ##             Genus         Species
    ## 1        Zoothera        everetti
    ## 2      Hylocichla       mustelina
    ## 3        Catharus aurantiirostris
    ## 4    Entomodestes       coracinus
    ## 5      Cichlopsis      leucogenys
    ## 6          Turdus      mupinensis
    ## 7    Psophocichla    litsitsirupa
    ## 8      Nesocichla         eremita
    ## 9      Cataponera       turdoides
    ## 10         Cochoa        purpurea
    ## 11 Chlamydochaera        jefferyi
    ## 12       Geomalia       heinrichi
    ## 13         Sialia     currucoides
    ## 14      Myadestes      genibarbis
    ## 15   Neocossyphus         poensis
    ## 16     Stizorhina         fraseri
    ## 17         Alethe     fuelleborni
    ## 18      Myophonus      borneensis
    ## 19   Brachypteryx        stellata
    ## 20     Heinrichia       calligyna

We now have a dataframe of species, with one tip per each unique genus.

A few things to note about the ‘tidy’ code we just ran:

`%>%` is an operator used to ‘pipe’ an object into a function. Piping is
common in most computing languages so look it up for more information!
It can make code less clutered by separating the data from the function
you need to use. This isn’t unique to `tidyverse` functions, but you’ll
see it used a lot more in their documentation.

For the `distinct` function, we specified a column name without using
quotation marks. To make code easier to read, most tidy functions will
process column names (or other labels) this way.

We can now use our unique species from each genera to drop all the other
tips in the tree.

``` r
# Combine the columns and add back in the underscore so they match the labels in the tree.
genera_tips <- paste(bird_genera$Genus, bird_genera$Species, sep="_")

# Pull out the tips we want to drop.
drop_tips <- setdiff(ran_turdidae_tree$tip.label, genera_tips)

# Remove all the species except one per genus.
genera_tree <- drop.tip(ran_turdidae_tree, drop_tips)
plotTree(genera_tree, ftype="i")
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-88-1.png
:align: center
:width: 600px
```

As the tree has dropped all but one species per genus, this means we
will finally need to also rename the tip labels as well to reflect this
change.

``` r
# It's definitely worth checking that the labels match up properly when you change tip labels.
par(mfrow=c(1, 2))
plotTree(genera_tree, ftype="i")

# Swap species names for genera.
genera_tree$tip.label <- bird_genera$Genus
plotTree(genera_tree, ftype="i")
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-89-1.png
:align: center
:width: 600px
```

### 8. Adding trait data to trees in `R`

Often basic tree plots in R are all you need for exploring data and your
analysis. However, for publications and presentations it may be useful
to plot trees with associated trait data. We will try plotting data with
a tree, using the package `ggtree`, and extension of `ggplot2`.

For this exercise we will use the Turdidae tree (Thrushes) with some
data on different habitat types. Load in the data:

``` r
# Read in the data and check it worked.
turdidae_data <- read.csv("data/turdidae_data.csv")
str(turdidae_data)
```

    ## 'data.frame':    173 obs. of  3 variables:
    ##  $ jetz_name: chr  "Alethe choloensis" "Alethe diademata" "Alethe fuelleborni" "Alethe poliocephala" ...
    ##  $ habitat  : chr  "Dense" "Dense" "Dense" "Dense" ...
    ##  $ body_mass: num  41.3 31.5 52 32.4 35.2 ...

We first need to match our data to the tip labels. First we need to put
an underscore in the names, and then match them to see if there’s any
name differences or missing species. In your coursework you will find
that occasionally because of taxonomic disagreements, you might be
missing species. The easiset way to solve this is by manually checking
tips that don’t match.

``` r
# Replace the blank space with an underscore.
turdidae_data$jetz_name <- turdidae_data$jetz_name %>% str_replace(" ", "_")
head(turdidae_data)
```

    ##                 jetz_name   habitat body_mass
    ## 1       Alethe_choloensis     Dense     41.30
    ## 2        Alethe_diademata     Dense     31.54
    ## 3      Alethe_fuelleborni     Dense     52.00
    ## 4     Alethe_poliocephala     Dense     32.37
    ## 5       Alethe_poliophrys     Dense     35.20
    ## 6 Brachypteryx_hyperythra Semi-Open     78.00

We’ll use the `%in%` operator, which is useful checking if our species
are in the tip labels

``` r
# %in% returns a list of logicals (TRUE or FALSE) for each object in the vector.
turdidae_data$jetz_name %in% ran_turdidae_tree$tip.label
```

    ##   [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ##  [20]  TRUE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ##  [39]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ##  [58]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ##  [77]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ##  [96]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [115]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [134]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [153]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [172]  TRUE  TRUE

We can save the results, and use this to select the rows we need from
turdidae_data. We’ll use the `!` operator, which means NOT. So in this
case it’s the species that are not in the tip labels. This can also work
for lots of other functions as well so try experimenting!

``` r
# See which species are NOT in the tip labels.
index <- !(turdidae_data$jetz_name %in% ran_turdidae_tree$tip.label)
turdidae_data[index,]
```

    ##             jetz_name habitat body_mass
    ## 23 Chaetops_aurantius    Open      41.1
    ## 24  Chaetops_frenatus    Open      45.6

These two species aren’t in our taxonomy. This is because they’ve been
moved to Chaetopidae, a new family of just rockjumpers. This often
happens when using multiple bird taxonomies, such as Jetz and Birdlife.
We’ll just remove them from our dataset.

``` r
# Get the species that ARE in the tips.
index <- turdidae_data$jetz_name %in% ran_turdidae_tree$tip.label

# Select only these species.
turdidae_data <- turdidae_data[index,]
```

Now we can drop the tips that don’t match and get plotting! Can you do
this yourself?

::::{admonition} Show the answer…  
:class: dropdown

``` r
# Get the tips we don't want.
drop_tips <- setdiff(ran_turdidae_tree$tip.label, turdidae_data$jetz_name)

# Drop species.
turdi_tree <- drop.tip(ran_turdidae_tree, drop_tips)
plotTree(turdi_tree, ftype="i")
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-95-1.png
:align: center
:width: 600px
```

::::

Now lets try using ggtree to plot our data with our phylogeny. This
package produces really nice plots you can use for coursework
assignments.

``` r
# Load ggtree for plotting phylogenies.
library(ggtree)
```

`ggtree` is a bit more complicated than just normal tree plots, but you
can also do a lot more. We’ll create a basic tree plot structure first
and then add tip labels and traits after.

``` r
# Create a plot of the tree with a circular layout.
turdidae_plot <- ggtree(turdi_tree, layout = "circular")

# Return the plot. This will show our plot.
turdidae_plot
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-97-1.png
:align: center
:width: 600px
```

This is a pretty basic plot. We can add tip labels and customize our
plot the same way as if we were using `ggplot2`.

``` r
# Create a plot of the tree with a circular layout.
turdidae_plot <- ggtree(turdi_tree, layout = "circular") + geom_tiplab()

# Return the plot. This will show our plot.
turdidae_plot
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-98-1.png
:align: center
:width: 600px
```

Our plot is now a bit big and falling out of the plotting window. We can
fix this by expanding the x axis, which unlike normal plots comes out
from the middle. We can also make the tips smaller as well.

``` r
# Create a plot of the tree with a circular layout.
turdidae_plot <- ggtree(turdi_tree, layout = "circular") + geom_tiplab(size = 1.5)

# Return the plot. This will show our plot.
turdidae_plot
```

```{image} practical_1_files/figure-gfm/unnamed-chunk-99-1.png
:align: center
:width: 600px
```

If we want to add trait data to our plot, we can combine our tree and
data together.

``` r
# Add a column that's the node number matching the tree.
turdidae_data$node <- nodeid(turdi_tree, turdidae_data$jetz_name)

# Join our data and tree together.
turdi_tree_data <-  full_join(turdi_tree, turdidae_data, by = "node")
```

Now we can make our plot!

``` r
(turdidae_plot <- ggtree(turdi_tree_data, layout="fan", open.angle = 15, aes(colour=habitat)) + 
   geom_tiplab(size = 1.5) +
   scale_color_manual(values = c("firebrick", "navy", "forest green"), breaks=c("Dense", "Semi-Open", "Open")))
```

    ## Scale for 'y' is already present. Adding another scale for 'y', which will replace the existing scale.

```{image} practical_1_files/figure-gfm/unnamed-chunk-101-1.png
:align: center
:width: 600px
```

```{tip}
Notice when we put an extra `()` around the entire line of code, it saves the plot
as an object, and prints the plot at the same time.
```

And now we have a plot where we can see the spread of habitat types in
Thrushes. Try experimenting with different colours and sizes to create
some beautiful trees that put this one to shame! There’s also lots of
other ways you can label trees. For more info [this
guide](https://4va.github.io/biodatasci/r-ggtree.html#the_ggtree_package)
is a great place to start.

> Extra task: Can you make another plot for continuous body mass data?
> Think about how you’d show this with colour. Can you change the key to
> better display the change in body mass? Is body mass more clumped in
> the tree than habitat?

::::{admonition} Show the answer…  
:class: dropdown

We can try using points on the end of tips.

``` r
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
```

    ## Scale for 'y' is already present. Adding another scale for 'y', which will replace the existing scale.

```{image} practical_1_files/figure-gfm/unnamed-chunk-103-1.png
:align: center
:width: 600px
```

Notice how we use `open.angle = 15` so that we can fit the legend in the
gap. Think how you can play around with the size of each part of the
plot to make it look nicer!

::::

::::{admonition} Show the answer…  
:class: dropdown

Or we can use bars. Maybe we could add clade labels after?

``` r
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
```

    ## Scale for 'y' is already present. Adding another scale for 'y', which will replace the existing scale.

```{image} practical_1_files/figure-gfm/unnamed-chunk-104-1.png
:align: center
:width: 600px
```

Geom fruit can be confusing as we have the y value as the node, and x as
our variable, but this code can easily be subbed in with your own data.

This guide goes into lots of detail plotting with ggtree, and is worth
your time! <https://yulab-smu.top/treedata-book/chapter10.html>

::::
