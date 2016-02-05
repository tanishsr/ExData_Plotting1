## Script to generate plot 1 for dataset as a part of Exploratory Data Analysis Week-1 project-1.
## Script performs the following tasks:
## - Collect the project data and generate subset to be used for plotting graph
## - Generate PNG file for the plot

#Load library
library(data.table)
library(dplyr)

## Collect the data project and read the subset
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
	
	powerdata <- fread("./data/household_power_consumption.txt", na.strings="?")
	powerdata$Date <- as.Date(powerdata$Date, format = "%d/%m/%Y")
	subsetdata <- subset(powerdata, Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02"))
	rm(powerdata)
	subsetdata <- mutate(subsetdata, datetime = as.POSIXct(paste(subsetdata$Date, subsetdata$Time), format = "%Y-%m-%d %H:%M:%S"))
	write.table(subsetdata, "./data/subset_data.txt", row.names=FALSE, sep = ";")
}


#Subset Data created

#Generate Plot: 1

# Open PNG graphic device
png("plot1.png")

# Plot Histogram for global active power using hist function
# Set the color of the bars using col option
# Set X-axis label using xlab option
# Set Plot main title using main option
hist(subsetdata$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main="Global Active Power")

#Close the graphic device
dev.off()
