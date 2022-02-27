#use install.packages to install lubridate
#install.packages(c("lubridate"))

#create a function. The names of the arguments for your function will be 
#in parentheses. Everything in curly brackets will be run each time the 
#function is run.

assert <- function(statement,err.message){
  #if evaluates if a statement is true or false for a single item
  if(statement == FALSE){
    print(err.message)
  }
  
}

#check how the statement works
#evaluate a false statement
assert(1 == 2, "error: unequal values")

#evaluate a true statement
assert(2 == 2, "error: unequal values")

#nested functions 
a <- c(1,2,3,4)
b <- c(8,4,5)
assert(length(a) == length(b), "error: unequal length")


#read data to variable datW
datW <- read.csv("Z:/students/ggrossman/data/bewkes_weather/bewkes_weather.csv",
                 na.strings=c("#N/A"), skip=3, header=FALSE)

#preview data
print(datW[1,])

#get sensor info from file
# this data table will contain all relevant units
sensorInfo <-   read.csv("Z:/students/ggrossman/data/bewkes_weather/bewkes_weather.csv",
                         na.strings=c("#N/A"), nrows=2)

print(sensorInfo)

#get column names from sensorInfo table
# and set weather station colnames  to be the same
colnames(datW) <-   colnames(sensorInfo)
#preview data
print(datW[1,])


library(lubridate)

#convert to standardized format
#date format is m/d/y
dates <- mdy_hm(datW$timestamp, tz= "America/New_York")

datW$doy <- yday(dates)
#calculate hour in the day
datW$hour <- hour(dates) + (minute(dates)/60)
#calculate decimal day of year
datW$DD <- datW$doy + (datW$hour/24)
#quick preview of new date calculations
datW[1,]



#see how many values have missing data for each sensor observation

#air temperature
length(which(is.na(datW$air.temperature)))

#wind speed
length(which(is.na(datW$wind.speed)))

#precipitation
length(which(is.na(datW$precipitation)))

#soil MOISTURE (changed from temp)
length(which(is.na(datW$soil.moisture)))

#soil TEMPERATURE (changed from moisture)
length(which(is.na(datW$soil.temp)))



#make a plot with filled in points (using pch)
#line lines
plot(datW$DD, datW$soil.moisture, pch=19, type="b", xlab = "Day of Year",
     ylab="Soil moisture (cm3 water per cm3 soil)")

#make a plot with filled in points (using pch)
#line lines
plot(datW$DD, datW$air.temperature, pch=19, type="b", xlab = "Day of Year",
     ylab="Air temperature (degrees C)")

#new QAQC column
#first argument to be evaluated as true or false on a vector
#the second argument is the value that air.tempQ1 will be given if the statement is true
#third value is what will be given to air.tempQ1 if the statement is false.
datW$air.tempQ1 <- ifelse(datW$air.temperature < 0, NA, datW$air.temperature)



# REALISTIC VALUES

#quantile - check the values at the extreme range of the data and
#throughout the percentiles
quantile(datW$air.tempQ1)

#look at days with really low air temperature
datW[datW$air.tempQ1 < 8,]  

#look at days with really high air temperature
datW[datW$air.tempQ1 > 33,]



#plot precipitation and lightning strikes on the same plot
#normalize lighting strikes to match precipitation
lightscale <- (max(datW$precipitation)/max(datW$lightning.acvitivy)) * datW$lightning.acvitivy
#make the plot with precipitation and lightning activity marked
#make it empty to start and add in features
plot(datW$DD , datW$precipitation, xlab = "Day of Year", ylab = "Precipitation & lightning",
     type="n")
#plot precipitation points only when there is precipitation 
#make the points semi-transparent
points(datW$DD[datW$precipitation > 0], datW$precipitation[datW$precipitation > 0],
       col= rgb(95/255,158/255,160/255,.5), pch=15)        

#plot lightning points only when there is lightning     
points(datW$DD[lightscale > 0], lightscale[lightscale > 0],
       col= "tomato3", pch=19)