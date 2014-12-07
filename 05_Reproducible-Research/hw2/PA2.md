# Impact of Weather Events on Population Health and Economy
Ryan Lei  
September 21, 2014  
Peer Assessment 2 of the course Reproducible Research in Data Science Specialization @ Coursera

## Synopsis
In this report, we explore the U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database, whose data were collected from 1950 to 2011. We then investigate the impact of harmful weather events on population health and economy by summarizing the injuries, fatalities, property damage, and crop damage caused by each type of weather events. From this analysis, we conclude that tornadoes are the most harmful to population health, and floods cause the greatest economic damage. We present these findings in two stacked bar plots.

## Data Processing
### Load R Packages

```r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
## 
## The following object is masked from 'package:stats':
## 
##     filter
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
library(reshape2)
library(ggplot2)
library(grid)
```

### Reading Data
First, we read the raw CSV file as a data frame. The `read.csv()` function can accept .bz2 files without having to explicitly decompress it. This step is very time-consuming so we will **cache** this code chunk.

```r
# Make sure you have set the working directory by setwd()
raw_data <- read.csv(bzfile("repdata-data-StormData.csv.bz2"), stringsAsFactors = F)
```
As the initial investigation, we look at the dimension and column names.

```r
dim(raw_data)
```

```
## [1] 902297     37
```

```r
names(raw_data)
```

```
##  [1] "STATE__"    "BGN_DATE"   "BGN_TIME"   "TIME_ZONE"  "COUNTY"    
##  [6] "COUNTYNAME" "STATE"      "EVTYPE"     "BGN_RANGE"  "BGN_AZI"   
## [11] "BGN_LOCATI" "END_DATE"   "END_TIME"   "COUNTY_END" "COUNTYENDN"
## [16] "END_RANGE"  "END_AZI"    "END_LOCATI" "LENGTH"     "WIDTH"     
## [21] "F"          "MAG"        "FATALITIES" "INJURIES"   "PROPDMG"   
## [26] "PROPDMGEXP" "CROPDMG"    "CROPDMGEXP" "WFO"        "STATEOFFIC"
## [31] "ZONENAMES"  "LATITUDE"   "LONGITUDE"  "LATITUDE_E" "LONGITUDE_"
## [36] "REMARKS"    "REFNUM"
```
### Subsetting
Since we are interested in the **overall** impact of weather events on population health and economy, regardless of the *year* and *state* in which the events occurred, we will only use the columns of `EVTYPE`, `FATALITIES`, `INJURIES`, `PROPDMG`, `PROPDMGEXP`, `CROPDMG`, and `CROPDMGEXP`.

```r
sub_data <- raw_data[, c("EVTYPE", "FATALITIES", "INJURIES", "PROPDMG", "PROPDMGEXP", "CROPDMG", "CROPDMGEXP")]
```
Then, we subset only those rows whose `FATALITIES`, `INJURIES`, `PROPDMG`, and `CROPDMG` are not all zeros. This results in less than 30% of the original rows.

```r
sub_data <- subset(sub_data, FATALITIES + INJURIES + PROPDMG + CROPDMG > 0)
dim(sub_data)
```

```
## [1] 254633      7
```

### Data Transformations of Numbers
The power-of-10 exponents for property damange and crop damage (`PROPDMGEXP` and `CROPDMGEXP`) are messy, so we need to convert them into numbers (`NUM_PROPDMGEXP` and `NUM_CROPDMGEXP`).

```r
table(sub_data$PROPDMGEXP)
```

```
## 
##             -      +      0      2      3      4      5      6      7 
##  11585      1      5    210      1      1      4     18      3      3 
##      B      h      H      K      m      M 
##     40      1      6 231428      7  11320
```

```r
table(sub_data$CROPDMGEXP)
```

```
## 
##             ?      0      B      k      K      m      M 
## 152664      6     17      7     21  99932      1   1985
```

```r
# numbers (0, 2, 3, 4, 5, 6, 7) -> as is
sub_data <- mutate(sub_data,
                   NUM_PROPDMGEXP = as.numeric(PROPDMGEXP),
                   NUM_CROPDMGEXP = as.numeric(CROPDMGEXP))
```

```
## Warning in mutate_impl(.data, dots): NAs introduced by coercion
```

```
## Warning in mutate_impl(.data, dots): NAs introduced by coercion
```

```r
# ("", -, +, ?) -> 0
sub_data$NUM_PROPDMGEXP[which(sub_data$PROPDMGEXP %in% c("", "+", "-", "?"))] <- 0
sub_data$NUM_CROPDMGEXP[which(sub_data$CROPDMGEXP %in% c("", "+", "-", "?"))] <- 0
# (H, h) -> hundred -> 2
sub_data$NUM_PROPDMGEXP[which(sub_data$PROPDMGEXP %in% c("H", "h"))] <- 2
sub_data$NUM_CROPDMGEXP[which(sub_data$CROPDMGEXP %in% c("H", "h"))] <- 2
# (K, k) -> kilo -> 3
sub_data$NUM_PROPDMGEXP[which(sub_data$PROPDMGEXP %in% c("K", "k"))] <- 3
sub_data$NUM_CROPDMGEXP[which(sub_data$CROPDMGEXP %in% c("K", "k"))] <- 3
# (M, m) -> million -> 6
sub_data$NUM_PROPDMGEXP[which(sub_data$PROPDMGEXP %in% c("M", "m"))] <- 6
sub_data$NUM_CROPDMGEXP[which(sub_data$CROPDMGEXP %in% c("M", "m"))] <- 6
# (B, b) -> billion -> 9
sub_data$NUM_PROPDMGEXP[which(sub_data$PROPDMGEXP %in% c("B", "b"))] <- 9
sub_data$NUM_CROPDMGEXP[which(sub_data$CROPDMGEXP %in% c("B", "b"))] <- 9
```
The numeric power-of-10 exponents after cleaning:

```r
table(sub_data$NUM_PROPDMGEXP, useNA = "always")
```

```
## 
##      0      2      3      4      5      6      7      9   <NA> 
##  11801      8 231429      4     18  11330      3     40      0
```

```r
table(sub_data$NUM_CROPDMGEXP, useNA = "always")
```

```
## 
##      0      3      6      9   <NA> 
## 152687  99953   1986      7      0
```
Convert the property damage and crop damage into actual values:

```r
sub_data <- mutate(sub_data,
                   VAL_PROPDMG = PROPDMG * 10 ^ NUM_PROPDMGEXP,
                   VAL_CROPDMG = CROPDMG * 10 ^ NUM_CROPDMGEXP)
```
Finally, keep only the meaningful columns and drop intermediate calculations.

```r
final_data <- sub_data[, c("EVTYPE", "FATALITIES", "INJURIES", "VAL_PROPDMG", "VAL_CROPDMG")]
```

### Data Transformations of Event Types
There are way numerous unique values in `EVTYPE`.

```r
length(unique(final_data$EVTYPE))
```

```
## [1] 488
```
As a *simple* cleaning on, we will lowercase the letters and replace all the blank and punctuation characters with a space.

* Remark: I know many students on the forum manually categorize the numerous EVTYPEs into much fewer ones, but this will involve too much tedious labeling effort and expertise in weather event definitions, which I think are far *beyond the purpose of this course*.

```r
final_data$EVTYPE <- tolower(final_data$EVTYPE)
final_data$EVTYPE <- gsub("[[:blank:][:punct:]]+", " ", final_data$EVTYPE)
# Trim the beginning and trailing spaces
final_data$EVTYPE <- gsub("^ ", "", final_data$EVTYPE)
final_data$EVTYPE <- gsub(" $", "", final_data$EVTYPE)
length(unique(final_data$EVTYPE))
```

```
## [1] 418
```

## Results
### Question 1: Across the United States, which types of events are most harmful with respect to population health?
Summarize the injuries and fatalities by each type of weather events. Also, melt the data frame for the use of stacked bar plots in {ggplot2}.

```r
topN <- 10
result_health <- mutate(summarize(group_by(final_data, EVTYPE),
                                  injuries = sum(INJURIES),
                                  fatalities = sum(FATALITIES)),
                        fatalities_PLUS_injuries = injuries + fatalities)
result_health <- head(arrange(result_health, desc(fatalities_PLUS_injuries)), topN)
result_health_melt <- melt(result_health[, 1:3], id.vars = "EVTYPE", variable.name = "DamageType", value.name = "count")
```

Show and plot the top 10 weather events that cause the most fatalities or injuries.

```r
print(as.data.frame(result_health))
```

```
##               EVTYPE injuries fatalities fatalities_PLUS_injuries
## 1            tornado    91346       5633                    96979
## 2     excessive heat     6525       1903                     8428
## 3          tstm wind     6957        504                     7461
## 4              flood     6789        470                     7259
## 5          lightning     5230        817                     6047
## 6               heat     2100        937                     3037
## 7        flash flood     1777        978                     2755
## 8          ice storm     1975         89                     2064
## 9  thunderstorm wind     1488        133                     1621
## 10      winter storm     1321        206                     1527
```

```r
ggplot(result_health_melt, aes(x = reorder(EVTYPE, count), y = count, fill = DamageType)) + 
    geom_bar(stat = "identity") + coord_flip() +
    labs(title = "Impact of Weather Events on Population Health",
        x = "Weather Event", y = "Number of Fatalities and Injuries", fill = "Damage Type") +
    theme(text = element_text(size = 14), plot.title = element_text(face = "bold"),
        axis.title.x = element_text(vjust = -0.5), axis.title.y = element_text(vjust = +0.5), 
        title = element_text(vjust = +1.5))
```

![](PA2_files/figure-html/unnamed-chunk-14-1.png) 

**Answer 1: Significantly, tornadoes are the most harmful event to population health. Other harmful events include excessive heat, tstm wind, floods, and lightning.**

### Question 2: Across the United States, which types of events have the greatest economic consequences?
Summarize the property damage and crop damage by each type of weather events. Also, melt the data frame for the use of stacked bar plots in {ggplot2}.

```r
result_econ <- mutate(summarize(group_by(final_data, EVTYPE),
                                property = sum(VAL_PROPDMG),
                                crop = sum(VAL_CROPDMG)),
                      property_PLUS_crop = property + crop)
result_econ <- head(arrange(result_econ, desc(property_PLUS_crop)), topN)
result_econ_melt <- melt(result_econ[, 1:3], id.vars = "EVTYPE", variable.name = "DamageType", value.name = "count")
```

Show and plot the top 10 weather events that cause the most fatalities or injuries.

```r
print(format(as.data.frame(result_econ), digits = 3))
```

```
##               EVTYPE property     crop property_PLUS_crop
## 1              flood 1.45e+11 5.66e+09           1.50e+11
## 2  hurricane typhoon 6.93e+10 2.61e+09           7.19e+10
## 3            tornado 5.69e+10 4.15e+08           5.74e+10
## 4        storm surge 4.33e+10 5.00e+03           4.33e+10
## 5               hail 1.57e+10 3.03e+09           1.88e+10
## 6        flash flood 1.68e+10 1.42e+09           1.82e+10
## 7            drought 1.05e+09 1.40e+10           1.50e+10
## 8          hurricane 1.19e+10 2.74e+09           1.46e+10
## 9        river flood 5.12e+09 5.03e+09           1.01e+10
## 10         ice storm 3.94e+09 5.02e+09           8.97e+09
```

```r
ggplot(result_econ_melt, aes(x = reorder(EVTYPE, count), y = count, fill = DamageType)) +
    geom_bar(stat = "identity") + coord_flip() + 
    labs(title = "Impact of Weather Events on Economy",
        x = "Weather Event", y = "Damage on Property and Crop (US Dollars)", fill = "Damage Type") +
    theme(text = element_text(size = 14), plot.title = element_text(face = "bold"),
          axis.title.x = element_text(vjust = -0.5), axis.title.y = element_text(vjust = +0.5),
          title = element_text(vjust = +1.5))
```

![](PA2_files/figure-html/unnamed-chunk-16-1.png) 

**Answer 2: Significantly, floods cause the greatest economic damage. Other economically damaging events include hurricane typhoons, tornadoes, and storm surge.**

## References
1. NOAA Storm Database (CSV file in bzip2 compression): https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2
2. National Weather Service Storm Data Documentation: https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf
3. National Climatic Data Center Storm Events FAQ: https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2FNCDC%20Storm%20Events-FAQ%20Page.pdf
