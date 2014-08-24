## File: plot6.R
## Question:
##   Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
## Plotting system: ggplot2 (optional)
## Amazing {dplyr} package: the next iteration of {plyr}!!
##   http://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html

library(dplyr)
BALTIMORE_CODE = "24510"
LA_CODE = "06037"

# [1] Read the data
if (!exists("NEI")) NEI <- readRDS("summarySCC_PM25.rds")
if (!exists("SCC")) SCC <- readRDS("Source_Classification_Code.rds")

# [2] Subset for the required SCC values. No need for left_join().
# For simplicity, I only search for terms including both "motor" and "vehicle" in Short.Name, so things like motorcycles are EXCLUDED.
# There are lots of debates in the forum, but I believe straightforward answers are enough for the purpose of this course.
SCC.required <- SCC$SCC[grep("[Vv]ehicle", grep("[Mm]otor", SCC$Short.Name, value = T))]  # 20 SCCs

# [3] Calculate the PM2.5 emissions from motor vehicles in Baltimore and Los Angeles for each year
result <- summarize(group_by(filter(NEI, (fips == BALTIMORE_CODE | fips == LA_CODE) & SCC %in% SCC.required), fips, year), PM25 = sum(Emissions))
# Transform the "city" column for the use of ggplot2.
names(result)[1] <- "city"
result$city <- as.factor(result$city)
levels(result$city) <- c("Los Angeles", "Baltimore")


# [4] Produce the bar plot with 2 colors for different cities
library(ggplot2)
png("plot6.png", 600, 600)
par(oma = c(1,1,0,0), mar = c(4,4,2,1))
p <- ggplot(result, aes(year, PM25, color = city)) + geom_point(size = 4) + geom_line(size = 1.5) + labs(x = "Year", y = expression(PM[2.5] * " Emissions from Motor Vehicles in Each City"), title = "Question 6")
print(p)
dev.off()

## Answer: Overall speaking, Los Angeles has seen a larger decrease from 1999 to 2008, during which a sharp decrease occured in 2002. On the other hand, Baltimore has a sharp increase in 2005, but a sharp decrease in 2008.
