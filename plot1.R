## plot1.R This set of functions create first plot of the assignment

## requirements: household_power_consumption.txt file must be downloaded and unzipped
## to the working directory when running the script.
## the zip file can be downloaded from: 
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

## package requirements: sqldf 
## this R file requires the installation of the sql package to be able to load
## only the observations that will be plotted (see readData function)
require(sqldf)

## plot1 a histogram of the variable Global Active Power
plot1 <- function () {
        ## read only the rows considered in the plot
        data <- readData("household_power_consumption.txt", "Date in ('1/2/2007','2/2/2007')")

        # Initialize the png device according to the plot specification.
        # PNG file with a width of 480 pixels and a height of 480 pixels
        png(filename = "plot1.png",
            width = 480, height = 480, units = "px")
        
        ## set the cex parameter to 0.8 to scale the plotting text.
        ## this will allow y-axis ticks to fit in the y-axis
        par(cex=0.8)
        
        ## Create the histogram with the appropiate parameters to match plot1 specification
        hist(data$Global_active_power, breaks=20, col="red", main="Global Active Power", 
             xlab="Global Active Power (kilowatts)", ylab="Frequency", ylim=c(0,1200))
        
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
        ## since we are using read.csv.sql we need to replace ? characters with NA 
        dat[ dat$Global_active_power == "?" ] = NA
        
        ## Close connections (this is required by read.csv.sql)
        closeAllConnections()
        
        dat
        
}
