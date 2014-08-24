## File: plot4.R
## Question:
##   Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
## Plotting system: base (optional, to compare with Plot 1)
## Amazing {dplyr} package: the next iteration of {plyr}!!
##   http://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html

library(dplyr)

# [1] Read the data
if (!exists("NEI")) NEI <- readRDS("summarySCC_PM25.rds")
if (!exists("SCC")) SCC <- readRDS("Source_Classification_Code.rds")

# [2] Subset for the required SCC values. No need for left_join().
# For simplicity, I only search for terms including both "coal" and "comb" in EI.Sector.
# There are lots of debates in the forum, but I believe straightforward answers are enough for the purpose of this course.
SCC.required <- SCC$SCC[grep("[Cc]omb", grep("[Cc]oal", SCC$EI.Sector, value = T))]  # 99 SCCs

# [3] Calculate the PM2.5 emissions from coal combustion-related sources in the U.S. for each year
result <- summarize(group_by(filter(NEI, SCC %in% SCC.required), year), PM25 = sum(Emissions))

# [4] Produce the bar plot
png("plot4.png", 600, 600)
par(oma = c(1,1,0,0), mar = c(4,4,2,1))
options(scipen = 100)  # Remove scientific notation
barplot(result$PM25, names.arg = result$year, xlab = "Year", ylab = expression(PM[2.5] * " Emissions from Coal Combustion-related Sources in the U.S."), main = "Question 4", ylim = c(0, max(result["PM25"]) * 1.2))
dev.off()

## Answer: The emissions from coal combustion-related sources in the U.S. generally decrease over time. In addition, the proportions are similar to Plot 1, where it measures the "total" emissions.
