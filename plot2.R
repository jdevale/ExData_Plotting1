
library(dplyr)
library(data.table)

#Download the file if necessary
URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
fname <- "household_power_consumption.txt"
if(!file.exists(fname)) {
  destinationFile <- "exdata-data-household_power_consumption.zip"
  download.file(URL, destinationFile)
  dateDownloaded <- date()
  unzip(fileDest, overwrite = FALSE)
}

#read in to data frame
DF <- read.csv2(fname,stringsAsFactors=F,na.strings="?")

#subset the data, and reset row names
subData_DF <- DF[grep("^[1,2]/2/2007",DF$Date),]
row.names(subData_DF)<-NULL
subData_DT <- tbl_df(subData_DF)

#convert numeric rows to numerical data format
index <- 3:9
for (j in index) set (subData_DT,j=j,value=as.numeric(subData[[j]]))

#build date string and convert to POSIXct
fullDateString <- paste(subData_DT$Date,subData_DT$Time)
dateFormateString = "%d/%m/%Y %H:%M:%S"
dateTimeVec <- as.POSIXct(strptime(fullDateString,format=dateFormateString))

#Add DateTime as a column
subData_DT$posixDateTime <-dateTimeVec

#make the plots
png(filename = "plot2.png",width=480,height=480)
plot(subData_DT$posixDateTime,subData_DT$Global_active_power,ylab="Global Active Power (kilowatts)",type="l",xlab="")
dev.off()
