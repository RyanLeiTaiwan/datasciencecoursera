## File: plot4.R
## Input: NONE
## Output: NONE, but Plot 4 is shown on screen and exported to PNG.
## Description: 
##   Read and subset the data, construct Plot 4, and export it to a PNG file.
## Plot 4: 2x2 subplots in one plot

plot4 <- function() {
    message("====  Plot 4  ====")
    # You may need to set the locale if your system language is not English
    #Sys.setlocale("LC_TIME", "Ensligh")  # for Windows
    #Sys.setlocale("LC_TIME", "en_US.UTF-8")  # for Mac and Linux    
    
    # [1] Read and subset the data by calling an external script
    source("read_data.R")
    message("| Reading and subsetting data...")
    print(system.time(dat <- read_data()))
    message("** done")
    
    # [2] Construct Plot 4 (2x2 subplots)
    message("| Constructing the plot and exporting it to PNG...")
    # This will be shown on the computer screen
    graphics.off()
    ### If the plotting window on the screen is not LARGE ENOUGH, you will see errors like:
    ###  Error in plot.new() : figure margins too large
    plot4_commands(dat)
    
    # [3] Export the plot to a PNG file.
    ### NOTE: DO NOT use dev.copy(). It may not produce the same plot as shown on the screen.
    png("plot4.png")
    plot4_commands(dat)
    # Don't forget to close the PNG device, or the PNG won't be exported.
    dev.off()

    message("** done\n")
}

# Put the plotting commands in a function for reuse
plot4_commands <- function(dat) {
    par(bg = "transparent")
    # col-wise subplots of 2x2
    par(mfcol = c(2,2))
    
    # subplot[1,1]: Global Active Power vs. Time (like in plot2.R)
    plot(dat$Time, dat$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")
    
    # subplot[2,1]: Energy Sub Meterings 1 ~ 3 vs. Time (like in plot3.R)
    plot(dat$Time, dat$Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering")
    lines(dat$Time, dat$Sub_metering_1, col = "black")
    lines(dat$Time, dat$Sub_metering_2, col = "red")
    lines(dat$Time, dat$Sub_metering_3, col = "blue")
    legend("topright", lty = "solid", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    
    # subplot[1,2]: Voltage vs. Time
    plot(dat$Time, dat$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")
    
    # subplot[2,2]: Global Reactive Power vs. Time
    plot(dat$Time, dat$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")
}
