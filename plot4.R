# This script contains code to construct the plot4.png

# 1. Download the data and read it into R

if (!file.exists("./data")) {
  dir.create("./data")
}
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileurl, destfile = "./data/household_power_consumption.zip", method = "curl")
unzip("./data/household_power_consumption.zip", exdir = "./data")
household <- read.table("./data/household_power_consumption.txt", sep = ";", header = TRUE)


# 2. Subset the data and clean it

# convert the Date variable to Date class
library(lubridate)
household$Date <- dmy(household$Date)

# extract the rows from the dates 2007-02-01 and 2007-02-02
library(dplyr)
household_sub <- filter(household, Date == ymd("2007-02-01") | Date == ymd("2007-02-02"))

# convert the Time variable to Time class
household_sub$Time <- hms(household_sub$Time)

# convert other variables to numeric class
household_sub$Global_active_power <- as.numeric(household_sub$Global_active_power)
household_sub$Global_reactive_power <- as.numeric(household_sub$Global_reactive_power)
household_sub$Voltage <- as.numeric(household_sub$Voltage)
household_sub$Sub_metering_1 <- as.numeric(household_sub$Sub_metering_1)
household_sub$Sub_metering_2 <- as.numeric(household_sub$Sub_metering_2)

# create a new variable date_time
household_sub2 <- mutate(household_sub, date_time = Date + Time)


# 3. Construct plot4.png

png(filename = "plot4.png", width = 480, height = 480, units = "px")
par(mfrow = c(2, 2))
plot(household_sub2$date_time, household_sub2$Global_active_power, 
     type = "l", xlab = "", ylab = "Global Active Power (kilowatt)")
plot(household_sub2$date_time, household_sub2$Voltage, 
     type = "l", xlab = "datetime", ylab = "Voltage")
plot(household_sub2$date_time, household_sub2$Sub_metering_1, 
     type = "l", xlab = "", ylab = "Energy sub metering")
lines(household_sub2$date_time, household_sub2$Sub_metering_2, col = "red")
lines(household_sub2$date_time, household_sub2$Sub_metering_3, col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lty = 1, seg.len = 1, cex = 1, bty = "n")
plot(household_sub2$date_time, household_sub2$Global_reactive_power, 
     type = "l", xlab = "datetime", ylab = "Global_reactive_power")
dev.off()