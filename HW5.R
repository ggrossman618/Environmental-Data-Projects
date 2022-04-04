#load in lubridate
library(lubridate)
library(ggplot2)

#read in streamflow data
datH <- read.csv("Z:/students/ggrossman/data/streamflow/stream_flow_data.csv", 
                 na.strings = c("Eqp"))
head(datH)  


#read in precipitation data
#hourly precipitation is in mm
datP <- read.csv("Z:/students/ggrossman/data/streamflow/2049867.csv")                            
head(datP)

 
#streamflow data only using most reliable measurements
datD <- datH[datH$discharge.flag == "A",]


#### define time for streamflow #####
#convert date and time
datesD <- as.Date(datD$date, "%m/%d/%Y")
#get day of year
datD$doy <- yday(datesD)
#calculate year
datD$year <- year(datesD)
#define time
timesD <- hm(datD$time)

#### define time for precipitation #####    
dateP <- ymd_hm(datP$DATE)
#get day of year
datP$doy <- yday(dateP)
#get year 
datP$year <- year(dateP)

#### get decimal formats #####
#convert time from a string to a more usable format
#with a decimal hour
datD$hour <- hour(timesD ) + (minute(timesD )/60)
#get full decimal time
datD$decDay <- datD$doy + (datD$hour/24)
#calculate a decimal year, but account for leap year
datD$decYear <- ifelse(leap_year(datD$year),datD$year + (datD$decDay/366),
                       datD$year + (datD$decDay/365))
#calculate times for datP                       
datP$hour <- hour(dateP ) + (minute(dateP )/60)
#get full decimal time
datP$decDay <- datP$doy + (datP$hour/24)
#calculate a decimal year, but account for leap year
datP$decYear <- ifelse(leap_year(datP$year),datP$year + (datP$decDay/366),
                       datP$year + (datP$decDay/365))  

#plot discharge
plot(datD$decYear, datD$discharge, type="l", xlab="Year", ylab=expression(paste("Discharge ft"^"3 ","sec"^"-1")))


##################################
#Question 4
##################################

#answered in document


#basic formatting
aveF <- aggregate(datD$discharge, by=list(datD$doy), FUN="mean")
colnames(aveF) <- c("doy","dailyAve")
sdF <- aggregate(datD$discharge, by=list(datD$doy), FUN="sd")
colnames(sdF) <- c("doy","dailySD")

#start new plot
#dev.new(width=8,height=8)

#bigger margins
par(mai=c(1,1,1,1))
#make plot
plot(aveF$doy,aveF$dailyAve, 
     type="l", 
     xlab="Months of Year", #changed from year, because it is day
     ylab=expression(paste("Discharge ft"^"3 ","sec"^"-1")),
     lwd=2,
     ylim=c(0,120),
     xaxs="i", yaxs ="i",#remove gaps from axes
     axes=FALSE)#no axes
polygon(c(aveF$doy, rev(aveF$doy)),#x coordinates
        c(aveF$dailyAve-sdF$dailySD,rev(aveF$dailyAve+sdF$dailySD)),#ycoord
        col=rgb(0.392, 0.584, 0.929,.2), #color that is semi-transparent
        border=NA#no border
)       
axis(1, seq(1,366, by=30), #tick intervals
     lab=seq(1,13, by=1),) #tick labels
axis(2, seq(0,120, by=20),
     seq(0,120, by=20),
     las = 2)#show ticks at 90 degree angle
legend("topright", c("mean","1 standard deviation"), #legend items
       lwd=c(2,NA),#lines
       col=c("black",rgb(0.392, 0.584, 0.929,.2)),#colors
       pch=c(NA,15),#symbols
       bty="n")#no legend border


##################################
#Question 5
##################################

# Some changes to graph above plus added line below
lines(datD$discharge[datD$year == 2017], col="red")


##################################
#Question 6
##################################

# answered in document


##################################
#Question 7
##################################

dayCol <- c() # will hold all days that have 24h measurements
yearCol <- c() # will hold corresponding years

prev <- 0 # keeps track of previous day in loop
yearTracker <- 2007
row <- 1 # keeps track of row in loop
for(i in datP$doy){
  if(prev > i){ # if previous day is larger than current day, the year changed, increase year
    yearTracker <- yearTracker + 1
  }
  if(i != prev){ # if our current day is not the same as previous day, makes sure we start on first measurement of day
    tempRowTracker <- 1 # keeps track of row in nested loop
    tempBool <- TRUE # boolean that after loop says if day has 24 measurements
    for(j in datP$doy){
      if(tempRowTracker >= row && tempRowTracker <= (row + 23)){ # if nested loop is in between first instance of outer loop day and 24 measurements after first instance of outer loop day
        if(j != i){ # if nested loop day is not the same as outer loop day
          tempBool <- FALSE # set boolean to false -> day does not have 24 hours of measurements
        }
      }
      tempRowTracker <- tempRowTracker + 1 # iterate row in nested loop
    }
    
    if(tempBool == TRUE){ # if current day has 24 hours of measurements add day and year to day and year columns
      dayCol <- append(dayCol, i)
      yearCol <- append(yearCol, yearTracker)
    }
  }
  prev <- i # set previous day to current day before moving to next day
  row <- row + 1 # move to next row
}
df <- data.frame(dayCol, yearCol) #put day column and year column into a dataframe

#calculate a decimal year, but account for leap year
df$decYear <- ifelse(leap_year(df$yearCol),df$yearCol + (df$dayCol/366),
                       df$yearCol + (df$dayCol/365))


# Plot Discharge
plot(datD$decYear, datD$discharge, type="l", xlab="Year", ylab=expression(paste("Discharge ft"^"3 ","sec"^"-1")),
)

for(i in df$decYear){
  abline(v=i, col=rgb(0.392, 0.584, 0.929,.4))
}
legend("topright", "24h prec.", #legend items
       lwd=c(1,NA),#lines
       col= rgb(0.392, 0.584, 0.929),#colors
       pch=c(NA,15),#symbols
       )


# END OF Q7

#subsest discharge and precipitation within range of interest
hydroD <- datD[datD$doy >= 248 & datD$doy < 250 & datD$year == 2011,]
hydroP <- datP[datP$doy >= 248 & datP$doy < 250 & datP$year == 2011,]
min(hydroD$discharge) 

#get minimum and maximum range of discharge to plot
#go outside of the range so that it's easy to see high/low values
#floor rounds down the integer
yl <- floor(min(hydroD$discharge))-1
#ceiling rounds up to the integer
yh <- ceiling(max(hydroD$discharge))+1
#minimum and maximum range of precipitation to plot
pl <- 0
pm <-  ceiling(max(hydroP$HPCP))+.5
#scale precipitation to fit on the 
hydroP$pscale <- (((yh-yl)/(pm-pl)) * hydroP$HPCP) + yl

par(mai=c(1,1,1,1))
#make plot of discharge
plot(hydroD$decDay,
     hydroD$discharge, 
     type="l", 
     ylim=c(yl,yh), 
     lwd=2,
     xlab="Day of year", 
     ylab=expression(paste("Discharge ft"^"3 ","sec"^"-1")))
#add bars to indicate precipitation 
for(i in 1:nrow(hydroP)){
  polygon(c(hydroP$decDay[i]-0.017,hydroP$decDay[i]-0.017,
            hydroP$decDay[i]+0.017,hydroP$decDay[i]+0.017),
          c(yl,hydroP$pscale[i],hydroP$pscale[i],yl),
          col=rgb(0.392, 0.584, 0.929,.2), border=NA)
}



##################################
#Question 8
##################################
#subsest discharge and precipitation within range of interest
newHydroD <- datD[datD$doy >= 10 & datD$doy < 12 & datD$year == 2011,]
newHydroP <- datP[datP$doy >= 10 & datP$doy < 12 & datP$year == 2011,]


#get minimum and maximum range of discharge to plot
#go outside of the range so that it's easy to see high/low values
#floor rounds down the integer
yl <- floor(min(newHydroD$discharge))-1
#ceiling rounds up to the integer
yh <- ceiling(max(newHydroD$discharge))+1
#minimum and maximum range of precipitation to plot
pl <- 0
pm <-  ceiling(max(newHydroP$HPCP))+.5
#scale precipitation to fit on the 
newHydroP$pscale <- (((yh-yl)/(pm-pl)) * newHydroP$HPCP) + yl

par(mai=c(1,1,1,1))
#make plot of discharge
plot(newHydroD$decDay,
     newHydroD$discharge, 
     type="l", 
     ylim=c(yl,yh), 
     lwd=2,
     xlab="Day of year", 
     ylab=expression(paste("Discharge ft"^"3 ","sec"^"-1")))
#add bars to indicate precipitation 
for(i in 1:nrow(newHydroP)){
  polygon(c(newHydroP$decDay[i]-0.017,newHydroP$decDay[i]-0.017,
            newHydroP$decDay[i]+0.017,newHydroP$decDay[i]+0.017),
          c(yl,newHydroP$pscale[i],newHydroP$pscale[i],yl),
          col=rgb(0.392, 0.584, 0.929,.2), border=NA)
}

# End of question 8

#specify year as a factor
datD$yearPlot <- as.factor(datD$year)
#make a boxplot
ggplot(data= datD, aes(yearPlot,discharge)) + 
  geom_boxplot()
# make a violin plot
ggplot(data= datD, aes(yearPlot,discharge)) + 
  geom_violin()



##################################
#Question 9
##################################
datD$yearPlot <- as.factor(datD$year)
datD$month <- month(datesD)

# 2016
d2016 <- data.frame(datD$doy[datD$year==2016], # creating data frame which holds doy, discharge, and month for 2016
                    datD$discharge[datD$year==2016],
                    datD$month[datD$year==2016])


colnames(d2016) <- c('doy','discharge','month') # changing column names from filter titles to actual names

d2016$season <- ifelse((d2016$month < 3), "Winter", # using if else statements to add the season as another column, chaning them together with their y values
                ifelse((d2016$month < 6), "Spring", 
                ifelse((d2016$month < 9), "Summer", 
                ifelse((d2016$month < 12), "Fall", "Winter"))))
                
ggplot(data= d2016, aes(season,discharge)) +  #plotting data with violin plot and title for 2016
  geom_violin() + labs(title = '2016 Stream Flow') 




# 2017
d2017 <- data.frame(datD$doy[datD$year==2017], 
                    datD$discharge[datD$year==2017],
                    datD$month[datD$year==2017])


colnames(d2017) <- c('doy','discharge','month')

d2017$season <- ifelse((d2017$month < 3), "Winter", 
                ifelse((d2017$month < 6), "Spring", 
                ifelse((d2017$month < 9), "Summer", 
                ifelse((d2017$month < 12), "Fall", "Winter"))))

ggplot(data= d2017, aes(season,discharge)) + 
  geom_violin() + labs(title = '2017 Stream Flow')
