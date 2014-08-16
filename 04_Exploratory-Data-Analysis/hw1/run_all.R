## File: run_all.R
## Input: NONE
## Output: NONE, but Plot 4 (2x2 plots) is shown on screen,
##         and Plots 1~4 are exported to PNG.
## Description:
##   Run this program for everything (Plot 1 ~ Plot 4) in this assignment.
run_all <- function() {
    # You may need to set the locale if your system language is not English
    #Sys.setlocale("LC_TIME", "English")  # for Windows
    #Sys.setlocale("LC_TIME", "en_US.UTF-8")  # for Mac and Linux
    source("plot1.R")
    source("plot2.R")
    source("plot3.R")
    source("plot4.R")
    plot1()
    plot2()
    plot3()
    plot4()
    message("========  END OF THIS ASSIGNMENT  ========")
}
