## Setting conservation priorities

### 1. Introduction and resources

This practical is aimed to introduce you to the EDGE & EcoEDGE scores
that you’ll need for your conservation strategy coursework. Put briefly,
these scores balance the distinctiveness of species against their risk
of extinction to detirmine conservation priorities. You can find out
more information about EDGE scores from the ZSL website:

<https://www.zsl.org/conservation/our-priorities/wildlife-back-from-the-brink/animals-on-the-edge>

We will also try plotting a simple map of IUCN categories so we can
visual the risk to our clade across the globe.

### 2. Preparing data

To calculate EDGE metrics, we need data on the species we’re interested
in, and their phylogenetic relationship. For the coursework we’re
interested in EDGE scores for a specific clade, however it’s also common
to look at areas such as national parks.

For this practical we’re going to use the same family as Practical 3,
Accipitridae. We’ll use the same table of traits from Practical 3 to
import our data and filter it.

``` r
# Read in the avonet data again.
trait_data <- read.csv("data/avonet_data.csv")
str(trait_data)
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

And again filter for Accipitridae.

``` r
# Load dplyr so we can filter.
library(dplyr)
accip_data <- trait_data %>% filter(jetz_family == "Accipitridae")
```

Because we’re going to use EDGE scores, we should check for any extinct
species we need to remove.

``` r
# This operator | means OR. EW means extinct in the wild.
accip_data %>% filter(redlist_cat == "EX" | redlist_cat == "EW")
```

    ##  [1] birdlife_name        birdlife_common_name jetz_name            jetz_order          
    ##  [5] jetz_family          redlist_cat          beak_length_culmen   beak_length_nares   
    ##  [9] beak_width           beak_depth           tarsus_length        wing_length         
    ## [13] kipps_distance       secondary1           hand_wing_index      tail_length         
    ## [17] mass                 habitat_density      migration            trophic_level       
    ## [21] trophic_niche        primary_lifestyle    centroid_latitude    centroid_longitude  
    ## [25] range_size          
    ## <0 rows> (or 0-length row.names)

Great, no extinct species in this family! There shouldn’t really be many
in our Jetz phylogeny, but some do turn up occasionally.

Now we need to load in our tree. For this practical we’re using a random
tree extracted from <http://birdtree.org/>

Because we’re not sure on the exact placement of some species tips, the
Jetz tree has multiple versions, each with a slightly different layout.
Normally this only means a few species have swapped places slightly.
This is why we’ve chosen a random tree for our analysis. There are other
methods for dealing with this uncertainty, but for these practicals it
will be enough to use a random tree.

``` r
# Load phylogenetic packages.
library(ape)
library(caper)

# Load in and plot the tree.
bird_tree <- read.tree("data/all_birds.tre")
plot(bird_tree, cex=0.01)
```

```{image} practical_4_files/figure-gfm/unnamed-chunk-4-1.png
:align: center
:width: 600px
```

There’s a lot of tips so that’s a pretty ugly tree!

### 3. ED Scores

Now that we’ve got our tree and our species we can start calculating our
ED (Evolutionary Distinctiveness) scores. Then we can out if specific
Accipitridae species are closely related to others in the tree, or
represent distinct lineages that might want to conserve to protect
valuable evolutionary diversity.

We can do this easily using a simple function from the `caper` package.
This sometimes takes a while to run.

``` r
# We first transform our tree into a matrix of distances from each tip to tip. 
# This step is optional but stops a warning from ed.calc, which prefers a matrix.
bird_matrix <- clade.matrix(bird_tree)

# Now we can run the ed.calc function, which calculates ED scores for each species. 
# The output gives two dataframes, but we only want the species names and scores so we use $spp
ED <- ed.calc(bird_matrix)$spp
head(ED)
```

    ##                  species       ED
    ## 1       Nothura_maculosa 12.22294
    ## 2          Nothura_minor 12.22294
    ## 3       Nothura_darwinii 10.19624
    ## 4      Nothura_boraquira 10.19624
    ## 5     Nothura_chacoensis 13.05058
    ## 6 Nothoprocta_perdicaria 15.18505

Now that we’ve got our ED scores for each species, we need to log
transform and normalise our scores.

``` r
# By adding 1 to our scores, this prevents negative logs when our ED scores are below 1.
ED$EDlog <- log(1+ED$ED)

# We can normalise our scores so they're scaled between 0 and 1.
ED$EDn <- (ED$EDlog - min(ED$EDlog)) / (max(ED$EDlog) - min(ED$EDlog))
head(ED)
```

    ##                  species       ED    EDlog       EDn
    ## 1       Nothura_maculosa 12.22294 2.581953 0.5385864
    ## 2          Nothura_minor 12.22294 2.581953 0.5385864
    ## 3       Nothura_darwinii 10.19624 2.415578 0.4955765
    ## 4      Nothura_boraquira 10.19624 2.415578 0.4955765
    ## 5     Nothura_chacoensis 13.05058 2.642663 0.5542808
    ## 6 Nothoprocta_perdicaria 15.18505 2.784088 0.5908408

Now that we have our normalised scores for all birds, we need to subset
the list for just Accipitridae.

``` r
# Pull out the ED row numbers for our species list.
accip_ED <- ED %>% filter(species %in% accip_data$jetz_name)
str(accip_ED)
```

    ## 'data.frame':    237 obs. of  4 variables:
    ##  $ species: chr  "Elanus_caeruleus" "Elanus_axillaris" "Elanus_leucurus" "Elanus_scriptus" ...
    ##  $ ED     : num  18.5 18.5 21.2 21.2 26.8 ...
    ##  $ EDlog  : num  2.97 2.97 3.1 3.1 3.33 ...
    ##  $ EDn    : num  0.638 0.638 0.672 0.672 0.731 ...

We now have the ED scores of 237 species in Accipitridae. With these
scores we can see how unique our species are in terms of the
evolutionary pathway.

``` r
# Find the highest ED score.
accip_ED[accip_ED$EDn == max(accip_ED$EDn),]
```

    ##                    species       ED    EDlog       EDn
    ## 8513 Chelictinia_riocourii 26.82268 3.325852 0.7308933
    ## 8514  Gampsonyx_swainsonii 26.82268 3.325852 0.7308933

The highest ED scores belong to *Chelictinia riocourii*, the
scissor-tailed kite, and *Gampsonyx swainsonii*, the pearl kite. Both
species are the only member of a monotypic genus, and part of the small
subfamily Elaninae, the elanine kites. This subfamily only has six
species, and all the others form one genus. Therefore, with so few close
relatives, we might consider this species a conservation priority to
protect as much diversity as we can. However we don’t yet know if this
species needs conserving…

### 4. EDGE Scores

This is where EDGE scores come in. By combining ED scores with IUCN
categories we can select the species that need conservation action, and
represent unique evolutionary variation.

First we need to convert the IUCN status in GE (Globally Endangered)
scores. This is relatively simple as we’re just assigning numeric
rankings, but we’ll use a `for loop` to practice our skills! We’ll also
use an `if` statement as well because we have two categories with the
same GE score (near threatened and deficient).

``` r
# Create an empty column to store our GE scores.
accip_data$GE <- NA

# Create a vector to increase with each new ranking, starting at 0 for least concern.
i <- 0

# Create a list to loop through in the order of GE scores.
redlist_cats <- c("LC", "NT", "DD", "VU", "EN", "CR")

# Loop through each different category in the redlist categories.
for (category in redlist_cats){

  # Add the GE score for that category.
  accip_data[accip_data$redlist_cat == category, "GE"] <- i
  
  # Because DD comes after NT, and both are scored as 1, don't want to change i if the category is NT.
  # We can use an if statement to do this. != means not equal to.
  if (category != "NT"){
    i = i + 1
  }
}
```

``` r
# We can check our loop worked using distinct.
accip_data %>% distinct(redlist_cat, GE)
```

    ##   redlist_cat GE
    ## 1          LC  0
    ## 2          VU  2
    ## 3          NT  1
    ## 4          EN  3
    ## 5          CR  4
    ## 6          DD  1

Now we’ll merge our GE scores with our ED scores in one dataframe.

``` r
# Join the last two columns of UK_Jetz to ED scores. 
# This time we'll use the 'by' argument rather than change the column names.
accip_EDGE <- left_join(accip_data, accip_ED,  by = c("jetz_name" = "species"))

# Head but we'll view just the first and last few columns.
head(accip_EDGE)[,c(2:3, 26:29)]
```

    ##      birdlife_common_name             jetz_name GE        ED    EDlog       EDn
    ## 1            Pied Goshawk Accipiter_albogularis  0  8.271480 2.226943 0.4468120
    ## 2                  Shikra      Accipiter_badius  0  5.204116 1.825213 0.3429598
    ## 3          Bicolored Hawk     Accipiter_bicolor  0  7.899108 2.185951 0.4362150
    ## 4 New Britain Sparrowhawk  Accipiter_brachyurus  2 10.931999 2.479224 0.5120296
    ## 5      Levant Sparrowhawk    Accipiter_brevipes  0  5.595169 1.886337 0.3587612
    ## 6     Nicobar Sparrowhawk     Accipiter_butleri  2 11.335471 2.512479 0.5206265

We can now calculate our EDGE scores using some simple maths:

```{math}
EDGE=ln⁡(1+ED)+GE×ln⁡(2)
```

We have already done the first half. Now we just need to multiply GE
scores by the natural log of 2, and combine them.

``` r
# The log function uses natural logarithms by default.
accip_EDGE$EDGE <- accip_EDGE$EDlog + accip_EDGE$GE * log(2)
head(accip_EDGE)[,c(2:3, 26:30)]
```

    ##      birdlife_common_name             jetz_name GE        ED    EDlog       EDn     EDGE
    ## 1            Pied Goshawk Accipiter_albogularis  0  8.271480 2.226943 0.4468120 2.226943
    ## 2                  Shikra      Accipiter_badius  0  5.204116 1.825213 0.3429598 1.825213
    ## 3          Bicolored Hawk     Accipiter_bicolor  0  7.899108 2.185951 0.4362150 2.185951
    ## 4 New Britain Sparrowhawk  Accipiter_brachyurus  2 10.931999 2.479224 0.5120296 3.865518
    ## 5      Levant Sparrowhawk    Accipiter_brevipes  0  5.595169 1.886337 0.3587612 1.886337
    ## 6     Nicobar Sparrowhawk     Accipiter_butleri  2 11.335471 2.512479 0.5206265 3.898773

Now we have our EDGE scores, we can see if our conservation priority has
changed in light of IUCN categories.

``` r
# Find the highest EDGE score.
accip_EDGE[accip_EDGE$EDGE == max(accip_EDGE$EDGE), c(2:3, 26:30)]
```

    ##     birdlife_common_name             jetz_name GE       ED    EDlog       EDn   EDGE
    ## 217     Philippine Eagle Pithecophaga_jefferyi  4 22.25013 3.146311 0.6844798 5.9189

``` r
# Find the EDGE score for our previous highest species.
accip_EDGE[accip_EDGE$EDn == max(accip_EDGE$EDn), c(2:3, 26:30)]
```

    ##     birdlife_common_name             jetz_name GE       ED    EDlog       EDn     EDGE
    ## 103  Scissor-tailed Kite Chelictinia_riocourii  0 26.82268 3.325852 0.7308933 3.325852
    ## 135           Pearl Kite  Gampsonyx_swainsonii  0 26.82268 3.325852 0.7308933 3.325852

So now we can see that the top conservation priority is the Philippine
Eagle, *Pithecophaga jefferyi*. Whilst our previous kites are still
high, their low IUCN score means its less of a priority than P.
jefferyi, which is critically endangered.

In reality, you want to preserve more than just one species! We can see
from the spread of EDGE scores that there are few species with high EDGE
scores, and we would ideally like to create a plan that maximises the
conservation of all of them (if it’s possible). Based on your own taxa
you’ll decide what constitutes a high EDGE score.

``` r
# Plot a histogram of EDGE values.
hist(accip_EDGE$EDGE, breaks = 20)
```

```{image} practical_4_files/figure-gfm/unnamed-chunk-15-1.png
:align: center
:width: 600px
```

``` r
# WE can use the select function to pull out only the columns we want to view.
# Because there's another function called select, we specify it's from dplyr.
accip_EDGE %>% filter(EDGE > 5) %>% dplyr::select(birdlife_common_name, jetz_name, redlist_cat, EDGE)
```

    ##       birdlife_common_name               jetz_name redlist_cat     EDGE
    ## 1               Cuban Kite  Chondrohierax_wilsonii          CR 5.237042
    ## 2 Madagascar Serpent-eagle       Eutriorchis_astur          EN 5.357568
    ## 3           Hooded Vulture    Necrosyrtes_monachus          CR 5.396246
    ## 4         Egyptian Vulture   Neophron_percnopterus          EN 5.273640
    ## 5         Philippine Eagle   Pithecophaga_jefferyi          CR 5.918900
    ## 6       Red-headed Vulture        Sarcogyps_calvus          CR 5.393195
    ## 7     White-headed Vulture Trigonoceps_occipitalis          CR 5.157038

```{tip}
In the above code we used the pipe operator `%>%` twice! This is why it's called a pipe. 
We can get the end product of each function to "flow" down to the next, like water 
down a pipe! 
```

### 5. EcoDGE Scores

Instead of evolutionary distinctiveness, we might instead be interested
in what functional traits each species provides. Species with low
functional diversity may be ‘functionally redundant’ in the ecosystem,
whereas those with high functional diversity may provide key ecosystem
services that aren’t easily replaceable. We call these scores EcoDGE
scores, with “eco” short for ecologically diverse.

Unlike ED, we will not calculate functional distinctiveness (FD and FDn)
in relation to all species within the order worldwide. Instead, we will
calculate FD and FDn for just our chosen species. The reason for this is
that FD is traditionally used in the context of a specific community or
radiation of species (i.e. all birds found within a national park, or
all species of lemur).

We need to change row names to species names and remove all the columns
except traits. Then normalise our trait data so that body\_mass and beak
have the same scale (the same variance).

``` r
# Make a copy of our data.
accip_traits <- accip_EDGE

# Change row names and keep just trait data.
rownames(accip_traits) <- accip_traits$jetz_name
accip_traits <- accip_traits[,7:17]

# Make each column have the same scale.
accip_traits <- scale(accip_traits, scale=TRUE)
head(accip_traits)
```

    ##                       beak_length_culmen beak_length_nares beak_width beak_depth tarsus_length wing_length
    ## Accipiter_albogularis         -0.7433418        -0.5866492 -0.5282422 -0.5329013    -0.4380073  -0.9721188
    ## Accipiter_badius              -1.1979544        -1.1153733 -0.9611877 -0.9706012    -1.2618782  -1.3351297
    ## Accipiter_bicolor             -0.9162227        -0.9669595 -1.0092927 -0.8152883    -0.6071177  -1.0140334
    ## Accipiter_brachyurus          -1.0762975        -0.9391319 -0.9371351 -0.9282431    -0.4726966  -1.2191159
    ## Accipiter_brevipes            -1.1659395        -1.1153733 -0.9852402 -1.0411979    -1.1144487  -1.1038506
    ## Accipiter_butleri             -1.2363724        -1.1339250 -1.4903432 -0.9141238    -1.0147170  -1.4900642
    ##                       kipps_distance secondary1 hand_wing_index tail_length       mass
    ## Accipiter_albogularis     -0.7745186 -0.9281820      -0.1263950  -0.7249344 -0.6082705
    ## Accipiter_badius          -1.0777692 -1.3265690      -0.2537573  -1.1555232 -0.6780068
    ## Accipiter_bicolor         -1.1704728 -0.7382966      -1.3108642  -0.4626392 -0.5853216
    ## Accipiter_brachyurus      -1.0526293 -1.1937733      -0.4065920  -1.1524909 -0.6716024
    ## Accipiter_brevipes        -0.6802438 -1.2955420       0.6759874  -0.9599389 -0.6452141
    ## Accipiter_butleri         -1.3857336 -1.3799355      -1.1580294  -1.3617206 -0.6834623

To calculate functional diversity we’ll create a distance matrix of our
traits. Species with similar traits will have smaller ‘distances’.

``` r
# Create a matrix.
traits_matrix <- as.matrix(accip_traits)

# Converts traits into 'distance' in trait space.
distance_matrix <- dist(traits_matrix)
```

The next step is to create a new tree using the neighbour-joining method
(Saitou & Nei, 1987) (Google for more information!). This will create a
tree where branch lengths show how similar species are in trait space
rather than evolutionary distance. This function may take a while with
more species so don’t be alarmed if the group you’ve chosen takes much
longer.

``` r
# Create the tree.
trait_tree <- nj(distance_matrix)

# Test to see if it's worked. The tree looks different to a normal one because tips 
# don't line up neatly at the present time period like with evolutionary relationships.
plot(trait_tree, cex=0.4)
```

```{image} practical_4_files/figure-gfm/unnamed-chunk-20-1.png
:align: center
:width: 600px
```

FD trees can fail if there are too many NAs in the data. If this is the
case for your taxa, remove species or traits with high NA counts from FD
analysis. Note, however, that the bird data is very complete so there
should be no need to remove NA species from the dataset; this should be
a last resort so only do this if the analyses are failing repeatedly.

With our tree of functional space, we can now calculate FD scores the
same way we calculated ED scores.

``` r
# Create a matrix of distance from tip to tip.
tree_matrix <- clade.matrix(trait_tree)

# Calculate FD scores.
FD <- ed.calc(tree_matrix)$spp

# Change the name to FD.
colnames(FD)[2] <- "FD"
head(FD)
```

    ##                 species        FD
    ## 1 Accipiter_albogularis 0.1515376
    ## 2      Accipiter_badius 0.3797113
    ## 3     Accipiter_bicolor 0.3908214
    ## 4  Accipiter_brachyurus 0.3674620
    ## 5    Accipiter_brevipes 0.3574219
    ## 6     Accipiter_butleri 0.4128270

Log and normalise the data as we did before with ED so we could compare
FD scores from different groups.

``` r
# Calculate the scores again.
FD$FDlog <- log(1+FD$FD)
FD$FDn <- (FD$FDlog - min(FD$FDlog)) / (max(FD$FDlog) - min(FD$FDlog))

# Find the highest FD score.
FD[FD$FDn == max(FD$FDn),]
```

    ##               species      FD    FDlog FDn
    ## 138 Gypaetus_barbatus 2.93894 1.370912   1

So the species with the largest FD score is *Gypaetus barbatus*, the
Bearded Vulture. This means G. barbatus is the most ecologically diverse
species in our clade, based on the morphological values we’ve supplied.
You might be interested to know that G. barbatus is a very unique
vulture, with long narrow wings, and wedge shaped tail that makes it
unmistakable in flight! Moreover, they live on a diet of up to 90% bone
marrow, which makes them the only living bird that specialises on
marrow! This will be reflected in the beak morphological traits we used
to calculate FD. Pretty cool right!

We can also combine GE scores to see how IUCN categories change our
priorities. We use the same formula as before:

```{math}
ecoDGE=ln⁡(1+FD)+GE×ln⁡(2)
```

``` r
# Join FD and GE scores.
accip_ecoDGE <- left_join(accip_data, FD, by = c("jetz_name" = "species"))

# Calculate ecoDGE scores.
accip_ecoDGE$ecoDGE <- accip_ecoDGE$FDlog + accip_ecoDGE$GE * log(2)
head(accip_ecoDGE)[,c(2:3, 26:30)]
```

    ##      birdlife_common_name             jetz_name GE        FD     FDlog       FDn    ecoDGE
    ## 1            Pied Goshawk Accipiter_albogularis  0 0.1515376 0.1410981 0.0000000 0.1410981
    ## 2                  Shikra      Accipiter_badius  0 0.3797113 0.3218743 0.1469948 0.3218743
    ## 3          Bicolored Hawk     Accipiter_bicolor  0 0.3908214 0.3298945 0.1535163 0.3298945
    ## 4 New Britain Sparrowhawk  Accipiter_brachyurus  2 0.3674620 0.3129565 0.1397435 1.6992508
    ## 5      Levant Sparrowhawk    Accipiter_brevipes  0 0.3574219 0.3055872 0.1337513 0.3055872
    ## 6     Nicobar Sparrowhawk     Accipiter_butleri  2 0.4128270 0.3455926 0.1662809 1.7318870

And does including IUCN categories change our conservation priorities?

``` r
# Find the highest ecoDGE score.
accip_ecoDGE[accip_ecoDGE$ecoDGE == max(accip_ecoDGE$ecoDGE), c(2:3, 26:30)]
```

    ##     birdlife_common_name             jetz_name GE      FD    FDlog       FDn  ecoDGE
    ## 217     Philippine Eagle Pithecophaga_jefferyi  4 2.83493 1.344151 0.9782403 4.11674

``` r
# Find the ecoDGE score for Gypaetus barbatus.
accip_ecoDGE[accip_ecoDGE$jetz_name == "Gypaetus_barbatus", c(2:3, 26:30)]
```

    ##     birdlife_common_name         jetz_name GE      FD    FDlog FDn   ecoDGE
    ## 138      Bearded Vulture Gypaetus_barbatus  1 2.93894 1.370912   1 2.064059

Yes! Funnily enough the Philippine Eagle is again the species we need to
check. This may be because the GE component of ecoDGE scores is weighted
much higher than the FD component.

``` r
# Get the top 5% of FD scores.
accip_ecoDGE[accip_ecoDGE$FD > quantile(accip_ecoDGE$FD, 0.95), c(2:3, 26:30)]
```

    ##     birdlife_common_name               jetz_name GE       FD     FDlog       FDn    ecoDGE
    ## 47     Cinereous Vulture       Aegypius_monachus  1 2.130645 1.1412390 0.8132459 1.8343861
    ## 54        Gurney's Eagle          Aquila_gurneyi  1 1.500756 0.9165931 0.6305793 1.6097403
    ## 127  Swallow-tailed Kite    Elanoides_forficatus  0 1.430271 0.8880028 0.6073317 0.8880028
    ## 138      Bearded Vulture       Gypaetus_barbatus  1 2.938940 1.3709116 1.0000000 2.0640588
    ## 139     Palm-nut Vulture   Gypohierax_angolensis  0 1.525275 0.9263500 0.6385130 0.9263500
    ## 144    Himalayan Griffon       Gyps_himalayensis  1 1.707854 0.9961565 0.6952748 1.6893036
    ## 152  Steller's Sea-eagle    Haliaeetus_pelagicus  2 1.960934 1.0855046 0.7679266 2.4717990
    ## 164         Papuan Eagle Harpyopsis_novaeguineae  2 2.346738 1.2079860 0.8675201 2.5942804
    ## 217     Philippine Eagle   Pithecophaga_jefferyi  4 2.834930 1.3441512 0.9782403 4.1167400
    ## 233        Crowned Eagle Stephanoaetus_coronatus  1 1.413409 0.8810401 0.6016701 1.5741873
    ## 234             Bateleur   Terathopius_ecaudatus  1 1.752398 1.0124726 0.7085420 1.7056198
    ## 235 Lappet-faced Vulture     Torgos_tracheliotos  3 2.032191 1.1092855 0.7872635 3.1887270

``` r
# Get the top 5% of ecoDGE scores.
accip_ecoDGE[accip_ecoDGE$ecoDGE > quantile(accip_ecoDGE$ecoDGE, 0.95), c(2:3, 26:30)]
```

    ##       birdlife_common_name               jetz_name GE        FD     FDlog       FDn   ecoDGE
    ## 105             Cuban Kite  Chondrohierax_wilsonii  4 1.0566988 0.7211022 0.4716195 3.493691
    ## 140   White-backed Vulture          Gyps_africanus  4 0.5639157 0.4471927 0.2488952 3.219781
    ## 141   White-rumped Vulture        Gyps_bengalensis  4 0.6793770 0.5184229 0.3068147 3.291012
    ## 145         Indian Vulture            Gyps_indicus  4 0.6518839 0.5019164 0.2933927 3.274505
    ## 146      Rüppell's Vulture         Gyps_rueppellii  4 0.7110013 0.5370787 0.3219843 3.309667
    ## 147 Slender-billed Vulture       Gyps_tenuirostris  4 0.9128431 0.6485906 0.4126581 3.421179
    ## 155  Madagascar Fish-eagle Haliaeetus_vociferoides  4 0.8499630 0.6151656 0.3854792 3.387754
    ## 203         Hooded Vulture    Necrosyrtes_monachus  4 1.0619417 0.7236481 0.4736897 3.496237
    ## 208      Flores Hawk-eagle         Nisaetus_floris  4 0.5802147 0.4575607 0.2573257 3.230149
    ## 217       Philippine Eagle   Pithecophaga_jefferyi  4 2.8349303 1.3441512 0.9782403 4.116740
    ## 222     Red-headed Vulture        Sarcogyps_calvus  4 1.0009571 0.6936256 0.4492775 3.466214
    ## 236   White-headed Vulture Trigonoceps_occipitalis  4 1.2212488 0.7980696 0.5342041 3.570658

As we can see, all of the highest ecoDGE scores are critically
endangered. This has been a criticism of ecoDGE scores, that functional
diversity isn’t weighted highly enough. Of course for our taxa these are
probably the species we want to protect, and maybe GE should be the more
pressing issue. However if your taxa has very few CR species, it’s worth
checking FD scores as well, as you may want to adjust your GE scores to
give more weighting to FD.

### 6. EcoEDGE Scores

So we’ve used EDGE scores to combine extinction risk with evolutionary
diversity, and ecoDGE scores to do the same with functional diversity.
However, both are important, and we might want to combine all three into
one metric. This is exactly what EcoEDGE scores do (confusingly, their
creators decided to use very very similar names). And we’ve pretty much
done all the hard work already. The equation is similar to the ones
we’ve used, but we give ED and FD scores equal weighting:

```{math}
EcoEDGE= (0.5×EDn + 0.5×FDn) + GE×ln⁡(2)
```

And remember our EDn and FDn scores have already been logged, so we
don’t need to log them now.

``` r
# Merge FD and ED scores.
accip_EcoEDGE <- left_join(accip_EDGE, accip_ecoDGE)
```

    ## Joining, by = c("birdlife_name", "birdlife_common_name", "jetz_name", "jetz_order", "jetz_family", "redlist_cat", "beak_length_culmen", "beak_length_nares", "beak_width", "beak_depth", "tarsus_length", "wing_length", "kipps_distance", "secondary1", "hand_wing_index", "tail_length", "mass", "habitat_density", "migration", "trophic_level", "trophic_niche", "primary_lifestyle", "centroid_latitude", "centroid_longitude", "range_size", "GE")

``` r
# Calculate EcoEDGE scores.
accip_EcoEDGE$EcoEDGE <- (0.5*accip_EcoEDGE$EDn + 0.5*accip_EcoEDGE$FDn) + accip_EcoEDGE$GE*log(2)

# Select just the relevant columns.
accip_EcoEDGE <- accip_EcoEDGE %>% dplyr::select(birdlife_common_name, jetz_name, 
                                                 redlist_cat, GE, EDGE, ecoDGE, EcoEDGE)

# Check it's worked.
head(accip_EcoEDGE)
```

    ##      birdlife_common_name             jetz_name redlist_cat GE     EDGE    ecoDGE   EcoEDGE
    ## 1            Pied Goshawk Accipiter_albogularis          LC  0 2.226943 0.1410981 0.2234060
    ## 2                  Shikra      Accipiter_badius          LC  0 1.825213 0.3218743 0.2449773
    ## 3          Bicolored Hawk     Accipiter_bicolor          LC  0 2.185951 0.3298945 0.2948657
    ## 4 New Britain Sparrowhawk  Accipiter_brachyurus          VU  2 3.865518 1.6992508 1.7121809
    ## 5      Levant Sparrowhawk    Accipiter_brevipes          LC  0 1.886337 0.3055872 0.2462563
    ## 6     Nicobar Sparrowhawk     Accipiter_butleri          VU  2 3.898773 1.7318870 1.7297481

We can again look at the spread and see which are the highest species.

``` r
# Get the highest scoring species.
accip_EcoEDGE[accip_EcoEDGE$EcoEDGE == max(accip_EcoEDGE$EcoEDGE),]
```

    ##     birdlife_common_name             jetz_name redlist_cat GE   EDGE  ecoDGE  EcoEDGE
    ## 217     Philippine Eagle Pithecophaga_jefferyi          CR  4 5.9189 4.11674 3.603949

``` r
# Get the top 10% of EcoEDGE scores.
accip_EcoEDGE[accip_EcoEDGE$EcoEDGE > quantile(accip_EcoEDGE$EcoEDGE, 0.9),]
```

    ##         birdlife_common_name                jetz_name redlist_cat GE     EDGE   ecoDGE  EcoEDGE
    ## 18           Gundlach's Hawk      Accipiter_gundlachi          EN  3 3.965779 2.603643 2.414579
    ## 92            Ridgway's Hawk           Buteo_ridgwayi          CR  4 4.336146 3.052206 2.966565
    ## 105               Cuban Kite   Chondrohierax_wilsonii          CR  4 5.237042 3.493691 3.262504
    ## 120    Reunion Marsh-harrier         Circus_maillardi          EN  3 4.270122 2.497123 2.410610
    ## 121            Black Harrier            Circus_maurus          EN  3 4.107043 2.425928 2.360585
    ## 134 Madagascar Serpent-eagle        Eutriorchis_astur          EN  3 5.357568 2.440742 2.528246
    ## 140     White-backed Vulture           Gyps_africanus          CR  4 4.726423 3.219781 3.085141
    ## 141     White-rumped Vulture         Gyps_bengalensis          CR  4 4.583339 3.291012 3.095607
    ## 142             Cape Vulture         Gyps_coprotheres          EN  3 3.681765 2.838908 2.473519
    ## 145           Indian Vulture             Gyps_indicus          CR  4 4.374936 3.274505 3.061958
    ## 146        Rüppell's Vulture          Gyps_rueppellii          CR  4 4.393093 3.309667 3.078601
    ## 147   Slender-billed Vulture        Gyps_tenuirostris          CR  4 4.374913 3.421179 3.121588
    ## 151      Pallas's Fish-eagle   Haliaeetus_leucoryphus          EN  3 4.356964 2.474009 2.412437
    ## 155    Madagascar Fish-eagle  Haliaeetus_vociferoides          CR  4 4.866478 3.387754 3.171536
    ## 162   Crowned Solitary Eagle Harpyhaliaetus_coronatus          EN  3 3.644918 2.682003 2.404964
    ## 180      White-collared Kite         Leptodon_forbesi          EN  3 4.554955 2.446426 2.426814
    ## 203           Hooded Vulture     Necrosyrtes_monachus          CR  4 5.396246 3.496237 3.284117
    ## 204         Egyptian Vulture    Neophron_percnopterus          EN  3 5.273640 2.902952 2.705317
    ## 208        Flores Hawk-eagle          Nisaetus_floris          CR  4 4.638980 3.230149 3.078054
    ## 217         Philippine Eagle    Pithecophaga_jefferyi          CR  4 5.918900 4.116740 3.603949
    ## 222       Red-headed Vulture         Sarcogyps_calvus          CR  4 5.393195 3.466214 3.271517
    ## 229 Black-and-chestnut Eagle        Spizaetus_isidori          EN  3 4.417788 2.684303 2.505797
    ## 235     Lappet-faced Vulture      Torgos_tracheliotos          EN  3 4.344917 3.188727 2.701460
    ## 236     White-headed Vulture  Trigonoceps_occipitalis          CR  4 5.157038 3.570658 3.283455

``` r
# See the spread.
hist(accip_EcoEDGE$EcoEDGE, breaks = 20)
```

```{image} practical_4_files/figure-gfm/unnamed-chunk-31-1.png
:align: center
:width: 600px
```

Unsuprisingly, the Philippine Eagle is again the highest species.
However, most birds in Accipitridae are not currently threatened by
extinction according to IUCN criteria. For your own taxa, this may be a
very different story, and ED and FD scores may matter a lot more. It’s
also up to you if you want to down weight GE scores, or you agree that
conservation priority goes to those species most threatened with
extinction. How you chose to interpret and present your results is up to
you, and will depend on the group that you’ve chosen.

For the practicals and coursework we’ve chosen to use a simplified
version of EcoEDGE scores. If you’re interested in learning more, check
out this paper which first proposed the use of EcoEDGE scores:

<https://onlinelibrary.wiley.com/doi/full/10.1111/ddi.12320>

### 7. Plotting a map of IUCN categories

You may wish to plot maps of your IUCN redlist categories, especially if
you’re intersted in what areas of the world are most threatened by
extinction. We can do this easily using similar code from practical 3.

``` r
# First load in the spatial packages we'll need.
library(raster)
library(sf)
library(fasterize)

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

We’ll run the same code as before to compile our spatial dataframe into
a single raster layer. The only difference is this time we’re assigning
values based on GE rating rather than range size.

``` r
# Combine the two datasets into one object. (This turns our maps into a normal dataframe)
accip_ranges <- left_join(accip_EcoEDGE, accip_ranges, by = c("jetz_name" = "SCINAME"))

# Create an empty raster stack to store our data in.
raster_template <- raster(ncols=2160, nrows = 900, ymn = -60)

# 'fasterize' needs objects to be an sf class so we'll convert it back into an sf dataframe.
accip_ranges <- st_sf(accip_ranges)

# Use the fasterize function with the raster template. 
# We want to use the GE field, and the function max takes the highest value when they overlap.
GE_raster <- fasterize(accip_ranges, raster_template, field = "GE", fun = "max")

# Plot the new map.
plot(GE_raster)
```

```{image} practical_4_files/figure-gfm/unnamed-chunk-33-1.png
:align: center
:width: 600px
```

Now we’ve created our stack of range maps, and each are coded for their
IUCN category. In this case we’ll take the maximum GE score as the one
that’s shown. So if two ranges overlap, we take the highest score.

> Extra task: Do you think this is a good way to show the data? What
> would you do differently? Could you use another metric from today’s
> practical? And is taking the highest score when cells overlap the best
> option? Try and make another map to show the data.

So now you can see the spread of GE scores throughout the globe. For
your own species you may wish to focus on a specific area of Earth using
the `crop()` function. Again we’ll use ggplot2 to make them a little
nicer to look at.

``` r
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
colScale <- scale_fill_manual(name = "IUCN Status", values = myColors)

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
```

```{image} practical_4_files/figure-gfm/unnamed-chunk-34-1.png
:align: center
:width: 600px
```

There’s our finished map! Think how you’d change it yourself if you want
to include one in your report. It’s up to you and what you think is the
best way to visualise your data!
