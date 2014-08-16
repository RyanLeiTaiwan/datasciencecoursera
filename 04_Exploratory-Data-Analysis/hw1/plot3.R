## File: plot3.R
## Input: NONE
## Output: NONE, but Plot 3 is shown on screen and exported to PNG.
## Description:
##   Read and subset the data, construct Plot 3, and export it to a PNG file.
## Plot 3: Energy Sub Meterings 1 ~ 3 vs. Time

plot3 <- function() {
    message("====  Plot 3  ====")
    # You may need to set the locale if your system language is not English
    #Sys.setlocale("LC_TIME", "English")  # for Windows
    #Sys.setlocale("LC_TIME", "en_US.UTF-8")  # for Mac and Linux

    # [1] Read and subset the data by calling an external script
    source("read_data.R")
    message("| Reading and subsetting data...")
    print(system.time(dat <- read_data()))
    message("** done")

    # [2] Construct Plot 3 (time series *3)
    message("| Constructing the plot and exporting it to PNG...")
    # This will be shown on the computer screen
    graphics.off()
    plot3_commands(dat)

    # [3] Export the plot to a PNG file.
    ### NOTE: DO NOT use dev.copy(). It may not produce the same plot as shown on the screen.
    png("plot3.png")
    plot3_commands(dat)
    # Don't forget to close the PNG device, or the PNG won't be exported.
    dev.off()

    message("** done\n")
}

# Put the plotting commands in a function for reuse
plot3_commands <- function(dat) {
    par(bg = "transparent")
    # Construct an empty plot first, then add lines for each category
    plot(dat$Time, dat$Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering")
    lines(dat$Time, dat$Sub_metering_1, col = "black")
    lines(dat$Time, dat$Sub_metering_2, col = "red")
    lines(dat$Time, dat$Sub_metering_3, col = "blue")
    # Add legends as line symbols
    legend("topright", lty = "solid", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
}
