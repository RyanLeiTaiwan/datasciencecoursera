## File: plot5.R
## Question:
##   How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
## Plotting system: base (optional, to compare with Plot 2)
## Amazing {dplyr} package: the next iteration of {plyr}!!
##   http://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html

library(dplyr)
BALTIMORE_CODE = "24510"

# [1] Read the data
if (!exists("NEI")) NEI <- readRDS("summarySCC_PM25.rds")
if (!exists("SCC")) SCC <- readRDS("Source_Classification_Code.rds")

# [2] Subset for the required SCC values. No need for left_join().
# For simplicity, I only search for terms including both "motor" and "vehicle" in Short.Name, so things like motorcycles are EXCLUDED.
# There are lots of debates in the forum, but I believe straightforward answers are enough for the purpose of this course.
SCC.required <- SCC$SCC[grep("[Vv]ehicle", grep("[Mm]otor", SCC$Short.Name, value = T))]  # 20 SCCs

# [3] Calculate the PM2.5 emissions from motor vehicles in Baltimore for each year
result <- summarize(group_by(filter(NEI, fips == BALTIMORE_CODE, SCC %in% SCC.required), year), PM25 = sum(Emissions))

# [4] Produce the bar plots
png("plot5.png", 600, 600)
par(oma = c(1,1,0,0), mar = c(4,4,2,1))
barplot(result$PM25, names.arg = result$year, xlab = "Year", ylab = expression(PM[2.5] * " Emissions from Motor Vehicles in Baltimore"), main = "Question 5", ylim = c(0, max(result["PM25"]) * 1.1))
dev.off()

## Answer: The emissions from motor vehicles in Baltimore generally decrease over time, but in 2005, there is a huge increase up to 3 times as much as the emission in 1999.
