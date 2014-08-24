## File: plot1.R
## Question:
##   Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
## Plotting system: base (required)
## Amazing {dplyr} package: the next iteration of {plyr}!!
##   http://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html

library(dplyr)

# [1] Read the data
if (!exists("NEI")) NEI <- readRDS("summarySCC_PM25.rds")
if (!exists("SCC")) SCC <- readRDS("Source_Classification_Code.rds")

# [2] Calculate the total PM2.5 emissions in the U.S. for each year
result <- summarize(group_by(NEI, year), PM25 = sum(Emissions))

# [3] Produce the bar plot
png("plot1.png", 600, 600)
par(oma = c(1,1,0,0), mar = c(4,4,2,1))
options(scipen = 100)  # Remove scientific notation
barplot(result$PM25, names.arg = result$year, xlab = "Year", ylab = expression("Total " * PM[2.5] * " Emissions in the U.S."), main = "Question 1", ylim = c(0, max(result["PM25"]) * 1.2))
dev.off()

## Answer: Yes, Total PM2.5 emissions have strictly decreased in the U.S. from 1999 to 2008.
