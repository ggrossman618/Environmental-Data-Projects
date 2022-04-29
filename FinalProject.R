# install -- Only do once!
#install.packages('R.utils')
#install.packages("BiocManager")
#BiocManager::install("rhdf5")
#install.packages("neonUtilities")

# Libraries
library(data.table)
library("rhdf5")
library(neonUtilities)

# set working directory
setwd("Z:/students/ggrossman/")


# saving file paths
f <- "Z:/GEOG331_S22/students/ggrossman/data/NEON_eddy-flux/NEON.D03.DSNY.DP4.00200.001.2017-03.basic.20220120T173946Z.RELEASE-2022/NEON.D03.DSNY.DP4.00200.001.nsae.2017-03.basic.20211220T152138Z.h5/NEON.D03.DSNY.DP4.00200.001.nsae.2017-03.basic.20211220T152138Z.h5"
fileUrl <- "Z:/students/ggrossman/data/NEON_eddy-flux/NEON.D05.UNDE.DP4.00200.001.2021-04.basic.20220120T173946Z.RELEASE-2022/NEON.D05.UNDE.DP4.00200.001.nsae.2021-04.basic.20211221T022406Z.h5.gz"
fileUrl2 <- "Z:/students/ggrossman/data/NEON_eddy-flux/NEON.D03.DSNY.DP4.00200.001.2020-07.basic.20220120T173946Z.RELEASE-2022/NEON.D03.DSNY.DP4.00200.001.nsae.2020-07.basic.20211220T175101Z.h5"

# unzip files
filepaths <- list.files(path = "data/NEON_eddy-flux/", pattern = ".gz", full.names = T, recursive = T)
folderpaths <- list.dirs(path = "data/NEON_eddy-flux/")

R.utils::gunzip(filepaths[1], "data/unzipped_eddy_flux/", remove = FALSE)


for(i in filepaths){
  unzipfileparallel(i, correctPath)
}

# Create overall data frame
overallFrame <- data.frame()

# Read in data to flux variable
# MARCH 2017
flux1 <- stackEddy(filepath = fileUrl,
                  level = "dp04")
# JULY 2020
flux2 <- stackEddy(filepath = fileUrl2,
                  level = "dp04")

# Plot Graph
plot(flux2$DSNY$data.fluxCo2.nsae.flux ~ flux2$DSNY$timeBgn, 
     type="l", pch=".", xlab="Time", ylab="CO2 flux")

#create vectors to go into data frame
allCo2FluxNsae <- flux2$DSNY$data.fluxCo2.nsae.flux
append(allCo2FluxNsae, flux1$DSNY$data.fluxCo2.nsae.flux)

allTimes <- flux2$DSNY$timeBgn
append(allTimes, flux1$DSNY$timeBgn)

# plot all co2 nsae fluxes in co2 flux nsae vector with all times in time vector
plot(allCo2FluxNsae ~ allTime, 
     type="l", pch=".", xlab="Time", ylab="CO2 flux")

# add elements to overall vector























# list.files will list everything in working directory, recursive = true, simple pattern matching, fullpath = true gives full path
# for loop to unzip all files, list all hdf5 files, write another loop to read NSAE variables and length of it 

# Unzip .gz file
gunzip(fileUrl)

# read in data
h5readAttributes(file = fileURL,
                 name = "DSNY/dp01/data")
