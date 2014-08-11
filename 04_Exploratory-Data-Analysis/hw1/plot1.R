## File: plot1.R
## Input: NONE
## Output: NONE, but Plot 1 is shown on screen and exported to PNG.
## Description: 
##   Read and subset the data, construct Plot 1, and export it to a PNG file.
##   This script is called by run_all.R.
## Plot 1: histogram of the Global Active Power (kilowatts)

plot1 <- function() {
    message("====  Plot 1  ====")
    # You may need to set the locale if your system language is not English
    #Sys.setlocale("LC_TIME", "English")  # for Windows
    #Sys.setlocale("LC_TIME", "en_US.UTF-8")  # for Mac and Linux
    
    # [1] Read and subset the data by calling an external script
    source("read_data.R")
    message("| Reading and subsetting data...")
    print(system.time(dat <- read_data()))
    message("** done")
    
    # [2] Construct Plot 1 (histogram)
    message("| Constructing the plot and exporting it to PNG...")
    # This will be shown on the computer screen
    graphics.off()
    plot1_commands(dat)
    
    # [3] Export the plot to a PNG file.
    ### NOTE: DO NOT use dev.copy(). It may not produce the same plot as shown on the screen.
    png("plot1.png")
    plot1_commands(dat)
    # Don't forget to close the PNG device, or the PNG won't be exported.
    dev.off()

    message("** done\n")
}

# Put the plotting commands in a function for reuse
plot1_commands <- function(dat) {
    par(bg = "transparent")
    hist(dat$Global_active_power, xlab = "Global Active Power (kilowatts)", main = "Global Active Power", col = "red")    
}
    