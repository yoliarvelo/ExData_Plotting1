## plot3.R This set of functions create third plot of the assignment

## requirements: household_power_consumption.txt file must be downloaded and unzipped
## to the working directory when running the script.
## the zip file can be downloaded from: 
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

## package requirements: sqldf 
## this R file requires the installation of the sql package to be able to load
## only the observations that will be plotted (see readData function)
require(sqldf)

## plot3 plots the energy metering variables (1,2 and 3) against time. 
plot3 <- function () {
        ## read only the rows considered in the plot
        data <- readData("household_power_consumption.txt", "Date in ('1/2/2007','2/2/2007')")
        
        # Initialize the png device according to the plot specification.
        # PNG file with a width of 480 pixels and a height of 480 pixels
        png(filename = "plot3.png",
            width = 480, height = 480, units = "px")
        
        ## set the cex parameter to 0.8 to scale the plotting text.
        ## this will allow y-axis ticks to fit in the y-axis
        par(cex=0.8)
        
        ## Create a line plot (Type=l) with the corresponding text for Sub_metering_1 variable
        plot(data$DateTime, data$Sub_metering_1, type="l", lty=1, 
             xlab="", ylab="Energy sub metering")
        
        ## Graph Sub_metering_2 variable
        lines(data$DateTime, data$Sub_metering_2, type="l", lty=1, 
              col="red")
        ## Graph Sub_tering_3 variable
        lines(data$DateTime, data$Sub_metering_3, type="l", lty=1, 
              col="blue")

        # Create a legend in the top-right corner that has same names as variable names
        # and the colors from the plot
        legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"), lty=1);
        
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
