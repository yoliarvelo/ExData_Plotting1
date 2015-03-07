## plot2.R This set of functions create second plot of the assignment

## requirements: household_power_consumption.txt file must be downloaded and unzipped
## to the working directory when running the script.
## the zip file can be downloaded from: 
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

## package requirements: sqldf 
## this R file requires the installation of the sql package to be able to load
## only the observations that will be plotted (see readData function)
require(sqldf)

## plot2 plots the global active power against time
plot2 <- function () {
        ## read only the rows considered in the plot
        data <- readData("household_power_consumption.txt", "Date in ('1/2/2007','2/2/2007')")
        
        # Initialize the png device according to the plot specification.
        # PNG file with a width of 480 pixels and a height of 480 pixels
        png(filename = "plot2.png",
            width = 480, height = 480, units = "px")
                
        ## Create a line plot (Type=l) with the corresponding text
        plot(data$DateTime, data$Global_active_power, type="l", 
             xlab="", ylab="Global Active Power (kilowatts)")
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
        dat[ dat$Global_active_power == "?" ] = NA
        
        ## add a new column with date & time information
        dat$DateTime <- strptime(paste(dat$Date, dat$Time), "%d/%m/%Y %H:%M:%S") 
        dat
        
}
