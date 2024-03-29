
# **********
# Original Authors: Gabriel L. Grossman & John J. Slater
# Created: May 11, 2022
# Purpose: This R script identifies the correlation between temperature and co2 flux standard
#          deviation by utilizing weather and co2 flux data collected at four NEON sites: DSNY, 
#          UNDE, STER, and ABBY.
# **********


# install -- Only do once!
# install.packages('R.utils')
# install.packages("BiocManager")
# install.packages("DescTools")
# install.packages("neonUtilities")
# install.packages("imputeTS")
# BiocManager::install("rhdf5")

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

# run a loop which unzips every h5 file and puts the unzipped file in data/unzipped_eddy_flux/ folder
i <- 1
while(i < length(outfile)+1){
  R.utils::gunzip(filepaths[i], paste("data/unzipped_eddy_flux/", outfile[i]), ext=".gz", remove = FALSE)
  i <- i+1
}

# load all c02 flux data into separate variables per site
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

# save co2 nsae data into new variables to avoid overwriting them while modifying them
DSNY_NSAE_limited <- DSNY_eddy_data$DSNY$data.fluxCo2.nsae.flux
UNDE_NSAE_limited <- UNDE_eddy_data$UNDE$data.fluxCo2.nsae.flux
STER_NSAE_limited <- STER_eddy_data$STER$data.fluxCo2.nsae.flux
ABBY_NSAE_limited <- ABBY_eddy_data$ABBY$data.fluxCo2.nsae.flux

# remove all incorrect DSNY readings by implementing a limit of 50>x>-50
for(i in 1:length(DSNY_NSAE_limited)){ #run for loop over all c02 flux readings at DSNY
  if(is.na(DSNY_NSAE_limited[i]) == FALSE){ # if data point isn't NULL
    if(DSNY_NSAE_limited[i] > 50 | DSNY_NSAE_limited[i] < -50){ # if the data point is above or below limit
      DSNY_NSAE_limited[i] <- NA # set point to NA, as there was an incorrect reading
    }
  }
}

#interpolate the DSNY NA values by using spline function 
DSNY_interpolations <- na_interpolation(DSNY_NSAE_limited, option = "spline")

#add all interpolated values into filtered co2 nsae data
iterator <- 1 # iterator for keeping track of location in DNSY_interpolations
DSNY_added_interp_locs <- c() # vector which keeps track of locations of past NA values, will use later
for(i in 1:length(DSNY_NSAE_limited)){ #iterate through filtered DSNY co2 flux values
  if(is.na(DSNY_NSAE_limited[i]) == TRUE){ # check if current value is NA, if true...
    DSNY_NSAE_limited[i] <- DSNY_interpolations[iterator] #set value to calculated interpolated value 
    DSNY_added_interp_locs <- append(DSNY_added_interp_locs, i) #add location to locs vector
  }
}

# remove all incorrect UNDE readings by implementing a limit, same pattern as DSNY
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
UNDE_added_interp_locs <- c()
for(i in 1:length(UNDE_NSAE_limited)){
  if(is.na(UNDE_NSAE_limited[i]) == TRUE){
    UNDE_NSAE_limited[i] <- UNDE_interpolations[iterator]
    UNDE_added_interp_locs <- append(UNDE_added_interp_locs, i)
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
STER_added_interp_locs <- c()
for(i in 1:length(STER_NSAE_limited)){
  if(is.na(STER_NSAE_limited[i]) == TRUE){
    STER_NSAE_limited[i] <- STER_interpolations[iterator]
    STER_added_interp_locs <- append(STER_added_interp_locs, i)
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
ABBY_added_interp_locs <- c()
for(i in 1:length(ABBY_NSAE_limited)){
  if(is.na(ABBY_NSAE_limited[i]) == TRUE){
    ABBY_NSAE_limited[i] <- ABBY_interpolations[iterator]
    ABBY_added_interp_locs <- append(ABBY_added_interp_locs, i)
  }
}

# plot entire timeline of graphs with filtered values and interpolations
plot(DSNY_NSAE_limited ~ DSNY_eddy_data$DSNY$timeBgn, 
     type="l", pch=".", xlab="Time", ylab="CO2 flux")

plot(UNDE_NSAE_limited ~ UNDE_eddy_data$UNDE$timeBgn, 
     type="l", pch=".", xlab="Time", ylab="CO2 flux")

plot(STER_NSAE_limited ~ STER_eddy_data$STER$timeBgn, 
     type="l", pch=".", xlab="Time", ylab="CO2 flux")

plot(ABBY_NSAE_limited ~ ABBY_eddy_data$ABBY$timeBgn, 
     type="l", pch=".", xlab="Time", ylab="CO2 flux")


# graph generation below

# for loop to create DSNY seasonal graphs
par(mfrow = c(2,2)) # set layout to view 2x2 graphs, can see entire year of site readings
# below are the indexes of when each month starts and ends in the DSNY vector
DSNY_seasonal_plot_indexes <- c(921,5377,9793,14161,18481,22897,27313,31681,36001,40417,44833,
                                49201,53569,57985,62401,66769,71089,75505,79921,84289, 87648)
seasons <- c("Spring", "Summer", "Fall", "Winter") # storing vector of seasons to iterate through
season <- 1 # keeps track of current season
year <- 2017 # keeps track of current year
for(i in 1:21) { #Loop through every season of DSNY readings
  plot(DSNY_NSAE_limited ~ DSNY_eddy_data$DSNY$timeBgn, #plotting co2 flux against time seasonally
       type="l", pch=".", xlab="Time", ylab="CO2 flux",
       xlim = c(DSNY_eddy_data$DSNY$timeBgn[DSNY_seasonal_plot_indexes[i]], #limiting by season using indexes stored above
                DSNY_eddy_data$DSNY$timeBgn[DSNY_seasonal_plot_indexes[i+1]]),
       main=seasons[season])
  mtext(paste("DSNY CO2 nsae flux", year, collapse = NULL), side = 3, line = -16, outer = TRUE)
  if(season != 4){ # logic to cycle through season and iterate year
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
    plot.new()
  } else {
    plot(STER_NSAE_limited ~ STER_eddy_data$STER$timeBgn, 
         type="l", pch=".", xlab="Time", ylab="CO2 flux",
         xlim = c(STER_eddy_data$STER$timeBgn[STER_seasonal_plot_indexes[i]], 
                  STER_eddy_data$STER$timeBgn[STER_seasonal_plot_indexes[i+1]]),
         main=seasons[season])
  }
  mtext(paste("STER CO2 nsae flux", year, collapse = NULL), side = 3, line = -16, outer = TRUE)
  if(season != 4){
    season <- season + 1
  } else {
    season <- 1
    year <- year + 1
  }
}

# for loop to create ABBY seasonal graphs
par(mfrow = c(2,2))
ABBY_seasonal_plot_indexes <- c(NA,1,2449,6817,11137,15553,19969,24337,28657,33073,37489,41857,46225,
                                50641,55057,59425,63745,68161,72577,76949,80304)
seasons <- c("Spring", "Summer", "Fall", "Winter")
season <- 1
year <- 2017
for(i in 1:21) {
  if(i == 1){
    plot.new()
  } else {
    plot(ABBY_NSAE_limited ~ ABBY_eddy_data$ABBY$timeBgn, 
         type="l", pch=".", xlab="Time", ylab="CO2 flux",
         xlim = c(ABBY_eddy_data$ABBY$timeBgn[ABBY_seasonal_plot_indexes[i]], 
                  ABBY_eddy_data$ABBY$timeBgn[ABBY_seasonal_plot_indexes[i+1]]),
         main=seasons[season])
  }
  mtext(paste("ABBY CO2 nsae flux", year, collapse = NULL), side = 3, line = -16, outer = TRUE)
  if(season != 4){
    season <- season + 1
  } else {
    season <- 1
    year <- year + 1
  }
}


# find standard deviations of all seasons for all test sites
DSNY_seasonal_sts <- c()
UNDE_seasonal_sts <- c()
STER_seasonal_sts <- c()
ABBY_seasonal_sts <- c()


#  filtering out seasons with too many NA values, and calculating standard deviations for DSNY
for(i in 1:20){
  na_count <- 0 # keeps track of number of NAs in seasonal readings
  for(j in DSNY_seasonal_plot_indexes[i]:DSNY_seasonal_plot_indexes[i+1]){ #iterate through seasonal readings
    if(j%in%DSNY_added_interp_locs){ # if location j is in the vector of past NA values... 
      na_count <- na_count + 1 #increase NA count by 1
    }
  }
  
  print(paste("NA vals: ", na_count, "total measurements: ", 
              (DSNY_seasonal_plot_indexes[i+1]-DSNY_seasonal_plot_indexes[i])))
  
  # if less than half of the measurements taken are NA values
  if(na_count <= (DSNY_seasonal_plot_indexes[i+1]-DSNY_seasonal_plot_indexes[i])*.5){
    # find and store standard deviation of the month in vector DSNY_seasonal_sts
    temp_DSNY_sd <- sd(DSNY_NSAE_limited[DSNY_seasonal_plot_indexes[i]:DSNY_seasonal_plot_indexes[i+1]])
    DSNY_seasonal_sts <- append(DSNY_seasonal_sts, temp_DSNY_sd)
  } else { # if over half of the measurements taken are NA, set standard deviation of month to NA
    DSNY_seasonal_sts <- append(DSNY_seasonal_sts, NA)
  }
}

# UNDE NA filter and standard deviations
for(i in 1:20){
  na_count <- 0
  for(j in UNDE_seasonal_plot_indexes[i]:UNDE_seasonal_plot_indexes[i+1]){
    if(j%in%UNDE_added_interp_locs){
      na_count <- na_count + 1
    }
  }
  
  print(paste("NA vals: ", na_count, "total measurements: ", 
              (UNDE_seasonal_plot_indexes[i+1]-UNDE_seasonal_plot_indexes[i])))
  
  if(na_count <= (UNDE_seasonal_plot_indexes[i+1]-UNDE_seasonal_plot_indexes[i])*.5){
    temp_UNDE_sd <- sd(UNDE_NSAE_limited[UNDE_seasonal_plot_indexes[i]:UNDE_seasonal_plot_indexes[i+1]])
    UNDE_seasonal_sts <- append(UNDE_seasonal_sts, temp_UNDE_sd)
  } else {
    UNDE_seasonal_sts <- append(UNDE_seasonal_sts, NA)
  }
}

# STER NA filter and standard deviations
for(i in 2:20){
  na_count <- 0
  for(j in STER_seasonal_plot_indexes[i]:STER_seasonal_plot_indexes[i+1]){
    if(j%in%STER_added_interp_locs){
      na_count <- na_count + 1
    }
  }
  
  print(paste("NA vals: ", na_count, "total measurements: ", 
              (STER_seasonal_plot_indexes[i+1]-STER_seasonal_plot_indexes[i])))
  
  if(na_count <= (STER_seasonal_plot_indexes[i+1]-STER_seasonal_plot_indexes[i])*.5){
    temp_STER_sd <- sd(STER_NSAE_limited[STER_seasonal_plot_indexes[i]:STER_seasonal_plot_indexes[i+1]])
    STER_seasonal_sts <- append(STER_seasonal_sts, temp_STER_sd)
  } else {
    STER_seasonal_sts <- append(STER_seasonal_sts, NA)
  }
}

# add NA value to first index of vector, as there were no readings for STER spring 2017
STER_seasonal_sts <- append(STER_seasonal_sts, NA, 0)


# ABBY NA filter and standard deviations
for(i in 2:20){
  na_count <- 0
  for(j in ABBY_seasonal_plot_indexes[i]:ABBY_seasonal_plot_indexes[i+1]){
    if(j%in%ABBY_added_interp_locs){
      na_count <- na_count + 1
    }
  }
  
  print(paste("NA vals: ", na_count, "total measurements: ", 
              (ABBY_seasonal_plot_indexes[i+1]-ABBY_seasonal_plot_indexes[i])))
  
  if(na_count <= (ABBY_seasonal_plot_indexes[i+1]-ABBY_seasonal_plot_indexes[i])*.5){
    temp_ABBY_sd <- sd(ABBY_NSAE_limited[ABBY_seasonal_plot_indexes[i]:ABBY_seasonal_plot_indexes[i+1]])
    ABBY_seasonal_sts <- append(ABBY_seasonal_sts, temp_ABBY_sd)
  } else {
    ABBY_seasonal_sts <- append(ABBY_seasonal_sts, NA)
  }
}

# add NA value to first index of vector, as there were no readings for ABBY spring 2017
ABBY_seasonal_sts <- append(ABBY_seasonal_sts, NA, 0)


# add all standard deviations to a data frame
flux_sds <- data.frame(DSNY_sts = DSNY_seasonal_sts, UNDE_sts = UNDE_seasonal_sts,
                       STER_sts = STER_seasonal_sts, ABBY_sts = ABBY_seasonal_sts)

#import weather data
DSNY_weather_data <- read.csv("data/weather_no_parent/DSNY_combined.csv", header=TRUE)
UNDE_weather_data <- read.csv("data/weather_no_parent/UNDE_combined.csv", header=TRUE)
STER_weather_data <- read.csv("data/weather_no_parent/STER_combined.csv", header=TRUE)
ABBY_weather_data <- read.csv("data/weather_no_parent/ABBY_combined.csv", header=TRUE)


# store season change date locations in index vector
weather_indexes <- c(3801,8217,12633,17003,21321,25737,30153,34523,38841,43257,47673,
                     52043,56409,60825,65241,69611, 73929,78345,82761,87131,91449)

# calculate average seasonal temperature for all sites

# --> DSNY
DSNY_seasonal_weather_aves <- c()

for(i in 1:20){ #iterate through all seasons in DSNY
  temp_weather_collectionDSNY <- c(DSNY_weather_data$tempTripleMean[weather_indexes[i]], 
                                   DSNY_weather_data$tempTripleMean[weather_indexes[i+1]])
  temp_ave <- round(mean(temp_weather_collectionDSNY) ,2) # average temperatures from season
  # store average temperatures in DSNY_seasonal_weather_aves vector
  DSNY_seasonal_weather_aves <- append(DSNY_seasonal_weather_aves, temp_ave)
}

# --> UNDE
UNDE_seasonal_weather_aves <- c()

for(i in 1:20){
  temp_weather_collectionUNDE <- c(UNDE_weather_data$tempTripleMean[weather_indexes[i]], 
                                   UNDE_weather_data$tempTripleMean[weather_indexes[i+1]])
  temp_ave <- round(mean(temp_weather_collectionUNDE), 2)
  UNDE_seasonal_weather_aves <- append(UNDE_seasonal_weather_aves, temp_ave)
}

# --> STER
STER_seasonal_weather_aves <- c()

for(i in 1:20){
  temp_weather_collectionSTER <- c(STER_weather_data$tempTripleMean[weather_indexes[i]], 
                                   STER_weather_data$tempTripleMean[weather_indexes[i+1]])
  temp_ave <- round(mean(temp_weather_collectionSTER), 2)
  STER_seasonal_weather_aves <- append(STER_seasonal_weather_aves, temp_ave)
}

# --> ABBY
ABBY_seasonal_weather_aves <- c()

for(i in 1:20){
  temp_weather_collectionABBY <- c(ABBY_weather_data$tempTripleMean[weather_indexes[i]], 
                                   ABBY_weather_data$tempTripleMean[weather_indexes[i+1]])
  temp_ave <- round(mean(temp_weather_collectionABBY), 2)
  ABBY_seasonal_weather_aves <- append(ABBY_seasonal_weather_aves, temp_ave)
}


# put all seasonal averages into data frame by site

weather_averages_frame <- data.frame(DSNY = DSNY_seasonal_weather_aves,
                                     UNDE = UNDE_seasonal_weather_aves,
                                     STER = STER_seasonal_weather_aves,
                                     ABBY = ABBY_seasonal_weather_aves)


# calculate site-specific regressions
DSNY_regression <- lm(flux_sds$DSNY_sts~weather_averages_frame$DSNY)
UNDE_regression <- lm(flux_sds$UNDE_sts~weather_averages_frame$UNDE)
STER_regression <- lm(flux_sds$STER_sts~weather_averages_frame$STER)
ABBY_regression <- lm(flux_sds$ABBY_sts~weather_averages_frame$ABBY)


# add all sites co2 flux standard deviations and weather aves to single column of data frame 
co2_flux_master_vector <- c(DSNY_seasonal_sts, UNDE_seasonal_sts, STER_seasonal_sts,
                            ABBY_seasonal_sts)
weather_aves_master_vector <- c(DSNY_seasonal_weather_aves, UNDE_seasonal_weather_aves,
                                STER_seasonal_weather_aves, ABBY_seasonal_weather_aves)

# create data frame that holds one column of all co2 flux data and a second column of all
#temperature data with a corresponding index to affiliated co2 flux season and location
master_frame <- data.frame(combined_sds = co2_flux_master_vector)
master_frame$combined_weather_aves <- weather_aves_master_vector

# calculate overall co2 nsae flux sts vs seasonal weather aves regression
master_regression <- lm(master_frame$combined_sds~master_frame$combined_weather_aves)
