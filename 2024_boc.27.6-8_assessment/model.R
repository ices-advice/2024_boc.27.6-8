#Boarfish WGWIDE 2024
#model script

library(icesTAF)

icesTAF::mkdir("model")

# Run script for stock assessment -----------------------------------------
source("model_run.R")

# STF
source("STF.R")
