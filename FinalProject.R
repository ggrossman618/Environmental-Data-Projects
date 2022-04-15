# install -- Only do once!
#install.packages('R.utils')
#install.packages("BiocManager")
BiocManager::install("rhdf5")
install.packages("BiocManager")

# Libraries
library(data.table)
library("rhdf5")

# set working directory
setwd("Z:/students/ggrossman/")

# File URL
fileUrl <- "Z:/students/ggrossman/data/NEON_eddy-flux/NEON.D03.DSNY.DP4.00200.001.2017-03.basic.20220120T173946Z.RELEASE-2022/NEON.D03.DSNY.DP4.00200.001.nsae.2017-03.basic.20211220T152138Z.h5/NEON.D03.DSNY.DP4.00200.001.nsae.2017-03.basic.20211220T152138Z.h5"

# Unzip .gz file
gunzip(fileUrl)

# read in data
h5readAttributes(file = fileURL,
                 name = "DSNY/dp01/data")


# view package contents
h5ls(fileURL)

test <- h5read(fileUrl, "DSNY/dp01/data/fluxHeatSoil/001_501_01m/fluxHeatSoil")

# test for file access
file.access(fileUrl, mode = 4)
