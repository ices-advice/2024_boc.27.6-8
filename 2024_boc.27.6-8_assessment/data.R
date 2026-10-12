#WGWIDE 2024 Boarfish
##Preprocess data, write TAF data tables

library(icesTAF)

icesTAF::mkdir("data")

# read input files
inputs <- r4ss::SS_read(dir = "boot/data", verbose = TRUE)
