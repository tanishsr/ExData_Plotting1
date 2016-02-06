## Script to generate plot 2 for dataset as a part of Exploratory Data Analysis Week-1 project-1.
## Script performs the following tasks:
## - Collect the project data and generate subset to be used for plotting graph
## - Generate PNG file for the plot

#Load library
library(data.table)
library(dplyr)
library(sqldf)

## Collect the data project and read the subset
## 2 solutions are implemented for reading the dataset.
## Solution 1: Read and Subset the data
## In this solution data is read first using fread function, as it takes less time to read large data set, and then using subset function required date data is extracted
##
## Solution 2: Read the subset using sqldf
## In this solution, sqldf package is used to read the subset of data. If sqldf package is not installed, then comment out the solution 2 section below and library(sqldf), and uncomment the solution 1 section below.
##
## Once the subset of data is read, then it is saved in subset_data.txt file so that entire data set is not read again and again to plot other graphs. 
## Note: This script will download the project data set zip. This step can be skipped by keeping the downloaded zip into the 'data' folder in the current working directory

## If "data" folder is not there in the current woring directory, then create it. 
if(!file.exists("data")){
	## Data directory doesn't exist, creating the directory
	dir.create("data")
}
	
if(file.exists("./data/subset_data.txt")){
	subsetdata <- fread("./data/subset_data.txt")
	subsetdata$datetime <- as.POSIXct(subsetdata$datetime, format = "%Y-%m-%d %H:%M:%S")
} else {
	if(!file.exists("./data/exdata_data_household_power_consumption.zip")){
		download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile="./data/exdata_data_household_power_consumption.zip")
	}
	
	if(!file.exists("./data/household_power_consumption.txt")){
		unzip("./data/exdata_data_household_power_consumption.zip", exdir="./data/")
	}
	
	## Solution 1
	#powerdata <- fread("./data/household_power_consumption.txt", na.strings="?")
	#powerdata$Date <- as.Date(powerdata$Date, format = "%d/%m/%Y")
	#subsetdata <- subset(powerdata, Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02"))
	#rm(powerdata)
	## End of Solution 1
	
	
	## Solution 2
	datafile <- file("./data/household_power_consumption.txt")
	subsetdata <- sqldf("select * from datafile where Date in ('1/2/2007','2/2/2007')", dbname = tempfile(), file.format = list(header = T, row.names = F, sep =";"))
	## End of Solution 2
	
	subsetdata <- mutate(subsetdata, datetime = as.POSIXct(paste(subsetdata$Date, subsetdata$Time), format = "%d/%m/%Y %H:%M:%S"))
	write.table(subsetdata, "./data/subset_data.txt", row.names=FALSE, sep = ";")
}

#Subset Data created

#Generate Plot: 2

# Open PNG graphic device
png("plot2.png")

# Line graph for Global Active power against datetime
# Set X-axis label using xlab option
# Set Y-axis label using ylab option
with(subsetdata,{ plot(datetime,Global_active_power, type = "n", xlab = "", ylab = "Global Active Power (kilowatts)");lines(datetime,Global_active_power)})

#Close the graphic device
dev.off()
