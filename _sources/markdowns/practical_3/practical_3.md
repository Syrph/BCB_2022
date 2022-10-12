## Setting conservation priorities

### 1. Introduction and resources

This practical is aimed to introduce you to the EDGE & EcoEDGE scores
that you’ll need for your conservation strategy coursework. Put briefly,
these scores balance the distinctiveness of species against their risk
of extinction to determine conservation priorities. You can find out
more information about EDGE scores from the ZSL website:

<https://www.zsl.org/conservation/our-priorities/wildlife-back-from-the-brink/animals-on-the-edge>

We will also try plotting a simple map of IUCN categories so we can
visual the risk to our clade across the globe.

### 2. Preparing data

To calculate EDGE metrics, we need data on the species we’re interested
in, and their phylogenetic relationship. For the coursework we’re
interested in EDGE scores for a specific clade, however it’s also common
to look at areas such as national parks.

For this practical we’re going to use the same family as Practical 2,
Accipitridae. We’ll use the same table of traits from Practical 2 to
import our data and filter it.

``` r
# Read in the avonet data again.
trait_data <- read.csv("data/avonet_data.csv")
str(trait_data)
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
    ## [26] range_size           beak_shape           body_shape          
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
ED (Evolutionary Distinctiveness) scores. Then we can figure out if
specific Accipitridae species are closely related to others in the tree,
or represent distinct lineages that might want to conserve to protect
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

We now have the ED scores of 237 species in Accipitridae. With these
scores we can see how unique our species are in terms of the
evolutionary pathway.

``` r
# Find the highest ED score.
ED[ED$EDn == max(ED$EDn),]
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
scores. For these practicals we’ll use the extinction probabilities
suggested by Mooers *et al.* (2008), looking at a 50 year time frame.
Here’s the link to the publication, which you should cite in your
reports.

<https://doi.org/10.1371/journal.pone.0003700.t001>

These extinction probabilities are also referred to as GE (Globally
Endangered) scores, which is why it’s called EDGE. We’ll add the ED
scores to the main dataset first, and then we can easily calculate EDGE.

``` r
# Join the last two columns of UK_Jetz to ED scores. 
# This time we'll use the 'by' argument rather than change the column names.
accip_EDGE <- left_join(accip_data, ED,  by = c("jetz_name" = "species"))

# Head but we'll view just the first and last few columns.
head(accip_EDGE)[,c(2:3, 26:29)]
```

    ##      birdlife_common_name             jetz_name  range_size beak_shape  body_shape        ED
    ## 1            Pied Goshawk Accipiter_albogularis    37461.21 -0.5939811 -0.02798680  8.156562
    ## 2                  Shikra      Accipiter_badius 22374973.00 -0.5381898 -0.22657971  5.481852
    ## 3          Bicolored Hawk     Accipiter_bicolor 14309701.27 -0.4418864 -0.34192565  8.097777
    ## 4 New Britain Sparrowhawk  Accipiter_brachyurus    35580.71 -0.4985385  0.26723952 10.813851
    ## 5      Levant Sparrowhawk    Accipiter_brevipes  2936751.80 -0.4866800 -0.27106661  5.643636
    ## 6     Nicobar Sparrowhawk     Accipiter_butleri      327.84 -0.4403345  0.07580829 11.220553

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

    ##      birdlife_common_name             jetz_name  range_size beak_shape  body_shape        ED    EDlog
    ## 1            Pied Goshawk Accipiter_albogularis    37461.21 -0.5939811 -0.02798680  8.156562 2.214471
    ## 2                  Shikra      Accipiter_badius 22374973.00 -0.5381898 -0.22657971  5.481852 1.869006
    ## 3          Bicolored Hawk     Accipiter_bicolor 14309701.27 -0.4418864 -0.34192565  8.097777 2.208030
    ## 4 New Britain Sparrowhawk  Accipiter_brachyurus    35580.71 -0.4985385  0.26723952 10.813851 2.469273
    ## 5      Levant Sparrowhawk    Accipiter_brevipes  2936751.80 -0.4866800 -0.27106661  5.643636 1.893659
    ## 6     Nicobar Sparrowhawk     Accipiter_butleri      327.84 -0.4403345  0.07580829 11.220553 2.503119

Now we have our EDGE scores, we can see if our conservation priority has
changed in light of IUCN categories.

``` r
# Find the highest EDGE score.
accip_EDGE[accip_EDGE$EDGE == max(accip_EDGE$EDGE), c(2:3, 28:32)]
```

    ##     birdlife_common_name             jetz_name body_shape       ED    EDlog       EDn    EDGE
    ## 217     Philippine Eagle Pithecophaga_jefferyi  -0.926998 22.13085 3.141167 0.9254021 3.81352

``` r
# Find the EDGE score for our previous highest species.
accip_EDGE[accip_EDGE$EDn == max(accip_EDGE$EDn), c(2:3, 28:32)]
```

    ##     birdlife_common_name             jetz_name body_shape       ED    EDlog EDn     EDGE
    ## 103  Scissor-tailed Kite Chelictinia_riocourii -1.2036786 26.70163 3.321491   1 3.363513
    ## 135           Pearl Kite  Gampsonyx_swainsonii -0.1955286 26.70163 3.321491   1 3.363513

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

```{image} practical_3_files/figure-gfm/unnamed-chunk-13-1.png
:align: center
:width: 600px
```

``` r
# WE can use the select function to pull out only the columns we want to view.
# Because there's another function called select, we specify it's from dplyr.
accip_EDGE %>% filter(EDGE > 3) %>% dplyr::select(birdlife_common_name, jetz_name, redlist_cat, EDGE)
```

    ##        birdlife_common_name               jetz_name redlist_cat     EDGE
    ## 1       Scissor-tailed Kite   Chelictinia_riocourii          LC 3.363513
    ## 2                Cuban Kite  Chondrohierax_wilsonii          CR 3.126552
    ## 3       Swallow-tailed Kite    Elanoides_forficatus          LC 3.337099
    ## 4     Black-shouldered Kite        Elanus_axillaris          LC 3.003864
    ## 5         Black-winged Kite        Elanus_caeruleus          LC 3.003864
    ## 6         White-tailed Kite         Elanus_leucurus          LC 3.135128
    ## 7        Letter-winged Kite         Elanus_scriptus          NT 3.177150
    ## 8  Madagascar Serpent-eagle       Eutriorchis_astur          EN 3.609771
    ## 9                Pearl Kite    Gampsonyx_swainsonii          LC 3.363513
    ## 10          Bearded Vulture       Gypaetus_barbatus          NT 3.273313
    ## 11         Palm-nut Vulture   Gypohierax_angolensis          LC 3.338387
    ## 12              Harpy Eagle          Harpia_harpyja          NT 3.208049
    ## 13             Papuan Eagle Harpyopsis_novaeguineae          VU 3.400970
    ## 14                 Bat Hawk   Macheiramphus_alcinus          LC 3.297136
    ## 15            Gabar Goshawk          Melierax_gabar          LC 3.010849
    ## 16            Crested Eagle     Morphnus_guianensis          NT 3.208049
    ## 17           Hooded Vulture    Necrosyrtes_monachus          CR 3.287320
    ## 18         Egyptian Vulture   Neophron_percnopterus          EN 3.525445
    ## 19         Philippine Eagle   Pithecophaga_jefferyi          CR 3.813520
    ## 20       Red-headed Vulture        Sarcogyps_calvus          CR 3.284243
    ## 21                 Bateleur   Terathopius_ecaudatus          NT 3.177064
    ## 22     White-headed Vulture Trigonoceps_occipitalis          CR 3.045750
    ## 23         Long-tailed Hawk  Urotriorchis_macrourus          LC 3.017105

```{tip}
In the above code we used the pipe operator `%>%` twice! This is why it's called a pipe. 
We can get the end product of each function to "flow" down to the next, like water 
down a pipe! 
```

### 5. EcoDGE Scores

Instead of evolutionary distinctiveness, we might instead be interested
in what functions each species provides the ecosystem. Species with low
functional distinctiveness may be ‘functionally redundant’ in the
ecosystem, whereas those with high functional distinctiveness may
provide key ecosystem services that aren’t easily replaceable. We call
these scores EcoDGE scores, with “eco” short for ecologically diverse.

Like ED, we will calculate functional distinctiveness (FD and FDn) in
relation to all other accipitridae species. The reason for this is that
FD is traditionally used in the context of a specific community or
radiation of species (i.e. all birds found within a national park, or
all species of lemur).

To calculate the function of species, we’ll use their morphological
traits. Recent research (Pigot *et al.* 2020) has shown that a few
simple traits can predict the niche a species occupies, which in turn
tells us about function. For instance, frugivores provide vital seed
dispersal, and insectivores influence invertebrate population dynamics.

You can read the full article here:
<https://www.nature.com/articles/s41559-019-1070-4>

We’ll use just a few key traits, separated into beak traits (primarily
trophic), body traits (primarily locomotion), hand wing index (flight
ability), and body mass.

First we should check correlations between our traits:

``` r
# First log body mass.
accip_data$log_mass <- log(accip_data$mass)

# Split the traits into beak shape traits, body shape traits, and body mass.
beak_traits <- accip_data %>% dplyr::select(beak_length_culmen, beak_width, 
                                            beak_depth, log_mass, hand_wing_index)
body_traits <- accip_data %>% dplyr::select(tarsus_length, wing_length, 
                                            tail_length, log_mass, hand_wing_index)

# Look at the correlations between traits, including body mass.
pairs(beak_traits)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-16-1.png
:align: center
:width: 600px
```

``` r
pairs(body_traits)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-16-2.png
:align: center
:width: 600px
```

So we can see some pretty strong correlations between beak shape, body
shape and body mass. This is because bigger species tend to have
proportionally bigger traits. If we were to calculate functional
distinctiveness using these traits in their current form, we would
probably only determine which species are biggest and smallest. Another
problem is that when all the traits are highly correlated, it’s harder
to tell which ones are important for functional distinctiveness. Instead
our model may simply pick them at random, leading to potentially random
results.

Instead we can use two variables from Pigot *et al.* (2020), “beak
shape”, and “body shape”. These variables were created using a Principal
Components Analysis (PCA) to condense our traits down into fewer
uncorrelated variables, removing body mass as the dominant effect.

```{tip}
We won't go into much detail on how a PCA works, as we want to focus on understanding the role of functional distinctivness in conservation. If you'd like to know in more detail, StatQuest has a great 5 minute [video](https://www.youtube.com/watch?v=HMOI_lkzW08&ab_channel=StatQuestwithJoshStarmer).
```

After removing body mass as the dominant effect, beak shape correlates
positively with beak length, and negatively with beak width and depth.
So a higher value beak shape means a narrower longer beak. For body
shape, there is a positive correlation with tarsus length, and a
negative correlation with tail length. So the most extreme would be tall
birds like Ostrichs and Flamingos.

We can check to see if there’s still any strong positive or negative
correlations:

``` r
# Split the traits into beak shape traits, body shape traits, and body mass.
functional_traits <- accip_data %>% dplyr::select(beak_shape, body_shape, log_mass, hand_wing_index)

# Look at the correlations between traits.
pairs(functional_traits)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-18-1.png
:align: center
:width: 600px
```

No clear positive or negative patterns, so we’re okay to go forward and
calculate functional diversity.

First we need to create a distance matrix of our traits. Species with
similar traits will have smaller ‘distances’.

``` r
# Scale traits for accipitridae and add in the rownames for the species.
functional_traits <- functional_traits %>% scale()
rownames(functional_traits) <- accip_data$jetz_name

# Converts traits into 'distance' in trait space.
distance_matrix <- dist(functional_traits)
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

```{image} practical_3_files/figure-gfm/unnamed-chunk-20-1.png
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
    ## 1 Accipiter_albogularis 0.1818938
    ## 2      Accipiter_badius 0.3805310
    ## 3     Accipiter_bicolor 0.2762702
    ## 4  Accipiter_brachyurus 0.2123725
    ## 5    Accipiter_brevipes 0.3782609
    ## 6     Accipiter_butleri 0.2462585

Log and normalise the data as we did before with ED so we could compare
FD scores from different groups.

``` r
# Calculate the scores again.
FD$FDlog <- log(1+FD$FD)
FD$FDn <- (FD$FDlog - min(FD$FDlog)) / (max(FD$FDlog) - min(FD$FDlog))

# Find the highest FD score.
FD[FD$FDn == max(FD$FDn),]
```

    ##                   species       FD    FDlog FDn
    ## 204 Neophron_percnopterus 2.125431 1.139572   1

So the species with the largest FD score is *Neophron percnopterus*, the
Egyptian Vulture. This means *N. percnopterus* is the most ecologically
diverse species in our clade, based on the morphological values we’ve
supplied. They’re one of the smallest vultures, feeding on carrion, but
also small birds, mammals and reptiles.

You might be interested to know that *N. percnopterus* is also a very
unique bird, due to its rare tool use. They often use pebbles as hammers
to smash large bird eggs. A great example of how FD measures can
correlate with unique ecosystem roles.

We can also look at the top 5% of functionally distinct species.

``` r
# Get the top 5% of FD scores.
FD[FD$FD > quantile(FD$FD, 0.95),]
```

    ##                     species       FD     FDlog       FDn
    ## 103   Chelictinia_riocourii 1.553098 0.9373074 0.8020503
    ## 117          Circus_cyaneus 1.096069 0.7400637 0.6090147
    ## 127    Elanoides_forficatus 1.086105 0.7352989 0.6043516
    ## 138       Gypaetus_barbatus 1.635275 0.9689876 0.8330547
    ## 152    Haliaeetus_pelagicus 1.377417 0.8660146 0.7322785
    ## 161          Harpia_harpyja 1.303039 0.8342294 0.7011715
    ## 164 Harpyopsis_novaeguineae 1.277467 0.8230639 0.6902441
    ## 204   Neophron_percnopterus 2.125431 1.1395722 1.0000000
    ## 216     Pernis_ptilorhyncus 1.481955 0.9090467 0.7743926
    ## 233 Stephanoaetus_coronatus 1.489534 0.9120954 0.7773763
    ## 234   Terathopius_ecaudatus 1.177655 0.7782485 0.6463849
    ## 235     Torgos_tracheliotos 1.751968 1.0123163 0.8754590

So these are the most functionally distinct species in our dataset, each
providing an ecosystem role that is not easily replaceable. However,
most of these species don’t currently face high extinction risk. We
should therefore combine GE scores to see how IUCN categories change our
priorities. We use the same formula as before:

```{math}
ecoDGE=ln⁡(1+FD)+GE×ln⁡(2)
```

``` r
# Join FD and GE scores.
accip_ecoDGE <- left_join(accip_data, FD, by = c("jetz_name" = "species"))

# Calculate ecoDGE scores.
accip_ecoDGE$ecoDGE <- accip_ecoDGE$FDlog + accip_ecoDGE$extinct_prob * log(2)
head(accip_ecoDGE)[,c(2:3, 6, 27:30)]
```

    ##      birdlife_common_name             jetz_name redlist_cat beak_shape  body_shape log_mass        FD
    ## 1            Pied Goshawk Accipiter_albogularis          LC -0.5939811 -0.02798680 5.516649 0.1818938
    ## 2                  Shikra      Accipiter_badius          LC -0.5381898 -0.22657971 4.876723 0.3805310
    ## 3          Bicolored Hawk     Accipiter_bicolor          LC -0.4418864 -0.34192565 5.661223 0.2762702
    ## 4 New Britain Sparrowhawk  Accipiter_brachyurus          VU -0.4985385  0.26723952 4.955827 0.2123725
    ## 5      Levant Sparrowhawk    Accipiter_brevipes          LC -0.4866800 -0.27106661 5.228431 0.3782609
    ## 6     Nicobar Sparrowhawk     Accipiter_butleri          VU -0.4403345  0.07580829 4.804021 0.2462585

And does including IUCN categories change our conservation priorities?

``` r
# Find the highest ecoDGE score.
accip_ecoDGE[accip_ecoDGE$ecoDGE == max(accip_ecoDGE$ecoDGE), c(2:3, 6, 30:33)]
```

    ##     birdlife_common_name             jetz_name redlist_cat       FD    FDlog FDn   ecoDGE
    ## 204     Egyptian Vulture Neophron_percnopterus          EN 2.125431 1.139572   1 1.475749

In this case, there is no change in our highest species. That’s because
*N percnopterus* is often found in built up Mediterranean communities,
which are increasingly threatened by human land use impacts. As such, it
is currently listed as endangered.

We can also look at the top species to see if there are any changes:

``` r
# Get the top 5% of ecoDGE scores.
accip_ecoDGE[accip_ecoDGE$ecoDGE > quantile(accip_ecoDGE$ecoDGE, 0.95), c(2:3, 6, 30:33)]
```

    ##       birdlife_common_name              jetz_name redlist_cat        FD     FDlog       FDn   ecoDGE
    ## 105             Cuban Kite Chondrohierax_wilsonii          CR 0.4896142 0.3985171 0.2747549 1.070870
    ## 138        Bearded Vulture      Gypaetus_barbatus          NT 1.6352751 0.9689876 0.8330547 1.053032
    ## 140   White-backed Vulture         Gyps_africanus          CR 0.4664185 0.3828231 0.2593957 1.055176
    ## 141   White-rumped Vulture       Gyps_bengalensis          CR 0.5886831 0.4629054 0.3377695 1.135258
    ## 146   R\xfcppell's Vulture        Gyps_rueppellii          CR 0.8266461 0.6024815 0.4743678 1.274834
    ## 147 Slender-billed Vulture      Gyps_tenuirostris          CR 0.8447004 0.6123169 0.4839933 1.284670
    ## 203         Hooded Vulture   Necrosyrtes_monachus          CR 1.0765008 0.7306842 0.5998353 1.403037
    ## 204       Egyptian Vulture  Neophron_percnopterus          EN 2.1254312 1.1395722 1.0000000 1.475749
    ## 208      Flores Hawk-eagle        Nisaetus_floris          CR 0.5400292 0.4318014 0.3073291 1.104154
    ## 217       Philippine Eagle  Pithecophaga_jefferyi          CR 0.6731602 0.5147142 0.3884729 1.187067
    ## 222     Red-headed Vulture       Sarcogyps_calvus          CR 0.8707367 0.6263323 0.4977098 1.298685
    ## 235   Lappet-faced Vulture    Torgos_tracheliotos          EN 1.7519680 1.0123163 0.8754590 1.348493

As we can see, nearly all of the highest ecoDGE scores are critically
endangered, which means we could soon lose their unique ecosystem
functions. The removal of enough of these species may even cause a
collapse in the current ecosystem, as species are unable to fill vital
niches. But is it right to focus on these species instead of our top
EDGE species? Could you argue a case for EDGE or ecoDGE as the top
priority of conservation?

### 6. EcoEDGE Scores

So we’ve used EDGE scores to combine extinction risk with evolutionary
distinctiveness, and ecoDGE scores to do the same with functional
distinctiveness, However, both are important, and we might want to
combine all three into one metric. This is exactly what EcoEDGE scores
do (confusingly, their creators decided to use very very similar names).
And we’ve pretty much done all the hard work already. The equation is
similar to the ones we’ve used, but we give ED and FD scores equal
weighting:

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
    ## "range_size", "beak_shape", "body_shape")

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
    ## 1            Pied Goshawk Accipiter_albogularis          LC     0.060625 2.256493 0.2091401 0.3371877
    ## 2                  Shikra      Accipiter_badius          LC     0.060625 1.911028 0.3644903 0.3417483
    ## 3          Bicolored Hawk     Accipiter_bicolor          LC     0.060625 2.250052 0.2859640 0.3734479
    ## 4 New Britain Sparrowhawk  Accipiter_brachyurus          VU     0.242500 2.637361 0.3606674 0.5284171
    ## 5      Levant Sparrowhawk    Accipiter_brevipes          LC     0.060625 1.935681 0.3628445 0.3460423
    ## 6     Nicobar Sparrowhawk     Accipiter_butleri          VU     0.242500 2.671207 0.3882340 0.5489073

We can again look at the spread and see which are the highest species.

``` r
# Get the highest scoring species.
accip_EcoEDGE[accip_EcoEDGE$EcoEDGE == max(accip_EcoEDGE$EcoEDGE),]
```

    ##     birdlife_common_name             jetz_name redlist_cat extinct_prob    EDGE   ecoDGE EcoEDGE
    ## 217     Philippine Eagle Pithecophaga_jefferyi          CR         0.97 3.81352 1.187067 1.32929

``` r
# Get the top 10% of EcoEDGE scores.
accip_EcoEDGE[accip_EcoEDGE$EcoEDGE > quantile(accip_EcoEDGE$EcoEDGE, 0.9),]
```

    ##         birdlife_common_name               jetz_name redlist_cat extinct_prob     EDGE    ecoDGE   EcoEDGE
    ## 92            Ridgway's Hawk          Buteo_ridgwayi          CR     0.970000 2.212389 1.0026395 0.9078593
    ## 103      Scissor-tailed Kite   Chelictinia_riocourii          LC     0.060625 3.363513 0.9793294 0.9430472
    ## 105               Cuban Kite  Chondrohierax_wilsonii          CR     0.970000 3.126552 1.0708699 1.1303361
    ## 127      Swallow-tailed Kite    Elanoides_forficatus          LC     0.060625 3.337099 0.7773209 0.8387342
    ## 134 Madagascar Serpent-eagle       Eutriorchis_astur          EN     0.485000 3.609771 0.7029360 0.9481067
    ## 138          Bearded Vulture       Gypaetus_barbatus          NT     0.121250 3.273313 1.0530317 0.9732219
    ## 140     White-backed Vulture          Gyps_africanus          CR     0.970000 2.609136 1.0551758 1.0156320
    ## 141     White-rumped Vulture        Gyps_bengalensis          CR     0.970000 2.463403 1.1352582 1.0246749
    ## 145           Indian Vulture            Gyps_indicus          CR     0.970000 2.250380 1.0452909 0.9365883
    ## 146     R\xfcppell's Vulture         Gyps_rueppellii          CR     0.970000 2.268981 1.2748343 1.0527589
    ## 147   Slender-billed Vulture       Gyps_tenuirostris          CR     0.970000 2.250356 1.2846697 1.0537193
    ## 152      Steller's Sea-eagle    Haliaeetus_pelagicus          VU     0.242500 2.413923 1.0341028 0.8117343
    ## 155    Madagascar Fish-eagle Haliaeetus_vociferoides          CR     0.970000 2.751669 0.9510990 0.9941858
    ## 161              Harpy Eagle          Harpia_harpyja          NT     0.121250 3.208049 0.9182735 0.8937809
    ## 164             Papuan Eagle Harpyopsis_novaeguineae          VU     0.242500 3.400970 0.9911521 0.9948818
    ## 203           Hooded Vulture    Necrosyrtes_monachus          CR     0.970000 3.287320 1.4030370 1.3261301
    ## 204         Egyptian Vulture   Neophron_percnopterus          EN     0.485000 3.525445 1.4757486 1.3088269
    ## 208        Flores Hawk-eagle         Nisaetus_floris          CR     0.970000 2.520177 1.1041542 1.0211979
    ## 217         Philippine Eagle   Pithecophaga_jefferyi          CR     0.970000 3.813520 1.1870669 1.3292903
    ## 222       Red-headed Vulture        Sarcogyps_calvus          CR     0.970000 3.284243 1.2986851 1.2744308
    ## 233            Crowned Eagle Stephanoaetus_coronatus          NT     0.121250 2.938676 0.9961395 0.8761651
    ## 234                 Bateleur   Terathopius_ecaudatus          NT     0.121250 3.177064 0.8622926 0.8599785
    ## 235     Lappet-faced Vulture     Torgos_tracheliotos          EN     0.485000 2.589196 1.3484927 1.0528988
    ## 236     White-headed Vulture Trigonoceps_occipitalis          CR     0.970000 3.045750 1.0096577 1.0836694

``` r
# See the spread.
hist(accip_EcoEDGE$EcoEDGE, breaks = 20)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-30-1.png
:align: center
:width: 600px
```

So when combining EDGE and ecoDGE, the Philippine Eagle is the highest
species. In general, we might expect ED and FD to correlate, as species
with many close relatives are likely to share morphological traits that
determine function. For your own taxa, you might find that these scores
match up, or perhaps there are different conservation priorities for
each metric. Because we don’t tend to focus on conserving a single
species, there should be differences between each metric that make
deciding conservation priorities a complicated task. How you chose to
interpret and present your results is up to you, and will depend on the
group that you’ve chosen.

For the practicals and coursework we’ve chosen to use a simplified
version of EcoEDGE scores. If you’re interested in learning more, check
out this paper which first proposed the use of EcoEDGE scores:

<https://onlinelibrary.wiley.com/doi/full/10.1111/ddi.12320>

```{tip}
For your coursework, you should cite both the original [EDGE reference](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0000296), as well as the [EcoEDGE reference](https://onlinelibrary.wiley.com/doi/full/10.1111/ddi.12320).

In general, most of the papers linked in this practical will be useful citations you should think about including.
```

### 7. Plotting a map of IUCN categories

You may wish to plot maps of your IUCN redlist categories, especially if
you’re interested in what areas of the world are most threatened by
extinction. We can do this easily using similar code from practical 2.

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

# Plot the new map. Colour ramp palette is another way to make a palette.
# The second brackets (50) is the number of colours to create from the function.
green_to_red <- colorRampPalette(c("forestgreen", "khaki", "firebrick"))(20)
plot(as.factor(GE_raster), col=green_to_red)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-33-1.png
:align: center
:width: 600px
```

```{tip}
You can use `colors()` to see the list of all the named colours to play with.
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

```{image} practical_3_files/figure-gfm/unnamed-chunk-35-1.png
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

```{image} practical_3_files/figure-gfm/unnamed-chunk-37-1.png
:align: center
:width: 600px
```

In this case we can see that the two maps are actually quite similar. If
we look close enough we can see there are some cells that have a higher
extinction risk (like in southern Spain), but there are so few we’d
probably call them outliers. This stretches out our colour scale, and
makes it hard to determine relative patterns for the rest of the world.
We can instead take logs, which reduces the effect of outliers.

``` r
# Plot the map after logging cell values.
plot(log(average_raster), col = green_to_red)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-38-1.png
:align: center
:width: 600px
```

Now we can see the pattern clearer. For your coursework, experiment with
different metrics and methods to produce the best looking and most
informative maps. Lastly we can redo the maps with ggplot, and rescale
the values so that it’s relative extinction risk (not probability).

``` r
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
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-39-1.png
:align: center
:width: 600px
```

::::
