## plot4.R This set of functions create forth plot of the assignment

## requirements: household_power_consumption.txt file must be downloaded and unzipped
## to the working directory when running the script.
## the zip file can be downloaded from: 
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

## package requirements: sqldf 
## this R file requires the installation of the sql package to be able to load
## only the observations that will be plotted (see readData function)
require(sqldf)

## plot4 function plots the following graphs in one image:
## 1.- global active power against time
## 2.- voltage against time 
## 3.- energy metering variables (1,2 and 3) against time. 
## 4.- global reactive power against time
plot4 <- function () {
        ## read only the rows considered in the plot 1/2/2007 and 2/2/2007
        data <- readData("household_power_consumption.txt", "Date in ('1/2/2007','2/2/2007')")
        
        # Initialize the png device according to the plot specifications:
        # PNG file with a width of 480 pixels and a height of 480 pixels
        png(filename = "plot4.png",
            width = 480, height = 480, units = "px")
        
        ## set the cex parameter to 0.8 to scale the plotting text.
        ## set the mfrow parameter to plot 4 graphs on the same image
        ## set the mar and oma parameters for the margings
        par(mfrow = c(2, 2), mar = c(5, 4, 2, 1))
        
        ## 1.- global active power against time
        plot(data$DateTime, data$Global_active_power, type="l", 
             xlab="", ylab="Global Active Power (kilowatts)")        
        
        ## 2.- voltage against time 
        plot(data$DateTime, data$Voltage, type="l", 
             xlab="datetime", ylab="Voltage")
        
        ## 3.- energy metering variables (1,2 and 3) against time. 
        plot(data$DateTime, data$Sub_metering_1, type="l", lty=1, 
             xlab="", ylab="Energy sub metering")
        lines(data$DateTime, data$Sub_metering_2, type="l", lty=1, 
              col="red")
        lines(data$DateTime, data$Sub_metering_3, type="l", lty=1, 
              col="blue")
        legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
               col=c("black","red","blue"), lty=1, bty="n");
        
        ## 4.- global reactive power against time
        plot(data$DateTime, data$Global_reactive_power, type="l", 
             xlab="datetime", ylab="Global_reactive_power")
        
        ## Close the png device
        dev.off()
}


## readData reads the data file into a data frame. Only reads the specified rows
## according to the condition provided
readData <- function(fileName, condition) {
        ## Returns a data frame with the data present in the <fileName> file.
        ## it will only a subset of rows
        ## according to the condition parameter
        options(stringsAsFactors = FALSE)
        dat <- read.csv.sql(fileName, sep=";", header=TRUE, 
                            sql = paste("select * from file where", condition)) 
        ## Close connections (this is required by read.csv.sql)
        closeAllConnections()
        
        ## since we are using read.csv.sql we need to replace ? characters with NA 
        dat[ dat$Sub_metering_1 == "?" ] = NA
        dat[ dat$Sub_metering_2 == "?" ] = NA
        dat[ dat$Sub_metering_3 == "?" ] = NA
        
        ## add a new column with date & time information
        dat$DateTime <- strptime(paste(dat$Date, dat$Time), "%d/%m/%Y %H:%M:%S") 
        dat
        
}
