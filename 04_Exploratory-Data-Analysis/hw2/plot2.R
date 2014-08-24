## File: plot2.R
## Question:
##   Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.
## Plotting system: base (required)
## Amazing {dplyr} package: the next iteration of {plyr}!!
##   http://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html

library(dplyr)
BALTIMORE_CODE = "24510"

# [1] Read the data
if (!exists("NEI")) NEI <- readRDS("summarySCC_PM25.rds")
if (!exists("SCC")) SCC <- readRDS("Source_Classification_Code.rds")

# [2] Calculate the total PM2.5 emissions in Baltimore for each year
result <- summarize(group_by(filter(NEI, fips == BALTIMORE_CODE), year), PM25 = sum(Emissions))

# [3] Produce the bar plot
png("plot2.png", 600, 600)
par(oma = c(1,1,0,0), mar = c(4,4,2,1))
options(scipen = 100)  # Remove scientific notation
barplot(result$PM25, names.arg = result$year, xlab = "Year", ylab = expression("Total " * PM[2.5] * " Emissions in Baltimore"), main = "Question 2", ylim = c(0, max(result["PM25"]) * 1.1))
dev.off()

## Answer: Not exactly. The emissions in Baltimore generally decrease over time, but in 2005, the value goes up again.
