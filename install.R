###############################################################################
           #### Script for installing BCB R packages ####


# This script installs all the packages used in the BCB practicals. Each line
# can be run individually, or alternatively the entire script can be sourced.
# Issues may arise when installing spatial packages on mac computers, due to the
# dependencies which are absent (and pre-installed on windows). Installing ggtree
# can also create errors, so please ask for help if you get stuck.

# Data packages
install.packages("stringr")
install.packages("dplyr")
install.packages("tidyr")

# Spatial packages.
install.packages("raster")
install.packages("sf")
install.packages("fasterize")

# Phylogenetic packages.
install.packages("ape")
install.packages("caper")
install.packages("phytools")
install.packages("geiger")

install.packages("BiocManager")
BiocManager::install("ggtree")
BiocManager::install("ggtreeExtra")
