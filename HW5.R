#load in lubridate
library(lubridate)

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

dayCol <- c()
yearCol <- c()

prev <- 0
yearTracker <- 2007
row <- 1
for(i in datP$doy){
  if(prev > i){
    yearTracker <- yearTracker + 1
  }
  if(i != prev){
    tempRowTracker <- 1
    tempBool <- TRUE
    for(j in datP$doy){
      if(tempRowTracker >= row && tempRowTracker <= (row + 23)){
        if(j != i){
          tempBool <- FALSE
        }
      }
      tempRowTracker <- tempRowTracker + 1
    }
    tempRowTracker
    
    if(tempBool == TRUE){
      dayCol <- append(dayCol, i)
      yearCol <- append(yearCol, yearTracker)
    }
  }
  #tempBool <- TRUE
  prev <- i
  row <- row + 1
}
df <- data.frame(dayCol, yearCol)

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
