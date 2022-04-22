# install -- Only do once!
#install.packages('R.utils')
#install.packages("BiocManager")
BiocManager::install("rhdf5")
install.packages("neonUtilities")

# Libraries
library(data.table)
library("rhdf5")
library(neonUtilities)

# set working directory
setwd("Z:/students/ggrossman/")


f <- "Z:/GEOG331_S22/students/ggrossman/data/NEON_eddy-flux/NEON.D03.DSNY.DP4.00200.001.2017-03.basic.20220120T173946Z.RELEASE-2022/NEON.D03.DSNY.DP4.00200.001.nsae.2017-03.basic.20211220T152138Z.h5/NEON.D03.DSNY.DP4.00200.001.nsae.2017-03.basic.20211220T152138Z.h5"

# File URL
fileUrl <- "Z:/students/ggrossman/data/NEON_eddy-flux/NEON.D03.DSNY.DP4.00200.001.2017-03.basic.20220120T173946Z.RELEASE-2022/NEON.D03.DSNY.DP4.00200.001.nsae.2017-03.basic.20211220T152138Z.h5/NEON.D03.DSNY.DP4.00200.001.nsae.2017-03.basic.20211220T152138Z.h5"

fileUrl2 <- "Z:/students/ggrossman/data/NEON_eddy-flux/NEON.D03.DSNY.DP4.00200.001.2020-07.basic.20220120T173946Z.RELEASE-2022/NEON.D03.DSNY.DP4.00200.001.nsae.2020-07.basic.20211220T175101Z.h5"
  


# Read in data to flux variable
flux <- stackEddy(filepath = fileUrl,
                  level = "dp04")

# Read in data 2 to flux variable
flux2 <- stackEddy(filepath = fileUrl2,
                  level = "dp04")

# Plot Graph
plot(flux2$DSNY$data.fluxCo2.nsae.flux ~flux$DSNY$timeBgn, 
     type="l", pch=".", xlab="Time", ylab="CO2 flux")


# list.files will list everything in working directory, recursive = true, simple pattern matching, fullpath = true gives full path

# for loop to unzip all files, list all hdf5 files, write another loop to read NSAE variables and length of it 

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
