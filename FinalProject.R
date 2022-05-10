# install -- Only do once!
#install.packages('R.utils')
#install.packages("BiocManager")
#install.packages("DescTools")
#install.packages("neonUtilities")
#install.packages("imputeTS")
#BiocManager::install("rhdf5")

# Libraries
library(data.table)
library("rhdf5")
library(neonUtilities)
library(stringr)
library(DescTools)
library(imputeTS)
library(devtools)

# set working directory
setwd("Z:/students/ggrossman/")

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

# load all data into separate variable
DSNY_eddy_data <- stackEddy(filepath = "data/DSNY/",
                         level = "dp04")

UNDE_eddy_data <- stackEddy(filepath = "data/UNDE/",
                            level = "dp04")

STER_eddy_data <- stackEddy(filepath = "data/STER/",
                            level = "dp04")

ABBY_eddy_data <- stackEddy(filepath = "data/ABBY/",
                            level = "dp04")

# plot eddy nsae graphs for all locations
plot(DSNY_eddy_data$DSNY$data.fluxCo2.nsae.flux ~ DSNY_eddy_data$DSNY$timeBgn, 
     type="l", pch=".", xlab="Time", ylab="CO2 flux", #xlim = c(UNDE_eddy_data$UNDE$timeBgn[20000], UNDE_eddy_data$UNDE$timeBgn[40000]),
     ylim = c(-100, 100))

# plot UNDE co2 nsae fluxes
plot(UNDE_eddy_data$UNDE$data.fluxCo2.nsae.flux ~ UNDE_eddy_data$UNDE$timeBgn, 
     type="l", pch=".", xlab="Time", ylab="CO2 flux", #xlim = c(UNDE_eddy_data$UNDE$timeBgn[20000], UNDE_eddy_data$UNDE$timeBgn[40000]),
     ylim = c(-100, 100))

# plot STER co2 nsae flux
plot(STER_eddy_data$STER$data.fluxCo2.nsae.flux ~ STER_eddy_data$STER$timeBgn, 
     type="l", pch=".", xlab="Time", ylab="CO2 flux", #xlim = c(UNDE_eddy_data$UNDE$timeBgn[20000], UNDE_eddy_data$UNDE$timeBgn[40000]),
     ylim = c(-100, 100))

# plot ABBY co2 nsae flux
plot(ABBY_eddy_data$ABBY$data.fluxCo2.nsae.flux ~ ABBY_eddy_data$ABBY$timeBgn, 
     type="l", pch=".", xlab="Time", ylab="CO2 flux", #xlim = c(UNDE_eddy_data$UNDE$timeBgn[20000], UNDE_eddy_data$UNDE$timeBgn[40000]),
     ylim = c(-100, 100))

# save co2 nsae data into new variables to avoid overwriting them
DSNY_NSAE_limited <- DSNY_eddy_data$DSNY$data.fluxCo2.nsae.flux
UNDE_NSAE_limited <- UNDE_eddy_data$UNDE$data.fluxCo2.nsae.flux
STER_NSAE_limited <- STER_eddy_data$STER$data.fluxCo2.nsae.flux
ABBY_NSAE_limited <- ABBY_eddy_data$ABBY$data.fluxCo2.nsae.flux

# remove all incorrect DSNY readings by implementing a limit
for(i in 1:length(DSNY_NSAE_limited)){
  if(is.na(DSNY_NSAE_limited[i]) == FALSE){
    if(DSNY_NSAE_limited[i] > 50 | DSNY_NSAE_limited[i] < -50){
      DSNY_NSAE_limited[i] <- NA
    }
  }
}

#interpolate the DSNY NA values
DSNY_interpolations <- na_interpolation(DSNY_NSAE_limited, option = "spline")

#add all interpolated values into limited co2 nsae data
iterator <- 1
for(i in 1:length(DSNY_NSAE_limited)){
  if(is.na(DSNY_NSAE_limited[i]) == TRUE){
    DSNY_NSAE_limited[i] <- DSNY_interpolations[iterator]
  }
}

# remove all incorrect UNDE readings by implementing a limit
for(i in 1:length(UNDE_NSAE_limited)){
  if(is.na(UNDE_NSAE_limited[i]) == FALSE){
    if(UNDE_NSAE_limited[i] > 50 | UNDE_NSAE_limited[i] < -50){
      UNDE_NSAE_limited[i] <- NA
    }
  }
}

#interpolate the UNDE NA values
UNDE_interpolations <- na_interpolation(UNDE_NSAE_limited, option = "spline")

#add all interpolated values into limited co2 nsae data
iterator <- 1
for(i in 1:length(UNDE_NSAE_limited)){
  if(is.na(UNDE_NSAE_limited[i]) == TRUE){
    UNDE_NSAE_limited[i] <- UNDE_interpolations[iterator]
  }
}

# remove all incorrect STER readings by implementing a limit
for(i in 1:length(STER_NSAE_limited)){
  if(is.na(STER_NSAE_limited[i]) == FALSE){
    if(STER_NSAE_limited[i] > 50 | STER_NSAE_limited[i] < -50){
      STER_NSAE_limited[i] <- NA
    }
  }
}

#interpolate the STER NA values
STER_interpolations <- na_interpolation(STER_NSAE_limited, option = "spline")

#add all interpolated values into limited co2 nsae data
iterator <- 1
for(i in 1:length(STER_NSAE_limited)){
  if(is.na(STER_NSAE_limited[i]) == TRUE){
    STER_NSAE_limited[i] <- STER_interpolations[iterator]
  }
}

# ABBY
for(i in 1:length(ABBY_NSAE_limited)){
  if(is.na(ABBY_NSAE_limited[i]) == FALSE){
    if(ABBY_NSAE_limited[i] > 50 | ABBY_NSAE_limited[i] < -50){
      ABBY_NSAE_limited[i] <- NA
    }
  }
}

#interpolate the UNDE NA values
ABBY_interpolations <- na_interpolation(ABBY_NSAE_limited, option = "spline")

#add all interpolated values into limited co2 nsae data
iterator <- 1
for(i in 1:length(ABBY_NSAE_limited)){
  if(is.na(ABBY_NSAE_limited[i]) == TRUE){
    ABBY_NSAE_limited[i] <- ABBY_interpolations[iterator]
  }
}

# plot entire timeline of graphs
plot(DSNY_NSAE_limited ~ DSNY_eddy_data$DSNY$timeBgn, 
     type="l", pch=".", xlab="Time", ylab="CO2 flux")

plot(UNDE_NSAE_limited ~ UNDE_eddy_data$UNDE$timeBgn, 
     type="l", pch=".", xlab="Time", ylab="CO2 flux")

plot(STER_NSAE_limited ~ STER_eddy_data$STER$timeBgn, 
     type="l", pch=".", xlab="Time", ylab="CO2 flux")

plot(ABBY_NSAE_limited ~ ABBY_eddy_data$ABBY$timeBgn, 
     type="l", pch=".", xlab="Time", ylab="CO2 flux")


# for loop to create DSNY seasonal graphs
par(mfrow = c(2,2))
DSNY_seasonal_plot_indexes <- c(921,5377,9793,14161,18481,22897,27313,31681,36001,40417,44833,
                                49201,53569,57985,62401,66769,71089,75505,79921,84289, 87648)
seasons <- c("Spring", "Summer", "Fall", "Winter")
season <- 1
year <- 2017
for(i in 1:21) {
  plot(DSNY_NSAE_limited ~ DSNY_eddy_data$DSNY$timeBgn, 
       type="l", pch=".", xlab="Time", ylab="CO2 flux",
       xlim = c(DSNY_eddy_data$DSNY$timeBgn[DSNY_seasonal_plot_indexes[i]], 
                DSNY_eddy_data$DSNY$timeBgn[DSNY_seasonal_plot_indexes[i+1]]),
       main=seasons[season])
  mtext(paste("DSNY CO2 nsae flux", year, collapse = NULL), side = 3, line = -16, outer = TRUE)
  if(season != 4){
    season <- season + 1
  } else {
    season <- 1
    year <- year + 1
  }
}

#graph generation below

# for loop to create UNDE seasonal graphs
par(mfrow = c(2,2))
UNDE_seasonal_plot_indexes <- c(2305,6721,11137,15505,19825,24241,28657,33025,37345,41761,46117,
                                50545,54913,59329,63745,68113,72433,76849,81265,85633,88922)
seasons <- c("Spring", "Summer", "Fall", "Winter")
season <- 1
year <- 2017
for(i in 1:21) {
  plot(UNDE_NSAE_limited ~ UNDE_eddy_data$UNDE$timeBgn, 
       type="l", pch=".", xlab="Time", ylab="CO2 flux",
       xlim = c(UNDE_eddy_data$UNDE$timeBgn[UNDE_seasonal_plot_indexes[i]], 
                UNDE_eddy_data$UNDE$timeBgn[UNDE_seasonal_plot_indexes[i+1]]),
       main=seasons[season])
  mtext(paste("UNDE CO2 nsae flux", year, collapse = NULL), side = 3, line = -16, outer = TRUE)
  if(season != 4){
    season <- season + 1
  } else {
    season <- 1
    year <- year + 1
  }
}

# for loop to create UNDE seasonal graphs
par(mfrow = c(2,2))
UNDE_seasonal_plot_indexes <- c(2305,6721,11137,15505,19825,24241,28657,33025,37345,41761,46117,
                                50545,54913,59329,63745,68113,72433,76849,81265,85633,88922)
seasons <- c("Spring", "Summer", "Fall", "Winter")
season <- 1
year <- 2017
for(i in 1:21) {
  plot(UNDE_NSAE_limited ~ UNDE_eddy_data$UNDE$timeBgn, 
       type="l", pch=".", xlab="Time", ylab="CO2 flux",
       xlim = c(UNDE_eddy_data$UNDE$timeBgn[UNDE_seasonal_plot_indexes[i]], 
                UNDE_eddy_data$UNDE$timeBgn[UNDE_seasonal_plot_indexes[i+1]]),
       main=seasons[season])
  mtext(paste("UNDE CO2 nsae flux", year, collapse = NULL), side = 3, line = -16, outer = TRUE)
  if(season != 4){
    season <- season + 1
  } else {
    season <- 1
    year <- year + 1
  }
}

# for loop to create STER seasonal graphs
par(mfrow = c(2,2))
STER_seasonal_plot_indexes <- c(NA,1,3937,8305,12625,17041,21457,25825,30145,34561,38977,43345,47713,
                                52129,56545,60913,65233,69649,74065,78433,81792)
seasons <- c("Spring", "Summer", "Fall", "Winter")
season <- 1
year <- 2017
for(i in 1:21) {
  if(i == 1){
    plot()
  }
  plot(STER_NSAE_limited ~ STER_eddy_data$STER$timeBgn, 
       type="l", pch=".", xlab="Time", ylab="CO2 flux",
       xlim = c(STER_eddy_data$STER$timeBgn[STER_seasonal_plot_indexes[i]], 
                STER_eddy_data$STER$timeBgn[STER_seasonal_plot_indexes[i+1]]),
       main=seasons[season])
  mtext(paste("STER CO2 nsae flux", year, collapse = NULL), side = 3, line = -16, outer = TRUE)
  if(season != 4){
    season <- season + 1
  } else {
    season <- 1
    year <- year + 1
  }
}

fluxFrame <- data.frame(fluxTime = STER_eddy_data$STER$timeBgn)








# individual seasons graphs
plot(DSNY_NSAE_limited ~ DSNY_eddy_data$DSNY$timeBgn, 
     type="l", pch=".", xlab="Time", ylab="CO2 flux", 
     xlim = c(DSNY_eddy_data$DSNY$timeBgn[53569], DSNY_eddy_data$DSNY$timeBgn[57985]))

# calculate area under a DSNY plot
DSNY_AUC <- AUC(DSNY_NSAE_limited, DSNY_eddy_data$DSNY$timeBgn, na.rm = T)




