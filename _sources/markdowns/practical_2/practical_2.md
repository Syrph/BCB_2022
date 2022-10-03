## Phylogenetics in R

### 1. Introduction and resources

This practical introduces you to basic phylogenetic computing in `R`. We
will review importing phylogenetic trees as data files, displaying
phylogenetic trees visually, and some basic evolutionary computations
that can be conducted with phylogenetic trees. This practical will
deliver some of the important background for Coursework 1. Below you
will find some of the relevant resources required for this practical.

Parts (sections 2,3,4) of this practical are written by [Natalie
Cooper](http://nhcooper123.github.io/). The original can be found
[here](https://github.com/nhcooper123/TeachingMaterials/blob/master/PhD_Museum/VisualisingPhylo.Rmd).
Whereas, parts (section 5 & 6) of this practical are written by Adam
Devenish & Rob Barber (<a.devenish@imperial.ac.uk>)
(<r.barber19@imperial.ac.uk>).

#### Starting a new R session

To plot phylogenies (or use any specialized analysis) in R, you need one
or more additional packages from the basic R installation. For this
practical you will need to load the following packages:

• ape

• phytools

Because we’ve started a new R session we shouldn’t have any packages
loaded. We need to load packages the same way as last session:

``` r
# Load packages.
library(ape)
library(phytools)
```

You can think of `install.packages` like installing an app from the App
Store on your smart phone - you only do this once - and `library` as
being like pushing the app button on your phone - you do this every time
you want to use the app.

It’s also useful to remove any objects from our working directory before
starting a new project. You shouldn’t need to do this if you’ve just
started `RStudio`, but if you’ve been working on something before you
want to clear your workspace:

``` r
# rm removes objects. ls() returns everything in your environment.
rm(list=ls())
```

### 2. A refresher of phylogenetic trees

This section will review some basic aspects of phylogenetic trees and
introduce how trees are handled at the level of software. Because you
are now interacting with phylogenetic trees for things like plotting, it
is also helpful to know some of the names for parts of phylogenetic
trees used in computer science.

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

```{image} practical_2_files/figure-gfm/unnamed-chunk-3-1.png
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

```{image} practical_2_files/figure-gfm/unnamed-chunk-4-1.png
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

```{image} practical_2_files/figure-gfm/unnamed-chunk-5-1.png
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

#### Edge table

It is also possible to represent a phylogenetic tree as a matrix of
edges and vertices called an edge table. This is an even less intuitive
representation, but it is implemented in `R` and worth reviewing here.

There are a number of conventions that can be used to create an edge
table. The general concept consists of numbering the tips *1 - n*, and
all internal nodes labeled *n+1 … n+n-1*. The numbers for the internal
nodes can be assigned arbitrarily or according to an algorithm.

In `R` packages like `ape`, edge tables are constructed as follows:

| node | connects to |
|------|-------------|
| 5    | 6           |
| 6    | 7           |
| 7    | 1           |
| 7    | 2           |
| 6    | 3           |
| 5    | 4           |

You read the table as follows: node `5` (root) connects to node `6`. The
node `6` connects to node `7`. Node `7` connects to node `1` that happen
to be the first tip (`Homo`) and to node `2` (`Pan`) etc… Note that in a
binary tree (i.e. a tree where each node has only two descendants) each
node always connects to two elements (nodes or tips).

``` r
# Create a tree.
tree <- read.tree(text = "(((Homo, Pan), Gorilla), Pongo);")

# Plot the tree.
plot(tree, label.offset = 0.1)

# Add node labels and tip labels to the existing plot.
nodelabels()
tiplabels()
```

```{image} practical_2_files/figure-gfm/unnamed-chunk-6-1.png
:align: center
:width: 600px
```

#### Records & pointers

At a lower level, phylogenetic trees can be represented in computer
memory as more complex data objects. We don’t need to go into detail
here, but if you consider nodes and tips as data objects (i.e. a
dataframe), a tree could be stored as an array of dataframes which store
information about which members of that same array are descendants and
which are ancestors.

### 3. Basic tree viewing in `R`

Now let’s visualise some phylogenies! We’ll use the Elopomorpha (eels
and similar fishes) tree to start as it is simple.

#### Reading in a phylogeny from a file

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

```{image} practical_2_files/figure-gfm/unnamed-chunk-10-1.png
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

```{image} practical_2_files/figure-gfm/unnamed-chunk-11-1.png
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
but you can also see how the species fit into the rest of the tree
using:

``` r
# Pull out the Gymnothorax tips.
zoom(fishtree, grep("Gymnothorax", fishtree$tip.label), subtree = TRUE, cex = 0.8)
```

```{image} practical_2_files/figure-gfm/unnamed-chunk-12-1.png
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

```{image} practical_2_files/figure-gfm/unnamed-chunk-17-1.png
:align: center
:width: 600px
```

Or try

``` r
plot(ladderize(fishtree), type = "c", edge.color = "darkviolet", tip.color = "hotpink",  cex = 0.7)
```

```{image} practical_2_files/figure-gfm/unnamed-chunk-18-1.png
:align: center
:width: 600px
```

The `ladderize` function allows to display the branches from shortest to
longest.

> Try to modify the graphical options (colors, display, size, ordering
> of the nodes, etc.) to obtain the most beautiful or ugliest
> Elopomorpha phylogeny!

### 4. Manipulating phylogenetic trees in `R`

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

```{image} practical_2_files/figure-gfm/unnamed-chunk-20-1.png
:align: center
:width: 600px
```

First, lets see what species are in the tree.

``` r
# Lets see the first 10 species.
head(ran_turdidae_tree$tip.label, 10)
```

    ##  [1] "Zoothera_everetti"        "Zoothera_naevia"          "Zoothera_pinicola"       
    ##  [4] "Hylocichla_mustelina"     "Catharus_aurantiirostris" "Catharus_mexicanus"      
    ##  [7] "Catharus_dryas"           "Catharus_fuscater"        "Catharus_ustulatus"      
    ## [10] "Catharus_bicknelli"

We can remove species from the tree that we don’t want to include. This
is useful when we are missing data for a species, or we have a larger
tree with species we don’t need.

Lets say we want to drop all species with the Myadestes genus. In this
instance we first find all the associated tip.labels.

``` r
# Create an string object of the name we want to remove.
drop_pattern <- ("Myadestes")

# sapply will iterate a given function over a vector (check out apply, lapply, 
# mapply for more info)
# in this case, we're using the grep function to ask if any species name in our
# tip label list matches the drop.species pattern. 
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

```{image} practical_2_files/figure-gfm/unnamed-chunk-23-1.png
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

```{image} practical_2_files/figure-gfm/unnamed-chunk-24-1.png
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

```{image} practical_2_files/figure-gfm/unnamed-chunk-28-1.png
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

```{image} practical_2_files/figure-gfm/unnamed-chunk-29-1.png
:align: center
:width: 600px
```

It is important to note, that a big limitation with this approach is
that by selecting only one species per genus to keep, that you may run
the risk of unintentially dropping tips of species that are
paraphyletic. For example, Zoothera genus is spread throughout Turdidae
tree.

``` r
# Zoom into zoothera tree.
plotTree(ran_turdidae_tree, fsize=0.2, lwd=0.2, ftype="i")
```

```{image} practical_2_files/figure-gfm/unnamed-chunk-30-1.png
:align: center
:width: 600px
```

``` r
zoom(ran_turdidae_tree, grep("Zoothera", ran_turdidae_tree$tip.label), subtree = TRUE, cex = 0.8)
```

```{image} practical_2_files/figure-gfm/unnamed-chunk-30-2.png
:align: center
:width: 600px
```

This means that when collapsing a phylogenetic tree you run the risk of
miss representing the relationship between the different genera. The
only way to get round this is by:

1.  making sure check to see how paraphyletic your tree is at the start;
    this can be done more easily by uploading and viewing your tree file
    @ <https://itol.embl.de/>.
2.  Renaming your conflicting paraphyletic clades within your phylogeny,
    by altering the individual species names.

``` r
ran_turdidae_tree$tip.label[ran_turdidae_tree$tip.label=="Turdus_philomelos"]<-"Turdus1_philomelos"
```

```{tip}
For your coursework you don't need to worry about paraphyletic tips. It's just 
worth knowing that this can happen if you use trees in the future! 
```

### 5. Adding trait data to trees in `R`

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

    ##   [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ##  [18]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ##  [35]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ##  [52]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ##  [69]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ##  [86]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [103]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE
    ## [120]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [137]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [154]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [171]  TRUE  TRUE  TRUE

We can save the results, and use this to select the rows we need from
turdidae\_data. We’ll use the `!` operator, which means NOT. So in this
case it’s the species that are not in the tip labels. This can also work
for lots of other functions as well so try experimenting!

``` r
# See which species are NOT in the tip labels.
index <- !(turdidae_data$jetz_name %in% ran_turdidae_tree$tip.label)
turdidae_data[index,]
```

    ##              jetz_name habitat body_mass
    ## 23  Chaetops_aurantius    Open     41.10
    ## 24   Chaetops_frenatus    Open     45.60
    ## 117  Turdus_philomelos   Dense     67.74

One of them we renamed so we’ll change that back for our plots. The
others aren’t in our taxonomy. This is because they’ve been moved to
Chaetopidae, a new family of just rockjumpers. This often happens as
there are three main bird taxonomies: Jetz, Birdlife, and American
Ornithological Society. We’ll just remove them from our dataset.

``` r
# Change the name back.
ran_turdidae_tree$tip.label[ran_turdidae_tree$tip.label=="Turdus1_philomelos"]<-"Turdus_philomelos"

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

```{image} practical_2_files/figure-gfm/unnamed-chunk-38-1.png
:align: center
:width: 600px
```

::::

Now lets try using ggtree to plot our data with our phylogeny.

If you’re using your own laptop, you need to install `ggtree`. Because
not all packages are available from `CRAN` directly through `R`, we’ll
install `BiocManager`. This is a package manager that can install
packages from other servers and is used a lot in bioinformatics.

``` r
install.packages("BiocManager")
BiocManager::install("ggtree")
```

```{tip}
Notice that we used `::` to specify we want to use the `BiocManager` package to 
install `ggtree`. Using `::` means we don't have to load the package, and can be
handy when we only need to use a function once.
```

``` r
# Load plotting packages.
library(ggtree)
library(ggplot2)
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

```{image} practical_2_files/figure-gfm/unnamed-chunk-42-1.png
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

```{image} practical_2_files/figure-gfm/unnamed-chunk-43-1.png
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

```{image} practical_2_files/figure-gfm/unnamed-chunk-44-1.png
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

```{image} practical_2_files/figure-gfm/unnamed-chunk-46-1.png
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
other ways you can label trees. For more info this guide is a great
place to start:
<https://4va.github.io/biodatasci/r-ggtree.html#the_ggtree_package>

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

```{image} practical_2_files/figure-gfm/unnamed-chunk-48-1.png
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
    geom_fruit(data = turdi_tree_data, geom=geom_bar,
               mapping=aes(y=node, x=body_mass),
               pwidth=0.38,
               orientation="y", 
               stat="identity", fill="navy", colour="navy", width=0.2) + 
    # We can remove some of the white space around our plot by setting the margins to negative values.
  theme(plot.margin=margin(-80,-80,-80,-80)))
```

    ## Scale for 'y' is already present. Adding another scale for 'y', which will replace the existing scale.

```{image} practical_2_files/figure-gfm/unnamed-chunk-49-1.png
:align: center
:width: 600px
```

Geom fruit can be confusing as we have the y value as the node, and x as
our variable, but this code can easily be subbed in with your own data.

This guide goes into lots of detail plotting with ggtree, and is worth
your time! <https://yulab-smu.top/treedata-book/chapter10.html>

::::
