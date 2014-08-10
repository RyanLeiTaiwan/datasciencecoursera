## File: run_all.R
## Input: NONE
## Output: NONE, but Plot 4 (2x2 plots) is shown on screen, 
##         and Plots 1~4 are exported to PNG.
## Description: 
##   Run this program for everything (Plot 1 ~ Plot 4) in this assignment.
run_all <- function() {
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