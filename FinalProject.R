# install -- Only do once!
#install.packages('R.utils')
#install.packages("BiocManager")
#BiocManager::install("rhdf5")
#install.packages("neonUtilities")

# Libraries
library(data.table)
library("rhdf5")
library(neonUtilities)
library(stringr)

# set working directory
setwd("Z:/students/ggrossman/")


# saving file paths
f <- "Z:/GEOG331_S22/students/ggrossman/data/NEON_eddy-flux/NEON.D03.DSNY.DP4.00200.001.2017-03.basic.20220120T173946Z.RELEASE-2022/NEON.D03.DSNY.DP4.00200.001.nsae.2017-03.basic.20211220T152138Z.h5/NEON.D03.DSNY.DP4.00200.001.nsae.2017-03.basic.20211220T152138Z.h5"
fileUrl <- "Z:/students/ggrossman/data/NEON_eddy-flux/NEON.D05.UNDE.DP4.00200.001.2021-04.basic.20220120T173946Z.RELEASE-2022/NEON.D05.UNDE.DP4.00200.001.nsae.2021-04.basic.20211221T022406Z.h5"
fileUrl2 <- "Z:/students/ggrossman/data/NEON_eddy-flux/NEON.D03.DSNY.DP4.00200.001.2020-07.basic.20220120T173946Z.RELEASE-2022/NEON.D03.DSNY.DP4.00200.001.nsae.2020-07.basic.20211220T175101Z.h5"

# unzip files
filepaths <- list.files(path = "data/NEON_eddy-flux/", pattern = ".gz", full.names = T, recursive = T)
folderpaths <- list.dirs(path = "data/NEON_eddy-flux/")

outfile <- list.files(path = "data/NEON_eddy-flux/", pattern = ".gz", full.names = F, recursive = T)
outfile <- str_replace(outfile, ".gz", "")

i <- 1
while(i < length(outfile)+1){
  R.utils::gunzip(filepaths[i], paste("data/unzipped_eddy_flux/", outfile[i]), ext=".gz", remove = FALSE)
  i <- i+1
}




# load all data into variable
eddy_data <- stackEddy(filepath = "data/test_eddy/",
                  level = "dp04")

DSNY_eddy_data <- stackEddy(filepath = "data/DSNY/",
                         level = "dp04")

UNDE_eddy_data <- stackEddy(filepath = "data/UNDE/",
                            level = "dp04")

STER_eddy_data <- stackEddy(filepath = "data/STER/",
                            level = "dp04")

ABBY_eddy_data <- stackEddy(filepath = "data/ABBY/",
                            level = "dp04")



# plot DSNY nsae eddy data
# plot DSNY co2 nsae fluxes 
plot(DSNY_eddy_data$DSNY$data.fluxCo2.nsae.flux ~ DSNY_eddy_data$DSNY$timeBgn, 
     type="l", pch=".", xlab="Time", ylab="CO2 flux")

# plot UNDE co2 nsae fluxes
plot(UNDE_eddy_data$UNDE$data.fluxCo2.nsae.flux ~ UNDE_eddy_data$UNDE$timeBgn, 
     type="l", pch=".", xlab="Time", ylab="CO2 flux", # xlim = c(UNDE_eddy_data$UNDE$timeBgn[20000], UNDE_eddy_data$UNDE$timeBgn[40000]),
     ylim = c(-100, 100))




fluxFrame <- data.frame(fluxDSNY = DSNY_eddy_data$DSNY$data.fluxCo2.nsae.flux)
fluxFrame$fluxUNDE <- UNDE_eddy_data$UNDE$data.fluxCo2.nsae.flux

# populate data frame with dp04 files NOT WORKING YET
i <- 2
while(i < length(outfile)+1){
    tempFlux <- stackEddy(filepath = unzippedFilePaths[i],
                          level = "dp04")
    fluxFrame$FILENAME = tempFlux
  i <- i + 1
}























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