# In-class work for activity 2
# 01/21/22

# Set working directory to my noaa data folder 
setwd("Z:\students\ggrossman\data\noaa_weather")

# Make a vector
heights <- c(30,41,20,22)

# example vector multiplication
heights_cm <- heights*100

# create a vector from 1-99
larger_vector <- 1:99

# reverse large vector
reverse_vector <- 99:1

# create a matrix
my_matrix <- matrix(c(1,2,3,4,5,6), ncol=2, byrow=TRUE)

# read weather data into variable
dataW <- read.csv("Z:/students/ggrossman/data/noaa_weather/2011124.csv")
