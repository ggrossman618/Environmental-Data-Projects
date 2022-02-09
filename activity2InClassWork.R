# In-class work for activity 2
# 01/21/22

# Set working directory to my noaa data folder 
setwd("Z:\students\ggrossman\data\noaa_weather")

# Make a vector
heights <- c(30,41,20,22)

# example vector multiplication
heights_cm <- heights*100
heights_cm
heights[1] #heights vector at element 1, should return 30
heights[2:3]#heights vector between (inclusive) element 2 & 3, should return 41, 20

# create a vector from 1-99
larger_vector <- 1:99

# reverse large vector
reverse_vector <- 99:1

# create a matrix
my_matrix <- matrix(c(1,2,3,4,5,6), ncol=2, byrow=TRUE)

# read weather data into variable
datW <- read.csv("Z:/students/ggrossman/data/noaa_weather/2011124.csv")

# change data format 
datW$dateF <- as.Date(datW$DATE, "%Y-%m-%d")
datW$year <- as.numeric(format(datW$dateF,"%Y"))
datW$NAME <- as.factor(datW$NAME)
 
# question 2 vectors
character_vector <- c("H", "E", "L", "L", "O")
numeric_vector <- c(1.1, 2.2, 3.3, 4.4, 5.5)
integer_vector <- c(1L, 2L, 3L, 4L, 5L)
factor_vector <- factor(c("blue", "green", "blue", "brown", "brown", "hazel")) # eye color

# save average temp
datW$TAVE <- datW$TMIN + ((datW$TMAX-datW$TMIN)/2)

# aggregate function to calculate means across and indexing value
averageTemp <- aggregate(datW$TAVE, by=list(datW$NAME), FUN="mean",na.rm=TRUE)
averageTemp

# changes the auto output for column names to be be more meaningful
colnames(averageTemp) <- c("NAME","MAAT")
averageTemp

# converts factor data to underlying numbers
datW$siteN <- as.numeric(datW$NAME)

par(mfrow=c(2,2))

# histogram for frequency of average daily temperatures in Aberdeen
hist(datW$TAVE[datW$NAME == "ABERDEEN, WA US"],
     freq=FALSE, 
     main = paste(levels(datW$NAME)[1]), # can replace line with main = "aberdeen..." to display name
     #main = "ABERDEEN, WA US",
     xlab = "Average daily temperature (degrees C)", 
     ylab="Relative frequency",
     col="grey50",
     border="white")
#add mean line with red (tomato3) color
#and thickness of 3
abline(v = mean(datW$TAVE[datW$NAME == "ABERDEEN, WA US"],na.rm=TRUE), 
       col = "tomato3",
       lwd = 3)
#add standard deviation line below the mean with red (tomato3) color
#and thickness of 3
abline(v = mean(datW$TAVE[datW$NAME == "ABERDEEN, WA US"],na.rm=TRUE) - sd(datW$TAVE[datW$NAME == "ABERDEEN, WA US"],na.rm=TRUE), 
       col = "tomato3", 
       lty = 3,
       lwd = 3)
#add standard deviation line above the mean with red (tomato3) color
#and thickness of 3
abline(v = mean(datW$TAVE[datW$NAME == "ABERDEEN, WA US"],na.rm=TRUE) + sd(datW$TAVE[datW$NAME == "ABERDEEN, WA US"],na.rm=TRUE), 
       col = "tomato3", 
       lty = 3,
       lwd = 3)

# question #4, histogram 2
hist(datW$TAVE[datW$NAME == "MORMON FLAT, AZ US"],
     freq=FALSE, 
     main = paste(levels(datW$NAME)[4]), # can replace line with main = "aberdeen..." to display name
     #main = "MORMON FLAT, AZ US",
     xlab = "Average daily temperature (degrees C)", 
     ylab="Relative frequency",
     col="pink",
     border="white")
#add mean line with red (tomato3) color
#and thickness of 3
abline(v = mean(datW$TAVE[datW$NAME == "MORMON FLAT, AZ US"],na.rm=TRUE), 
       col = "tomato3",
       lwd = 3)
#add standard deviation line below the mean with red (tomato3) color
#and thickness of 3
abline(v = mean(datW$TAVE[datW$NAME == "MORMON FLAT, AZ US"],na.rm=TRUE) - sd(datW$TAVE[datW$NAME == "MORMON FLAT, AZ US"],na.rm=TRUE), 
       col = "tomato3", 
       lty = 3,
       lwd = 3)
#add standard deviation line above the mean with red (tomato3) color
#and thickness of 3
abline(v = mean(datW$TAVE[datW$NAME == "MORMON FLAT, AZ US"],na.rm=TRUE) + sd(datW$TAVE[datW$NAME == "MORMON FLAT, AZ US"],na.rm=TRUE), 
       col = "tomato3", 
       lty = 3,
       lwd = 3)

# question #4, histogram 3
hist(datW$TAVE[datW$NAME == "MANDAN EXPERIMENT STATION, ND US"],
     freq=FALSE, 
     main = paste(levels(datW$NAME)[3]), # can replace line with main = "aberdeen..." to display name
     #main = "MANDAN EXPERIMENT STATION, ND US",
     xlab = "Average daily temperature (degrees C)", 
     ylab="Relative frequency",
     col="green",
     border="white")
#add mean line with red (tomato3) color
#and thickness of 3
abline(v = mean(datW$TAVE[datW$NAME == "MANDAN EXPERIMENT STATION, ND US"],na.rm=TRUE), 
       col = "tomato3",
       lwd = 3)
#add standard deviation line below the mean with red (tomato3) color
#and thickness of 3
abline(v = mean(datW$TAVE[datW$NAME == "MANDAN EXPERIMENT STATION, ND US"],na.rm=TRUE) - sd(datW$TAVE[datW$NAME == "MANDAN EXPERIMENT STATION, ND US"],na.rm=TRUE), 
       col = "tomato3", 
       lty = 3,
       lwd = 3)
#add standard deviation line above the mean with red (tomato3) color
#and thickness of 3
abline(v = mean(datW$TAVE[datW$NAME == "MANDAN EXPERIMENT STATION, ND US"],na.rm=TRUE) + sd(datW$TAVE[datW$NAME == "MANDAN EXPERIMENT STATION, ND US"],na.rm=TRUE), 
       col = "tomato3", 
       lty = 3,
       lwd = 3)


# question #4, histogram 4
hist(datW$TAVE[datW$NAME == "LIVERMORE, CA US"],
     freq=FALSE, 
     main = paste(levels(datW$NAME)[2]), # can replace line with main = "aberdeen..." to display name
     #main = "LIVERMORE, CA US",
     xlab = "Average daily temperature (degrees C)", 
     ylab="Relative frequency",
     col="blue",
     border="white")
#add mean line with red (tomato3) color
#and thickness of 3
abline(v = mean(datW$TAVE[datW$NAME == "LIVERMORE, CA US"],na.rm=TRUE), 
       col = "tomato3",
       lwd = 3)
#add standard deviation line below the mean with red (tomato3) color
#and thickness of 3
abline(v = mean(datW$TAVE[datW$NAME == "LIVERMORE, CA US"],na.rm=TRUE) - sd(datW$TAVE[datW$NAME == "LIVERMORE, CA US"],na.rm=TRUE), 
       col = "tomato3", 
       lty = 3,
       lwd = 3)
#add standard deviation line above the mean with red (tomato3) color
#and thickness of 3
abline(v = mean(datW$TAVE[datW$NAME == "LIVERMORE, CA US"],na.rm=TRUE) + sd(datW$TAVE[datW$NAME == "LIVERMORE, CA US"],na.rm=TRUE), 
       col = "tomato3", 
       lty = 3,
       lwd = 3)


