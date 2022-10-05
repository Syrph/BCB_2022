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

    ## 'data.frame':    9872 obs. of  26 variables:
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

    ##  [1] birdlife_name        birdlife_common_name jetz_name            jetz_order           jetz_family         
    ##  [6] redlist_cat          extinct_prob         beak_length_culmen   beak_length_nares    beak_width          
    ## [11] beak_depth           tarsus_length        wing_length          kipps_distance       secondary1          
    ## [16] hand_wing_index      tail_length          mass                 habitat_density      migration           
    ## [21] trophic_level        trophic_niche        primary_lifestyle    centroid_latitude    centroid_longitude  
    ## [26] range_size          
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

```{image} practical_3_files/figure-gfm/unnamed-chunk-4-1.png
:align: center
:width: 600px
```

There’s a lot of tips so that’s a pretty ugly tree! We can remove the
species as we did before. See if you can do it yourself first using
drop.tips again.

::::{admonition} Show the answer…  
:class: dropdown

``` r
# Get the tips we don't want.
drop_tips <- setdiff(bird_tree$tip.label, accip_data$jetz_name)

# Drop the tips.
bird_tree <- drop.tip(bird_tree, drop_tips)
```

::::

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

    ##                 species       ED
    ## 1      Elanus_caeruleus 18.33354
    ## 2      Elanus_axillaris 18.33354
    ## 3       Elanus_leucurus 21.04545
    ## 4       Elanus_scriptus 21.04545
    ## 5 Chelictinia_riocourii 26.70163
    ## 6  Gampsonyx_swainsonii 26.70163

Now that we’ve got our ED scores for each species, we need to log
transform and normalise our scores.

``` r
# By adding 1 to our scores, this prevents negative logs when our ED scores are below 1.
ED$EDlog <- log(1+ED$ED)

# We can normalise our scores so they're scaled between 0 and 1.
ED$EDn <- (ED$EDlog - min(ED$EDlog)) / (max(ED$EDlog) - min(ED$EDlog))
head(ED)
```

    ##                 species       ED    EDlog       EDn
    ## 1      Elanus_caeruleus 18.33354 2.961842 0.8512172
    ## 2      Elanus_axillaris 18.33354 2.961842 0.8512172
    ## 3       Elanus_leucurus 21.04545 3.093106 0.9055199
    ## 4       Elanus_scriptus 21.04545 3.093106 0.9055199
    ## 5 Chelictinia_riocourii 26.70163 3.321491 1.0000000
    ## 6  Gampsonyx_swainsonii 26.70163 3.321491 1.0000000

Now that we have our normalised scores for all birds, we need to subset
the list for just Accipitridae.

``` r
# Pull out the ED row numbers for our species list.
accip_ED <- ED %>% filter(species %in% accip_data$jetz_name)
str(accip_ED)
```

    ## 'data.frame':    237 obs. of  4 variables:
    ##  $ species: chr  "Elanus_caeruleus" "Elanus_axillaris" "Elanus_leucurus" "Elanus_scriptus" ...
    ##  $ ED     : num  18.3 18.3 21 21 26.7 ...
    ##  $ EDlog  : num  2.96 2.96 3.09 3.09 3.32 ...
    ##  $ EDn    : num  0.851 0.851 0.906 0.906 1 ...

We now have the ED scores of 237 species in Accipitridae. With these
scores we can see how unique our species are in terms of the
evolutionary pathway.

``` r
# Find the highest ED score.
accip_ED[accip_ED$EDn == max(accip_ED$EDn),]
```

    ##                 species       ED    EDlog EDn
    ## 5 Chelictinia_riocourii 26.70163 3.321491   1
    ## 6  Gampsonyx_swainsonii 26.70163 3.321491   1

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

Each IUCN category has an extinction probability used to calculate EDGE
scores. This is based on a recent paper that’s refined the methodology.
These extinction probabilities are also referred to as GE (Globally
Endangered) scores, which is why it’s called EDGE.

We’ll add the ED scores to the main dataset first, and then we can
easily calculate EDGE.

``` r
# Join the last two columns of UK_Jetz to ED scores. 
# This time we'll use the 'by' argument rather than change the column names.
accip_EDGE <- left_join(accip_data, accip_ED,  by = c("jetz_name" = "species"))

# Head but we'll view just the first and last few columns.
head(accip_EDGE)[,c(2:3, 26:29)]
```

    ##      birdlife_common_name             jetz_name  range_size        ED    EDlog       EDn
    ## 1            Pied Goshawk Accipiter_albogularis    37461.21  8.156562 2.214471 0.5420387
    ## 2                  Shikra      Accipiter_badius 22374973.00  5.481852 1.869006 0.3991241
    ## 3          Bicolored Hawk     Accipiter_bicolor 14309701.27  8.097777 2.208030 0.5393742
    ## 4 New Britain Sparrowhawk  Accipiter_brachyurus    35580.71 10.813851 2.469273 0.6474472
    ## 5      Levant Sparrowhawk    Accipiter_brevipes  2936751.80  5.643636 1.893659 0.4093228
    ## 6     Nicobar Sparrowhawk     Accipiter_butleri      327.84 11.220553 2.503119 0.6614491

We can now calculate our EDGE scores using some simple maths:

```{math}
EDGE=ln⁡(1+ED)+GE×ln⁡(2)
```

We have already done the first half. Now we just need to multiply GE
scores by the natural log of 2, and combine them.

``` r
# The log function uses natural logarithms by default.
accip_EDGE$EDGE <- accip_EDGE$EDlog + accip_EDGE$extinct_prob * log(2)
head(accip_EDGE)[,c(2:3, 26:30)]
```

    ##      birdlife_common_name             jetz_name  range_size        ED    EDlog       EDn     EDGE
    ## 1            Pied Goshawk Accipiter_albogularis    37461.21  8.156562 2.214471 0.5420387 2.256493
    ## 2                  Shikra      Accipiter_badius 22374973.00  5.481852 1.869006 0.3991241 1.911028
    ## 3          Bicolored Hawk     Accipiter_bicolor 14309701.27  8.097777 2.208030 0.5393742 2.250052
    ## 4 New Britain Sparrowhawk  Accipiter_brachyurus    35580.71 10.813851 2.469273 0.6474472 2.637361
    ## 5      Levant Sparrowhawk    Accipiter_brevipes  2936751.80  5.643636 1.893659 0.4093228 1.935681
    ## 6     Nicobar Sparrowhawk     Accipiter_butleri      327.84 11.220553 2.503119 0.6614491 2.671207

Now we have our EDGE scores, we can see if our conservation priority has
changed in light of IUCN categories.

``` r
# Find the highest EDGE score.
accip_EDGE[accip_EDGE$EDGE == max(accip_EDGE$EDGE), c(2:3, 26:30)]
```

    ##     birdlife_common_name             jetz_name range_size       ED    EDlog       EDn    EDGE
    ## 217     Philippine Eagle Pithecophaga_jefferyi   142256.5 22.13085 3.141167 0.9254021 3.81352

``` r
# Find the EDGE score for our previous highest species.
accip_EDGE[accip_EDGE$EDn == max(accip_EDGE$EDn), c(2:3, 26:30)]
```

    ##     birdlife_common_name             jetz_name range_size       ED    EDlog EDn     EDGE
    ## 103  Scissor-tailed Kite Chelictinia_riocourii    5425286 26.70163 3.321491   1 3.363513
    ## 135           Pearl Kite  Gampsonyx_swainsonii   10266135 26.70163 3.321491   1 3.363513

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

```{image} practical_3_files/figure-gfm/unnamed-chunk-14-1.png
:align: center
:width: 600px
```

``` r
# WE can use the select function to pull out only the columns we want to view.
# Because there's another function called select, we specify it's from dplyr.
accip_EDGE %>% filter(EDGE > 5) %>% dplyr::select(birdlife_common_name, jetz_name, redlist_cat, EDGE)
```

    ## [1] birdlife_common_name jetz_name            redlist_cat          EDGE                
    ## <0 rows> (or 0-length row.names)

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
except traits. Then normalise our trait data so that body_mass and beak
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

    ##                       extinct_prob beak_length_culmen beak_length_nares beak_width beak_depth tarsus_length
    ## Accipiter_albogularis   -0.4668431         -0.7433418        -0.5866492 -0.5282422 -0.5329013    -0.4380073
    ## Accipiter_badius        -0.4668431         -1.1979544        -1.1153733 -0.9611877 -0.9706012    -1.2618782
    ## Accipiter_bicolor       -0.4668431         -0.9162227        -0.9669595 -1.0092927 -0.8152883    -0.6071177
    ## Accipiter_brachyurus     0.3427311         -1.0762975        -0.9391319 -0.9371351 -0.9282431    -0.4726966
    ## Accipiter_brevipes      -0.4668431         -1.1659395        -1.1153733 -0.9852402 -1.0411979    -1.1144487
    ## Accipiter_butleri        0.3427311         -1.2363724        -1.1339250 -1.4903432 -0.9141238    -1.0147170
    ##                       wing_length kipps_distance secondary1 hand_wing_index tail_length
    ## Accipiter_albogularis  -0.9721188     -0.7745186 -0.9281820      -0.1263950  -0.7249344
    ## Accipiter_badius       -1.3351297     -1.0777692 -1.3265690      -0.2537573  -1.1555232
    ## Accipiter_bicolor      -1.0140334     -1.1704728 -0.7382966      -1.3108642  -0.4626392
    ## Accipiter_brachyurus   -1.2191159     -1.0526293 -1.1937733      -0.4065920  -1.1524909
    ## Accipiter_brevipes     -1.1038506     -0.6802438 -1.2955420       0.6759874  -0.9599389
    ## Accipiter_butleri      -1.4900642     -1.3857336 -1.3799355      -1.1580294  -1.3617206

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

```{image} practical_3_files/figure-gfm/unnamed-chunk-19-1.png
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
    ## 1 Accipiter_albogularis 0.1824124
    ## 2      Accipiter_badius 0.3873134
    ## 3     Accipiter_bicolor 0.4794938
    ## 4  Accipiter_brachyurus 0.3404455
    ## 5    Accipiter_brevipes 0.3576029
    ## 6     Accipiter_butleri 0.6376099

Log and normalise the data as we did before with ED so we could compare
FD scores from different groups.

``` r
# Calculate the scores again.
FD$FDlog <- log(1+FD$FD)
FD$FDn <- (FD$FDlog - min(FD$FDlog)) / (max(FD$FDlog) - min(FD$FDlog))

# Find the highest FD score.
FD[FD$FDn == max(FD$FDn),]
```

    ##                   species      FD    FDlog FDn
    ## 217 Pithecophaga_jefferyi 3.71044 1.549781   1

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
accip_ecoDGE$ecoDGE <- accip_ecoDGE$FDlog + accip_ecoDGE$extinct_prob * log(2)
head(accip_ecoDGE)[,c(2:3, 26:30)]
```

    ##      birdlife_common_name             jetz_name  range_size        FD     FDlog        FDn    ecoDGE
    ## 1            Pied Goshawk Accipiter_albogularis    37461.21 0.1824124 0.1675568 0.00000000 0.2095788
    ## 2                  Shikra      Accipiter_badius 22374973.00 0.3873134 0.3273691 0.11561964 0.3693911
    ## 3          Bicolored Hawk     Accipiter_bicolor 14309701.27 0.4794938 0.3917000 0.16216123 0.4337221
    ## 4 New Britain Sparrowhawk  Accipiter_brachyurus    35580.71 0.3404455 0.2930020 0.09075602 0.4610902
    ## 5      Levant Sparrowhawk    Accipiter_brevipes  2936751.80 0.3576029 0.3057206 0.09995754 0.3477426
    ## 6     Nicobar Sparrowhawk     Accipiter_butleri      327.84 0.6376099 0.4932378 0.23562089 0.6613260

And does including IUCN categories change our conservation priorities?

``` r
# Find the highest ecoDGE score.
accip_ecoDGE[accip_ecoDGE$ecoDGE == max(accip_ecoDGE$ecoDGE), c(2:3, 26:30)]
```

    ##     birdlife_common_name             jetz_name range_size      FD    FDlog FDn   ecoDGE
    ## 217     Philippine Eagle Pithecophaga_jefferyi   142256.5 3.71044 1.549781   1 2.222134

``` r
# Find the ecoDGE score for Gypaetus barbatus.
accip_ecoDGE[accip_ecoDGE$jetz_name == "Gypaetus_barbatus", c(2:3, 26:30)]
```

    ##     birdlife_common_name         jetz_name range_size       FD    FDlog       FDn   ecoDGE
    ## 138      Bearded Vulture Gypaetus_barbatus    8369572 2.821342 1.340602 0.8486644 1.424646

Yes! Funnily enough the Philippine Eagle is again the species we need to
check. This may be because the GE component of ecoDGE scores is weighted
much higher than the FD component.

``` r
# Get the top 5% of FD scores.
accip_ecoDGE[accip_ecoDGE$FD > quantile(accip_ecoDGE$FD, 0.95), c(2:3, 26:30)]
```

    ##     birdlife_common_name               jetz_name  range_size       FD     FDlog       FDn    ecoDGE
    ## 47     Cinereous Vulture       Aegypius_monachus  7718571.19 1.858799 1.0504017 0.6387130 1.1344458
    ## 92        Ridgway's Hawk          Buteo_ridgwayi      210.23 1.956812 1.0841117 0.6631013 1.7564645
    ## 105           Cuban Kite  Chondrohierax_wilsonii     3890.11 2.398837 1.2234334 0.7638966 1.8957861
    ## 138      Bearded Vulture       Gypaetus_barbatus  8369572.33 2.821342 1.3406016 0.8486644 1.4246457
    ## 152  Steller's Sea-eagle    Haliaeetus_pelagicus  1293649.63 1.778069 1.0217560 0.6179888 1.1898442
    ## 164         Papuan Eagle Harpyopsis_novaeguineae   730591.98 2.196441 1.1620379 0.7194787 1.3301261
    ## 204     Egyptian Vulture   Neophron_percnopterus 14111672.38 1.852511 1.0481995 0.6371199 1.3843759
    ## 208    Flores Hawk-eagle         Nisaetus_floris    34986.16 1.522688 0.9253252 0.5482238 1.5976779
    ## 217     Philippine Eagle   Pithecophaga_jefferyi   142256.55 3.710440 1.5497814 1.0000000 2.2221341
    ## 234             Bateleur   Terathopius_ecaudatus 14023477.79 1.961504 1.0856971 0.6642483 1.1697412
    ## 235 Lappet-faced Vulture     Torgos_tracheliotos  8489832.71 2.454785 1.2397603 0.7757086 1.5759367
    ## 237     Long-tailed Hawk  Urotriorchis_macrourus  3073602.25 1.540543 0.9323778 0.5533262 0.9743999

``` r
# Get the top 5% of ecoDGE scores.
accip_ecoDGE[accip_ecoDGE$ecoDGE > quantile(accip_ecoDGE$ecoDGE, 0.95), c(2:3, 26:30)]
```

    ##     birdlife_common_name               jetz_name  range_size       FD     FDlog       FDn   ecoDGE
    ## 92        Ridgway's Hawk          Buteo_ridgwayi      210.23 1.956812 1.0841117 0.6631013 1.756464
    ## 105           Cuban Kite  Chondrohierax_wilsonii     3890.11 2.398837 1.2234334 0.7638966 1.895786
    ## 138      Bearded Vulture       Gypaetus_barbatus  8369572.33 2.821342 1.3406016 0.8486644 1.424646
    ## 141 White-rumped Vulture        Gyps_bengalensis  3047965.15 1.025159 0.7056482 0.3892938 1.378001
    ## 146    Rüppell's Vulture         Gyps_rueppellii  6445230.81 1.428763 0.8873820 0.5207730 1.559735
    ## 203       Hooded Vulture    Necrosyrtes_monachus 10764077.19 1.288388 0.8278477 0.4777016 1.500200
    ## 204     Egyptian Vulture   Neophron_percnopterus 14111672.38 1.852511 1.0481995 0.6371199 1.384376
    ## 208    Flores Hawk-eagle         Nisaetus_floris    34986.16 1.522688 0.9253252 0.5482238 1.597678
    ## 217     Philippine Eagle   Pithecophaga_jefferyi   142256.55 3.710440 1.5497814 1.0000000 2.222134
    ## 222   Red-headed Vulture        Sarcogyps_calvus  2166730.60 1.008953 0.6976139 0.3834812 1.369967
    ## 235 Lappet-faced Vulture     Torgos_tracheliotos  8489832.71 2.454785 1.2397603 0.7757086 1.575937
    ## 236 White-headed Vulture Trigonoceps_occipitalis  6011586.35 1.367185 0.8617014 0.5021938 1.534054

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

    ## Joining, by = c("birdlife_name", "birdlife_common_name", "jetz_name", "jetz_order", "jetz_family", "redlist_cat",
    ## "extinct_prob", "beak_length_culmen", "beak_length_nares", "beak_width", "beak_depth", "tarsus_length",
    ## "wing_length", "kipps_distance", "secondary1", "hand_wing_index", "tail_length", "mass", "habitat_density",
    ## "migration", "trophic_level", "trophic_niche", "primary_lifestyle", "centroid_latitude", "centroid_longitude",
    ## "range_size")

``` r
# Calculate EcoEDGE scores.
accip_EcoEDGE$EcoEDGE <- (0.5*accip_EcoEDGE$EDn + 0.5*accip_EcoEDGE$FDn) + accip_EcoEDGE$extinct_prob*log(2)

# Select just the relevant columns.
accip_EcoEDGE <- accip_EcoEDGE %>% dplyr::select(birdlife_common_name, jetz_name, 
                                                 redlist_cat, extinct_prob, EDGE, ecoDGE, EcoEDGE)

# Check it's worked.
head(accip_EcoEDGE)
```

    ##      birdlife_common_name             jetz_name redlist_cat extinct_prob     EDGE    ecoDGE   EcoEDGE
    ## 1            Pied Goshawk Accipiter_albogularis          LC     0.060625 2.256493 0.2095788 0.3130414
    ## 2                  Shikra      Accipiter_badius          LC     0.060625 1.911028 0.3693911 0.2993939
    ## 3          Bicolored Hawk     Accipiter_bicolor          LC     0.060625 2.250052 0.4337221 0.3927898
    ## 4 New Britain Sparrowhawk  Accipiter_brachyurus          VU     0.242500 2.637361 0.4610902 0.5371898
    ## 5      Levant Sparrowhawk    Accipiter_brevipes          LC     0.060625 1.935681 0.3477426 0.2966622
    ## 6     Nicobar Sparrowhawk     Accipiter_butleri          VU     0.242500 2.671207 0.6613260 0.6166232

We can again look at the spread and see which are the highest species.

``` r
# Get the highest scoring species.
accip_EcoEDGE[accip_EcoEDGE$EcoEDGE == max(accip_EcoEDGE$EcoEDGE),]
```

    ##     birdlife_common_name             jetz_name redlist_cat extinct_prob    EDGE   ecoDGE  EcoEDGE
    ## 217     Philippine Eagle Pithecophaga_jefferyi          CR         0.97 3.81352 2.222134 1.635054

``` r
# Get the top 10% of EcoEDGE scores.
accip_EcoEDGE[accip_EcoEDGE$EcoEDGE > quantile(accip_EcoEDGE$EcoEDGE, 0.9),]
```

    ##         birdlife_common_name               jetz_name redlist_cat extinct_prob     EDGE    ecoDGE   EcoEDGE
    ## 92            Ridgway's Hawk          Buteo_ridgwayi          CR     0.970000 2.212389 1.7564645 1.1354199
    ## 105               Cuban Kite  Chondrohierax_wilsonii          CR     0.970000 3.126552 1.8957861 1.3749069
    ## 127      Swallow-tailed Kite    Elanoides_forficatus          LC     0.060625 3.337099 0.9280096 0.7964405
    ## 134 Madagascar Serpent-eagle       Eutriorchis_astur          EN     0.485000 3.609771 0.8557502 0.9536064
    ## 138          Bearded Vulture       Gypaetus_barbatus          NT     0.121250 3.273313 1.4246457 0.9810268
    ## 140     White-backed Vulture          Gyps_africanus          CR     0.970000 2.609136 1.2535639 1.0355677
    ## 141     White-rumped Vulture        Gyps_bengalensis          CR     0.970000 2.463403 1.3780010 1.0504370
    ## 145           Indian Vulture            Gyps_indicus          CR     0.970000 2.250380 1.2629707 0.9647638
    ## 146        Rüppell's Vulture         Gyps_rueppellii          CR     0.970000 2.268981 1.5597348 1.0759614
    ## 147   Slender-billed Vulture       Gyps_tenuirostris          CR     0.970000 2.250356 1.3535684 0.9975314
    ## 151      Pallas's Fish-eagle  Haliaeetus_leucoryphus          EN     0.485000 2.601584 0.9727049 0.7873756
    ## 155    Madagascar Fish-eagle Haliaeetus_vociferoides          CR     0.970000 2.751669 1.2992752 1.0815851
    ## 164             Papuan Eagle Harpyopsis_novaeguineae          VU     0.242500 3.400970 1.3301261 1.0094991
    ## 180      White-collared Kite        Leptodon_forbesi          EN     0.485000 2.801549 0.9152403 0.8079501
    ## 202            Crested Eagle     Morphnus_guianensis          NT     0.121250 3.208049 0.9785285 0.8061509
    ## 203           Hooded Vulture    Necrosyrtes_monachus          CR     0.970000 3.287320 1.5002005 1.2650633
    ## 204         Egyptian Vulture   Neophron_percnopterus          EN     0.485000 3.525445 1.3843759 1.1273868
    ## 208        Flores Hawk-eagle         Nisaetus_floris          CR     0.970000 2.520177 1.5976779 1.1416453
    ## 217         Philippine Eagle   Pithecophaga_jefferyi          CR     0.970000 3.813520 2.2221341 1.6350538
    ## 222       Red-headed Vulture        Sarcogyps_calvus          CR     0.970000 3.284243 1.3699666 1.2173165
    ## 229 Black-and-chestnut Eagle       Spizaetus_isidori          EN     0.485000 2.662982 1.0084516 0.8130062
    ## 234                 Bateleur   Terathopius_ecaudatus          NT     0.121250 3.177064 1.1697412 0.8689102
    ## 235     Lappet-faced Vulture     Torgos_tracheliotos          EN     0.485000 2.589196 1.5759367 1.0030236
    ## 236     White-headed Vulture Trigonoceps_occipitalis          CR     0.970000 3.045750 1.5340542 1.2273420

``` r
# See the spread.
hist(accip_EcoEDGE$EcoEDGE, breaks = 20)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-30-1.png
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
GE_raster <- fasterize(accip_ranges, raster_template, field = "extinct_prob", fun = "max")

# Plot the new map.
plot(GE_raster)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-32-1.png
:align: center
:width: 600px
```

Now we’ve created our stack of range maps, and each are coded for their
IUCN category. In this case we’ll take the maximum GE score as the one
that’s shown. So if two ranges overlap, we take the highest score.

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
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-33-1.png
:align: center
:width: 600px
```

There’s our finished map! Think how you’d change it yourself if you want
to include one in your report. It’s up to you and what you think is the
best way to visualise your data!

> Extra task: Do you think this is a good way to show the data? What
> would you do differently? Could you use another metric from today’s
> practical like EDGE? And is taking the highest score when cells
> overlap the best option? Instead try and create an average extinction
> probability raster.

```{tip}
Fasterize doesn't have a mean function option, but we can get around this by dividing one raster by another. 
We first need to sum all the extinction probabilities, and then divide by species richness. Look back at 
[Practical 1](https://syrph.github.io/BCB_2022/markdowns/practical_1/practical_1.html#plotting-maps) for a reminder of how to create a species richness raster. Then it's as easy as:
  
  `average_raster <- sum_raster / richness_raster`
  
```

We can create an average raster by dividing our `GE_raster` with a
species richness raster we created in practical 1. Given that the code
to do this: `average_raster <- GE_raster / range_raster`, could you
create an average extinction probability raster? (Look at how we created
the range_raster in practical 1).

::::{admonition} Show the answer…  
:class: dropdown

``` r
# Sum all the extinction probabilities.
sum_raster <- fasterize(accip_ranges, raster_template, field = "extinct_prob", fun = "sum")

# Use the sum function with no field for richness. (Assumes each range = 1).
richness_raster <- fasterize(accip_ranges, raster_template, fun = "sum")

# Divide the total by number of species to get average.
average_raster <- sum_raster / richness_raster

# Plot the new map.
plot(average_raster)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-35-1.png
:align: center
:width: 600px
```

::::
