## Macroecology analyses

### 1. Introduction and resources

This practical should be a refresher on linear models in `R`, before
introducing you to a phylogenetic least squares model, or a PGLS.
Because species that are closely related often share similar traits,
this means we can’t treat them as statistically independent. However, if
we look at how the traits are spread throughout the tree, we can
‘control’ for this non-independence. We’ll go into more detail when we
run our PGLS.

### 2. Linear models

For this practical we’ll be working data from the family Anatidae
(ducks) to investigate Bergmann’s rule - if there is a relationship
between latitude and body mass. First, we’ll load in the data and
inspect it:

``` r
# Remember to clear your workspace before starting a new project.
rm(list=ls())

# Load the duck latitudinal and body mass data.
duck_data <- read.csv("data/duck_data.csv", header = TRUE) 

# Check it's been imported.
str(duck_data)
head(duck_data)

# Remove any NAs in the data (make sure to check you're not loosing too much data!)
duck_data <- na.omit(duck_data)
```

    ## 'data.frame':    156 obs. of  3 variables:
    ##  $ jetz_name: chr  "Dendrocygna viduata" "Dendrocygna autumnalis" "Dendrocygna guttata" "Dendrocygna arborea" ...
    ##  $ latitude : num  -5.68 -5.68 -3.41 19.66 -0.38 ...
    ##  $ body_mass: num  690 755 800 1150 756 ...
    ##                jetz_name latitude body_mass
    ## 1    Dendrocygna viduata    -5.68    689.99
    ## 2 Dendrocygna autumnalis    -5.68    755.30
    ## 3    Dendrocygna guttata    -3.41    800.00
    ## 4    Dendrocygna arborea    19.66   1150.00
    ## 5    Dendrocygna bicolor    -0.38    756.37
    ## 6     Dendrocygna eytoni   -21.27    789.99

The midpoint latitude is the centre of the distribution of each species.
Because we’re interested in the distance from equator, we’ll use the
`abs()` function to convert our data.

``` r
# The abs function takes absolute value.
duck_data$abs_latitude <- abs(duck_data$latitude)
```

We’ll start by looking at the relationship between body mass and
latitude using a scatter plot.

``` r
# Create a basic plot for data visualisation.
# Notice we can add a data argument instead of using $
plot(body_mass ~ abs_latitude, data = duck_data)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-3-1.png
:align: center
:width: 600px
```

Now there doesn’t seem to be much of a relationship at all from our
plot. However, if we remember back to practical 1, body mass is often
logarithmically distributed, with lots of small species and fewer large
ones. Therefore we might not be seeing the true relationship!

``` r
# We'll use a histogram to look at the spread.
hist(duck_data$body_mass)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-4-1.png
:align: center
:width: 600px
```

As we suspected! The histogram suggests a log-normal distribution. If we
take logs we might see a more normal distribution.

``` r
# Create a new variable and take logs.
duck_data$log_BM <- log(duck_data$body_mass)
hist(duck_data$log_BM)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-5-1.png
:align: center
:width: 600px
```

Now we’ve got some data that resembles a more normal distribution! Let’s
look at the new relationship between the two variables:

``` r
# Create a new plot.
plot(log_BM ~ abs_latitude, data = duck_data)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-6-1.png
:align: center
:width: 600px
```

Now we’re starting to see some kind of relationship! There’s a lot of
spread to the points, but we can see the smallest species at the lowest
latitudes, and the largest at the highest. To really find out if there’s
a relationship we can test our hypothesis with a linear model.

``` r
# Run a basic linear model. We separate our dependant variables from predictors using a tilda ~
duck_model <- lm(log_BM ~ abs_latitude, data = duck_data)

# Inspect our linear model.
summary(duck_model)
```

    ## 
    ## Call:
    ## lm(formula = log_BM ~ abs_latitude, data = duck_data)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -1.3202 -0.5291 -0.0613  0.3249  2.1978 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  6.505760   0.124237  52.366  < 2e-16 ***
    ## abs_latitude 0.011639   0.002933   3.969 0.000112 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.725 on 150 degrees of freedom
    ## Multiple R-squared:  0.09503,    Adjusted R-squared:  0.089 
    ## F-statistic: 15.75 on 1 and 150 DF,  p-value: 0.0001117

Now we can investigate if there is a relationship. There’s quite a lot
going on with our output, but for this practical we’ll focus on just a
few main things:

`Coefficients`: This tells us about our predictors in the model. In this
one there’s 2, the intercept, and latitude. We’ll break each section
down further.

`Estimate`: This tells us what mean values of our coefficients should
have. For the intercept this will be the point that crosses the y axis.
For latitude, this will be the gradient of the relationship between
latitude and body mass.

`Std. Error`: This shows how much faith we have in our estimates. We’re
fairly certain that our estimates will fall within the range: Estimate
+- Standard Error.

`t value`: This is our test statistic. In a linear model we’re testing
if each of our estimated values are significantly different from zero.
If the Estimate +- (2 x Standard Errors) doesn’t overlap zero, it
normally means they are significant.

`Pr(>|t|)`: This is our p values for each predictor. This is calculated
by weighing up the degrees of freedom against our test statistic, and
tells us what the chance is that we observed the same pattern in our
data given that there was no relationship, i.e. the null hypothesis is
true.

`Multiple R-squared`: This tells us how much of the variation in our
response variable is explained by our model. Large values are better,
but often in macro-evolution we see smaller values. Because traits at a
macro scale are often driven by multiple selection pressures, which may
sometimes be species-specific, we expect less variation to be explained
than in smaller more targeted studies.

`Adjusted R squared`: This also tells us the varition explained in
response, but penalises us for including more predictors. This reduces
the chances of over-fitting models with lots of predictors that don’t
contribute much. This is the R-squared that tends to be reported in
publications.

`F Statistc` & `DF` & `p-value`: The last line reports the overall
results of our model. When reporting the statistic tests in the results
section, we tend to quote these values for the model. This test is
comparing our model line against a flat horizontal line at the mean body
mass. Simply put, does our latitude model explain more of the variance
in body mass than the mean. This is easiest to explain with a quick
example:

``` r
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
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-8-1.png
:align: center
:width: 600px
```

From the plots we can see that the blue linear model line passes closer
to all of our data points than simply using the mean line. The black
lines from our data points to the linear model are the residual
variation left over once we’ve accounted for x. This is often referred
to as the residuals.

The F statistic in our summary output is testing if there is a
siginificant difference between the residuals from using our mean line
against using our linear model instead. This is weighed up against the
number of degrees of freedom to calculate our p-value.

Degrees of freedom are often poorly known but are actually quite simple
to understand. They are calculated from the number of independent data
points in your model, minus the number of predictors. This is to prevent
models that over-fit the data. So models with lots of data points have
high degrees of freedom which means we need lower F statistic values to
be certain of our model. For models with few data points it depends on
the number of predictors. If there’s few predictors, like in our model,
that means that we can accept lower F statistics. We can be more
confident in our relationship if we used fewer predictors to describe
it. If we use lots of predictors, we can be less certain in our model,
because each predictor may explain some of the variation just by chance.
Therefore we need a higher F statistic. When you report your models,
report both the degrees of freedom and the F statistic alongside your
p-value for the whole model.

Now that we understand a bit more about our summary report, lets look at
it again to investigate the relationship between body mass and latitude.

``` r
# Get the summary of our model.
summary(duck_model)
```

    ## 
    ## Call:
    ## lm(formula = log_BM ~ abs_latitude, data = duck_data)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -1.3202 -0.5291 -0.0613  0.3249  2.1978 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  6.505760   0.124237  52.366  < 2e-16 ***
    ## abs_latitude 0.011639   0.002933   3.969 0.000112 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.725 on 150 degrees of freedom
    ## Multiple R-squared:  0.09503,    Adjusted R-squared:  0.089 
    ## F-statistic: 15.75 on 1 and 150 DF,  p-value: 0.0001117

We can see from our model that both the intercept and latitude are
significant predictors. That the intercept is significant isn’t very
interesting. It means at 0 latitude (the equator), body mass is
significantly different from zero. Seeing as it’s impossible to have a
species with zero body mass, this isn’t surprising! What’s more
interesting is latitude. We can see a significant p-value, so there is a
relationship between latitude and body mass. As the estimate is
positive, we can see that as latitude increases, so does body mass. For
every 1 degree of latitude, log(body mass) increases by 0.012,
supporting Bergmann’s rule. We can see that by plotting our model line
with our data.

``` r
# Plot our model.
plot(log_BM ~ abs_latitude, data = duck_data)
abline(duck_model)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-10-1.png
:align: center
:width: 600px
```

Of course, we can see that many data points don’t fit this line. If we
look at the adjusted R-squared, we can see that our model explains
roughly 9% of the variation in body size. Most macro-evolutionary
studies have low R-squared values, so this is quite high! We could
potentially increase this more by including other predictors which
influence body size. Have a think about what these predictors could be.

We can also see from the bottom line of output that our overall model is
significant. Because there is only one predictor (except the intercept),
this value will be the same as our p-value for body mass.

As we’ve ran a standard linear model, we should also check our residuals
to see if they are normally distributed. This is one of the assumptions
of parametric tests, and if not we might consider using a generalised
linear model instead.

``` r
# Plot a density curve of the residuals.
plot(density(duck_model$residuals))
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-11-1.png
:align: center
:width: 600px
```

Our residuals look pretty normally distributed. It’s often good enough
just to inspect these plots by eye, to check there’s no extreme left or
right skew to the distribution.

### 3. Phylogenetic generalised least squares models

Up until now we have been treating all our species as independent data
points. However, technically this isn’t true. Each species is related to
each other, and some are more closely related than others. We might
expect closely related species in the same genus to have a similar body
mass, compared to species from different genera. If true, it could mean
there are more large species at higher latitudes because they all shared
one common ancestor (who happened to be a large species). This would
suggest that the evolutionary history of ducks is responsible for the
patterns of body mass, rather than a true relationship between latitude
and body mass. Fortunately, we can test this using
phylogenetically-controlled linear models. One of the easiest to use is
a PGLS.

First let’s load up the packages we need and the phylogenetic tree of
ducks.

``` r
# Load phylogenetic packages.
library(ape)
library(caper)

# Read in the tree.
duck_tree <- read.tree("data/duck_tree.tre")
plot(duck_tree, cex=0.3)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-12-1.png
:align: center
:width: 600px
```

We now need to attach our body mass data and tree together, and we can
do this by creating a comparative data object from the `caper` package.

``` r
# We need to change the Jetz names so that they match the tip labels.
duck_data$jetz_name <- gsub(" ", "_", duck_data$jetz_name)

# We specify the phylogeny we need, the data, and which column has the tip label names in.
duck_comp <- comparative.data(phy = duck_tree, data = duck_data, names.col = "jetz_name")
```

We can inspect our comparative data object to check that it’s worked.

``` r
# Return the data.
head(duck_comp$data)
```

    ##                        latitude body_mass abs_latitude   log_BM
    ## Dendrocygna_arborea       19.66   1150.00        19.66 7.047517
    ## Dendrocygna_autumnalis    -5.68    755.30         5.68 6.627115
    ## Dendrocygna_arcuata       -7.97    796.18         7.97 6.679825
    ## Dendrocygna_javanica      18.86    519.61        18.86 6.253079
    ## Dendrocygna_eytoni       -21.27    789.99        21.27 6.672020
    ## Dendrocygna_guttata       -3.41    800.00         3.41 6.684612

``` r
# Plot the phylogeny.
plot(duck_comp$phy, cex=0.3)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-15-1.png
:align: center
:width: 600px
```

So we can see that our comparative object has worked as it should. Now
we can run a pgls to see if information on the phylogeny makes any
difference.

**Warning** If you’re using R studio Cloud, you’ll need an extra
argument: `bounds = list(lambda = c(0.05, 1))`. So it looks like this:

`duck_pgls <- pgls(log_BM ~ abs_latitude, data = duck_comp, lambda = "ML", bounds = list(lambda = c(0.05, 1)))`

This limits where the model searches for the lambda value, but won’t
change your result. It’s just a weird way cloud is set up, and doesn’t
happen for every pgls. For your coursework, try models without this
argument first.

``` r
# Run a PGLS model.
duck_pgls <- pgls(log_BM ~ abs_latitude, data = duck_comp, lambda = "ML")
```

The code for a pgls looks largely the same. The only difference is that
we have a third argument, which is the lambda value. The lambda value
tells us how randomly body mass and latitude are spread throughout the
tree. By saying `"ML"` we’ve asked the function to calculate lambda
using maximum likelihood methods, rather than give it an exact value.

Let’s take a look at the results of the pgls.

``` r
# You can see the summary the same way.
summary(duck_pgls)
```

    ## 
    ## Call:
    ## pgls(formula = log_BM ~ abs_latitude, data = duck_comp, lambda = "ML")
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.97464 -0.17081 -0.00968  0.11650  0.54058 
    ## 
    ## Branch length transformations:
    ## 
    ## kappa  [Fix]  : 1.000
    ## lambda [ ML]  : 0.983
    ##    lower bound : 0.000, p = < 2.22e-16
    ##    upper bound : 1.000, p = < 2.22e-16
    ##    95.0% CI   : (0.959, 0.993)
    ## delta  [Fix]  : 1.000
    ## 
    ## Coefficients:
    ##               Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  6.7827025  0.7205697  9.4130   <2e-16 ***
    ## abs_latitude 0.0026244  0.0019744  1.3292   0.1858    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.2301 on 150 degrees of freedom
    ## Multiple R-squared: 0.01164, Adjusted R-squared: 0.005052 
    ## F-statistic: 1.767 on 1 and 150 DF,  p-value: 0.1858

The output of the summary look largely the same as our linear model. The
key difference is we now have information on the branch length
transformations, which shows how our trait is influenced by phylogeny.
We can also see that our p-value for latitude is now much higher, and
above the 0.05 threshold. When we look at our estimate, we can see that
it’s a positive value, so the same relationship is there, but we can no
longer be confident enough to reject our null hypothesis. This is why
for macro-evolutionary studies, we always have to include information on
the phylogeny!

We should take a second to look at the lambda value. Ours is 0.98
according to the pgls summary. But what does it mean?

Lambda is scaled between 0 and 1, and it’s easiest to think of it as how
much our trait is bunched up in the tree. Values closer to zero suggest
that body mass would be spread randomly among the tree, and the
phylogeny does not matter. Values closer to one suggest that body mass
is organised strongly throughout the tree, with closer species having
more similar sizes.

For an excellent explanation of lambda values, check out this paper by
Natalie Cooper at the Natural History Museum, who helped write the
second practical on this course.

<https://royalsocietypublishing.org/doi/full/10.1098/rstb.2012.0341>

What the lambda value actually does is change the length of the branches
on the tree, to reflect how body mass is related between species. We can
visualise this by plotting trees with different lambda values.

``` r
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
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-18-1.png
:align: center
:width: 600px
```

What’s actually happening is the lambda value shortens all the internal
branches (everything except the tips). This reduces the difference
between species. In the last plot we can see a lambda value of zero, and
all the branches are equally close to the root, and therefore to each
other. This means that all our species are now independent points, and
if we ran a pgls we would get similar results to a linear model. Try it
out running a pgls with different lambda values and see what happens!

We can plot the profile of the lambda value from our pgls and see how we
came to this number.

``` r
# Change the plot margins to fit the plot in.
par(mar = c(7, 5, 5, 2))

# Get the potential values of lambda.
lambda_likelihood <- pgls.profile(duck_pgls, which = "lambda")

# Plot them.
plot(lambda_likelihood)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-19-1.png
:align: center
:width: 600px
```

On the horizontal axis we can see potential lambda values, and on the
vertical is how likely they are. Red lines show the 95% confidence
intervals. This shows that we are fairly confident in our lambda value.
It’s always worth plotting the our lambda profile, as a flatter line
would mean we’re less confident in our lambda, and might not have
controlled for our phylogeny properly. Also be wary of smaller
phylogenies, as the lambda value is harder to estimate. Try and pick a
group with more than 100 species for your coursework just to be safe.

Don’t worry if you struggled to understand any of this! Lambda values
can be tricky to get your head around. At this stage, it’s only
important to be aware that a pgls uses a lambda value to decide how much
to weight up the importance of the phylogeny.

For more information on using a pgls check out this very useful papers
that are aimed at beginners. In particular chapeter 6 which you find on
researchgate:

<http://www.mpcm-evolution.com/book-sections/part-introduction/5-primer-phylogenetic-generalised-least-squares>

<http://www.mpcm-evolution.com/book-sections/part-introduction/6-statistical-issues-assumptions-phylogenetic-generalised-least-squares>

<https://onlinelibrary.wiley.com/doi/full/10.1111/j.1420-9101.2009.01757.x>

### 4. Rapoport’s rule

For your coursework you might choose to investigate Rapoport’s rule:
does range size increase with latitude? To do this we’ll use a pgls like
the previous section. We’ll then use some of the mapping skills that we
learnt from Practical 1 to extract range size and latitude. For this
example we’ll use the family Accipitridae, which includes some birds of
prey.

#### Phylogenetic analysis

First we’ll load in our data. This is the same data from practical 1
from the AVONET database. The citation for this data is:

Tobias, J.A., Sheard, C., Pigot, A.L., Devenish, A.J.M., Yang, J.,
Sayol, F. et al. (2021) AVONET: morphological, ecological and
geographical data for all birds. Ecology Letters (in press).

``` r
# Read in the avonet data.
avonet_data <- read.csv("data/avonet_data.csv")
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

``` r
head(avonet_data)
```

    ##           birdlife_name    birdlife_common_name             jetz_name      jetz_order  jetz_family
    ## 1 Accipiter albogularis            Pied Goshawk Accipiter_albogularis Accipitriformes Accipitridae
    ## 2      Accipiter badius                  Shikra      Accipiter_badius Accipitriformes Accipitridae
    ## 3     Accipiter bicolor          Bicolored Hawk     Accipiter_bicolor Accipitriformes Accipitridae
    ## 4  Accipiter brachyurus New Britain Sparrowhawk  Accipiter_brachyurus Accipitriformes Accipitridae
    ## 5    Accipiter brevipes      Levant Sparrowhawk    Accipiter_brevipes Accipitriformes Accipitridae
    ## 6     Accipiter butleri     Nicobar Sparrowhawk     Accipiter_butleri Accipitriformes Accipitridae
    ##   redlist_cat beak_length_culmen beak_length_nares beak_width beak_depth tarsus_length wing_length
    ## 1          LC               27.7              17.8       10.6       14.7          62.0       235.2
    ## 2          LC               20.6              12.1        8.8       11.6          43.0       186.7
    ## 3          LC               25.0              13.7        8.6       12.7          58.1       229.6
    ## 4          VU               22.5              14.0        8.9       11.9          61.2       202.2
    ## 5          LC               21.1              12.1        8.7       11.1          46.4       217.6
    ## 6          VU               20.0              11.9        6.6       12.0          48.7       166.0
    ##   kipps_distance secondary1 hand_wing_index tail_length  mass habitat_density migration trophic_level
    ## 1           81.8      159.5            33.9       169.0 248.8               1         2     Carnivore
    ## 2           62.5      127.4            32.9       140.6 131.2               2         3     Carnivore
    ## 3           56.6      174.8            24.6       186.3 287.5               2         2     Carnivore
    ## 4           64.1      138.1            31.7       140.8 142.0               1         2     Carnivore
    ## 5           87.8      129.9            40.2       153.5 186.5               1         3     Carnivore
    ## 6           42.9      123.1            25.8       127.0 122.0               1         1     Carnivore
    ##   trophic_niche primary_lifestyle centroid_latitude centroid_longitude  range_size
    ## 1     Vertivore       Insessorial             -8.15             158.49    37461.21
    ## 2     Vertivore       Insessorial              8.23              44.98 22374973.00
    ## 3     Vertivore        Generalist            -10.10             -59.96 14309701.27
    ## 4     Vertivore       Insessorial             -5.45             150.68    35580.71
    ## 5     Vertivore        Generalist             45.24              45.33  2936751.80
    ## 6     Vertivore       Insessorial              8.42              93.17      327.84

So we can see the data is a near complete species list for the world’s
birds, with some information on morphological data, range data and IUCN
categories. We’ve included two different taxonomies, Birdlife and Jetz,
however we’ll just use Jetz which matches our phylogeny.

For more info on the tree, and where download your own in the future,
look here:

<http://birdtree.org/>

So we’ll first filter our traits based on the Jetz families.

``` r
# Load the dplyr package to use filter.
library(dplyr)

# Filter will subset our trait data based on the Jetz family column.
accip_data <- avonet_data %>% filter(jetz_family == "Accipitridae")
```

> Extra task: Can you use skills from Practical 2 and 3 to run a PGLS to
> detirmine if Rapoport’s rule is true in Accipitridae? You’ll need to
> read in the ‘all\_birds.tre’ and drop the tips for all the other
> species.

::::{admonition} Show the answer…  
:class: dropdown

``` r
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
```

    ## 
    ## Call:
    ## pgls(formula = range_size ~ abs_latitude, data = accip_comp, 
    ##     lambda = "ML")
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -3306385  -615255   -38880   532818  5382176 
    ## 
    ## Branch length transformations:
    ## 
    ## kappa  [Fix]  : 1.000
    ## lambda [ ML]  : 0.000
    ##    lower bound : 0.000, p = 1    
    ##    upper bound : 1.000, p = < 2.22e-16
    ##    95.0% CI   : (NA, 0.140)
    ## delta  [Fix]  : 1.000
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value  Pr(>|t|)    
    ## (Intercept)   4384350     654706  6.6967 1.556e-10 ***
    ## abs_latitude    71425      27595  2.5884   0.01024 *  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 995300 on 235 degrees of freedom
    ## Multiple R-squared: 0.02772, Adjusted R-squared: 0.02358 
    ## F-statistic:   6.7 on 1 and 235 DF,  p-value: 0.01024

So it looks like Rapoport’s rule is true for Accipitridae! But there are
some interesting values in the summary worth discussing. What does a
lambda value of zero mean? Try running a normal linear model to see if
there are any differences. We can also plot lambda again.

``` r
# Change the plot margins to fit the plot in.
par(mar = c(7, 5, 5, 2))

# Get the potential values of lambda.
lambda_likelihood <- pgls.profile(accip_pgls, which = "lambda")

# Plot them.
plot(lambda_likelihood)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-23-1.png
:align: center
:width: 600px
```

So the curve for lambda is flatter than for our Bergmann’s rule
analysis, but it’s still steep enough to be confident we’ve got the
right lambda value. If we wanted to be very sure, we could redo our pgls
with `lambda = 0.15` to check if it changes our result.

::::

#### Plotting range size

Now we need to load in our range data. For convenience we’ve saved the
range data as an `.Rdata` object, which `R` can load back into the
working environment. `.Rdata` objects can be extremely useful,
especially when you’ve ran a model that’s taken a long time, and wish to
save the result without converting it to a specific file format. The
maps for each family are available as a separate `R.data` file on
blackboard.

``` r
# First load in the spatial packages we'll need.
library(raster)
library(sf)


# Load the data into our environment.
load("data/accipitridae_ranges.RData")

# Inspect the maps.
class(accip_ranges)
head(accip_ranges)
```

    ## [1] "sf"         "data.frame"
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

As a reminder from practical 1, we can see that the range maps are
stored in a spatial dataframe, called and `sf` class of object. We can
plot the polygons again to see what they look like.

``` r
#  Take the range polygon from the first row.
plot(accip_ranges$Shape[1], axes=TRUE)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-25-1.png
:align: center
:width: 600px
```

We can then plot the range sizes to view them at a global scale. For
this practical we’ll split ranges in small and large, and highlight the
smaller ranges on the map. To do this we need to utilise a `for loop`
and an `if statement` to decide if each range size is bigger than
1,000,000 km<sup>2</sup>. This value works well for accipitridae with
large ranges, but for your own clade you may wish to choose a smaller
value to best show the data. There is no correct value, as it’s all
about data presentation.

We’ll now try using a `for loop` and `if statement`, and explain the
code in more detail below. Don’t worry if it seems complicated! Here’s a
cute example from [Allison
Horst](https://github.com/allisonhorst/stats-illustrations), who does
loads of cool stats illustrations to help understand bits of ecology and
coding.

```{image} ../../memes/monster_for_loop.png
:align: center
:width: 600px
```

``` r
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
```

IF functions have a logical expression inside the brackets. If it’s TRUE
it will run the line between the curly brackets. If it’s FALSE, it will
run what’s inside `else{}`.

```{tip}
You can also run each line of a loop one by one to better understand what's happening.
Just set `x <- 1` and then skip the for() line to see the other lines one at a time.
```

To plot the ranges we’re going to convert our sf dataframe of polygons
into a raster image, like we did in Practical 1. For `fasterize`, we’ll
ask the function to take the minimum value so that small ranges are on
top of big ones. certain values, such as range\_size.

``` r
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
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-29-1.png
:align: center
:width: 600px
```

So now we can see where all the small range sizes are relative to the
large ones. However, it doesn’t look very pretty and countries without
any ranges are left off the map. We can make a much clearer map using
`ggplot2`.

``` r
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
```

``` r
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
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-31-1.png
:align: center
:width: 600px
```

That looks much better than the first. Experiment with your own maps to
create a map for your report. Try changing how you show ranges, such as
what determines if a range is large or small, or anything else you can
think of! You can save your plots as a file using different formats like
a jpeg. Watch out for how the map transforms when it’s saved and edit
your plots accordingly.

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

### 5. Latitudinal diversity gradient

Another question you might pick for your coursework is to investigate
the latitudinal diversity gradient for your chosen taxa. We’ll explore
the same relationship with Accipitridae. We’ve already extracted
latitude but we for this model we will lump species into bins at 5
degree latitudes and see if some bins are bigger closer to the equator.

``` r
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
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-33-1.png
:align: center
:width: 600px
```

It definitely looks like a pattern is going on there! We can investigate
this using a model.

#### Generalised linear models

Because the data is count, it looks like it has a poisson distribution.
For this reason we might want to utilise a generalised linear model
instead. Also because we’ve binned species, we won’t use a pgls for this
question. First let’s generate species richness.

``` r
# Get the frequency of each bin
species_richness <- count(accip_data, lat.bins)
colnames(species_richness)[2] <- "richness"
species_richness
```

    ##    lat.bins richness
    ## 1         5       57
    ## 2        10       59
    ## 3        15       19
    ## 4        20       18
    ## 5        25       24
    ## 6        30       13
    ## 7        35        9
    ## 8        40        4
    ## 9        45       11
    ## 10       50        9
    ## 11       55        9
    ## 12       60        4
    ## 13       70        1

Now to run a glm, using a poisson error structure given our data is very
skewed.

``` r
# The only difference with running a glm is now we have to specify the family as well.
accip_model <- glm(richness ~ lat.bins, data = species_richness, family = "poisson")
summary(accip_model)
```

    ## 
    ## Call:
    ## glm(formula = richness ~ lat.bins, family = "poisson", data = species_richness)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -2.6681  -0.9765   0.2406   1.2114   2.3963  
    ## 
    ## Coefficients:
    ##              Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept)  4.245447   0.108752   39.04   <2e-16 ***
    ## lat.bins    -0.049699   0.004366  -11.38   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for poisson family taken to be 1)
    ## 
    ##     Null deviance: 194.745  on 12  degrees of freedom
    ## Residual deviance:  29.126  on 11  degrees of freedom
    ## AIC: 88.839
    ## 
    ## Number of Fisher Scoring iterations: 4

You should be able to figure out if there’s a relationship there! One
thing to remember about a glm is that we’ve applied a link function. For
a poisson model this is a log-link function. This means that the
relationship between our variables isn’t as simple as a 0.05 decrease in
species richness with 1 degree of latitude. A log-link function takes a
log of the entire right side of the model formula. For interpretation,
we first need to back-transform the equation and write out our model as:

```{math}
Richness \sim e^{(4.232\ -\ 0.049\ \times lat.bins)}
```

Because of the law of exponents, we can rearrange it to:

```{math}
Richness \sim \frac{e^{4.232}} {e^{0.049 \times lat.bins}}  
```

The top half of the fraction is the intercept, which simplifies to
approximately 69. This is the predicted species richness at the equator.
We’re more interested in the change with latitude so we can simplify the
bottom. We sub in `1` for `lat.bins` to know the change with every 1
degree. This gives us 1.05 on the bottom. Dividing by 1.05 is the same
as a decrease of 5%. Therefore, for every increase of 1 degree of
latitude, there is a 5% decrease in species richness (starting from the
equator at 69). We can see this relationship by plotting our model.

``` r
# We first plot raw values as just a scatter plot.
plot(richness ~ lat.bins, data = species_richness)

# And then add a line of the fitted values of the model.
lines(species_richness$lat.bins, accip_model$fitted.values)
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-38-1.png
:align: center
:width: 600px
```

Don’t worry if that seems confusing! It’s initially quite hard to
understand, but in the plot you can see that there’s roughly a 5%
decrease in species richness with every 1 degree latitude increase. For
most macro-ecological research we’re less concerned with predictions,
and more interested in determining if we can reject our null hypothesis.

> Extra task: Can you recreate this plot using your `ggplot2` skills?

::::{admonition} Show the answer…  
:class: dropdown

``` r
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
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

```{image} practical_3_files/figure-gfm/unnamed-chunk-39-1.png
:align: center
:width: 600px
```

Think how you could change the plot to make it nicer. Can you figure out
how to change the font sizes? Does adding more bins for latitude change
your model results, or make the plot nicer?

::::

#### Plotting species richness

Lastly, you might also want to plot a map of species richness to go
alongside your plot. This is the map we made in practical 1. We can make
the same map using a different colour scheme.

For this we just use the fasterize function again, but this time we
leave out the field arguement. This means fasterize will count every
range as 1, and will sum them where they overlap to get species
richness.

``` r
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
  scale_fill_gradientn(name = "Species Richness", colors = c("skyblue", "red")) +
  
  # You should be getting used to this code!
  ggtitle("Accipitridae Species Richness Heat Map") + 
  theme_classic() +
  ylab("Latitude") + 
  xlab("Longitude") + 
  coord_fixed()

# Return the plot so we can view it.
richness_plot
```

```{image} practical_3_files/figure-gfm/unnamed-chunk-40-1.png
:align: center
:width: 600px
```

Does this look nicer than the plot in practical 1? Figure presentation
is an important skill in ecology (and wider science), and will be useful
for your future projects no matter what the topic! It’s worth taking the
time now to play around with different colour schemes, and learn how to
edit figures using ggplot. I highly recommend checking out this page for
more information on how to effectively use colours, including links for
figure presentation in general.

<https://www.molecularecologist.com/2020/04/23/simple-tools-for-mastering-color-in-scientific-figures/>
