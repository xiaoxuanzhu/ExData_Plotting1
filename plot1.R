# This script contains code to construct the plot1.png

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

# convert other variables to numeric class
household_sub$Global_active_power <- as.numeric(household_sub$Global_active_power)


# 3. Construct plot1.png

hist(household_sub$Global_active_power, 
     main = "Global Active Power", xlab = "Global Active Power (kilowatt)", col = "red")
dev.copy(png, file = "plot1.png", width = 480, height = 480, units = "px")
dev.off()