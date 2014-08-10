## File: plot2.R
## Input: NONE
## Output: NONE, but Plot 2 is shown on screen and exported to PNG.
## Description: 
##   Read and subset the data, construct Plot 2, and export it to a PNG file.
## Plot 2: Global Active Power (kilowatts) vs. Time

plot2 <- function() {
    message("====  Plot 2  ====")
    # You may need to set the locale if your system language is not English
    #Sys.setlocale("LC_TIME", "Ensligh")  # for Windows
    #Sys.setlocale("LC_TIME", "en_US.UTF-8")  # for Mac and Linux
    
    # [1] Read and subset the data by calling an external script
    source("read_data.R")
    message("| Reading and subsetting data...")
    print(system.time(dat <- read_data()))
    message("** done")
    
    # [2] Construct Plot 2 (time series)
    message("| Constructing the plot and exporting it to PNG...")
    # This will be shown on the computer screen
    graphics.off()
    plot2_commands(dat)
    
    # [3] Export the plot to a PNG file.
    ### NOTE: DO NOT use dev.copy(). It may not produce the same plot as shown on the screen.
    png("plot2.png")
    plot2_commands(dat)
    # Don't forget to close the PNG device, or the PNG won't be exported.
    dev.off()

    message("** done\n")
}

# Put the plotting commands in a function for reuse
plot2_commands <- function(dat) {
    par(bg = "transparent")
    plot(dat$Time, dat$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")    
}
    