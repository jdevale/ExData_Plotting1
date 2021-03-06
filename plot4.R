
library(dplyr)
library(data.table)

#Download the file if necessary
URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
fname <- "household_power_consumption.txt"
if(!file.exists(fname)) {
  destinationFile <- "exdata-data-household_power_consumption.zip"
  download.file(URL, destinationFile)
  dateDownloaded <- date()
  unzip(destinationFile, overwrite = FALSE)
}

#read in to data frame
DF <- read.csv2(fname,stringsAsFactors=F,na.strings="?")

#subset the data, and reset row names
subData_DF <- DF[grep("^[1,2]/2/2007",DF$Date),]
row.names(subData_DF)<-NULL
subData_DT <- tbl_df(subData_DF)

#convert numeric rows to numerical data format
index <- 3:9
for (j in index) set (subData_DT,j=j,value=as.numeric(subData_DT[[j]]))

#build date string and convert to POSIXct
fullDateString <- paste(subData_DT$Date,subData_DT$Time)
dateFormateString = "%d/%m/%Y %H:%M:%S"
dateTimeVec <- as.POSIXct(strptime(fullDateString,format=dateFormateString))

#Add DateTime as a column
subData_DT$posixDateTime <-dateTimeVec

#make the plots
png(filename = "plot4.png",width=480,height=480)

par(mfrow = c(2, 2)) #set for 2x2 plots in plot area
plot(subData_DT$posixDateTime,subData_DT$Global_active_power,ylab="Global Active Power",type="l",xlab="")
plot(subData_DT$posixDateTime,subData_DT$Voltage,ylab="Voltage",type="l",xlab="datetime")

plot(subData_DT$posixDateTime, subData_DT$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
lines(subData_DT$posixDateTime,subData_DT$Sub_metering_2,type="l",col="red")
lines(subData_DT$posixDateTime,subData_DT$Sub_metering_3,type="l",col="blue")
legend("topright", legend = names(subData_DT)[7:9], col = c("black", "red", "blue"), lty = 1, lwd = 1,bty="n")

plot(subData_DT$posixDateTime,subData_DT$Global_reactive_power,ylab="Global_reactive_power",type="l",xlab="datetime")

dev.off()
