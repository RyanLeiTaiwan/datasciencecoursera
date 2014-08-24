## File: plot3.R
## Question:
##   Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
## Plotting system: ggplot2 (required)
## Amazing {dplyr} package: the next iteration of {plyr}!!
##   http://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html

library(dplyr)
BALTIMORE_CODE = "24510"

# [1] Read the data
if (!exists("NEI")) NEI <- readRDS("summarySCC_PM25.rds")
if (!exists("SCC")) SCC <- readRDS("Source_Classification_Code.rds")

# [2] Calculate the total PM2.5 emissions in Baltimore for each type and for each year
result <- summarize(group_by(filter(NEI, fips == BALTIMORE_CODE), type, year), PM25 = sum(Emissions))

# [3] Produce the bar plot with 4 colors for different types
library(ggplot2)
png("plot3.png", 600, 600)
par(oma = c(1,1,0,0), mar = c(4,4,2,1))
p <- ggplot(result, aes(year, PM25, color = type)) + geom_point(size = 4) + geom_line(size = 1.5) + labs(x = "Year", y = expression(PM[2.5] * " Emissions in Baltimore"), title = "Question 3")
print(p)
dev.off()

## Answer: Types 'nonprint', 'onroad', and 'nonroad' have a decreasing trend. Type 'point' has an overall increasing trend, but there is an upward jump in 2005 and a downward jump in 2008.
