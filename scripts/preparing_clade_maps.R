##############################################################################
             #### Prepare clade maps for student coursework #####

# This code will loop through the bcb ranges and split them into 35 different
# clades that students can use. We have used clades that are over 100 species,
# but limited orders to a reasonable size so that map files were not excessively
# big. It's all saved as "clade_ranges" which can be read into R using load().


rm(list=ls())
getwd()
library(sf)
library(lwgeom)
library(sm) # Dunno if i need this one?
library(doParallel)
library(stringr)


# Load avonet data.
avonet_data <- read.csv("data/avonet_data.csv")

# Pull out families with over 100 species.
families <- avonet_data %>% count(jetz_family) %>% filter(n > 99) %>% pull(jetz_family)

# Additionally add some orders made up of small families.
small_orders <- c("Caprimulgiformes", "Coraciiformes", "Gruiformes",
"Pelecaniformes", "Piciformes", "Procellariiformes")

# Combine them.
clades <- c(families, small_orders)

# Load in the Jetz data.
load("ranges/bcb_range_data.RData")

# Loop through clades and save.
for (clade in clades){

  # Pull out species list.
  map_species <- avonet_data %>%
    filter(jetz_family == clade | jetz_order == clade) %>%
    pull(jetz_name) %>% str_replace("_", " ")

  # Pull out range data.
  clade_ranges <- subset(bcb_range_data, bcb_range_data$SCINAME %in% map_species)

  # File pathway.
  pathway <- paste("ranges/", clade, "_range_data.RData", sep="")

  # Save output.
  save(clade_ranges, file = pathway)
}




