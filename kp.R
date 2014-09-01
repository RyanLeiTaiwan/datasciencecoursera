# Filename: kp.R
# Description: Demo of data manipulation from a JSON API using R
# Date: 2014/09/02
# Documentation: http://unlimited.kptaipei.tw/docs/

library(jsonlite)
apikey <- "kp53f579798df5b2.60095785"  # Please use your OWN API key!!

# [1] Get article categories (3 so far)
categories <- fromJSON(paste("http://api.kptaipei.tw/v1/category/?accessToken=", apikey, sep = ""))$data

# [2] Get actual articles for each category
catID <- categories$id
articles <- data.frame()  # empty data frame
# newArticles <- fromJSON(paste("http://api.kptaipei.tw/v1/category/", 40, "?accessToken=", apikey, sep = ""))$data
for (id in catID) {
    # Get articles for this category
    newArticles <- fromJSON(paste("http://api.kptaipei.tw/v1/category/", id, "?accessToken=", apikey, sep = ""))$data
    # Keep only certain columns
    newArticles <- newArticles[, c("category_id", "category_name", "post_date", "plain_content")]
    articles <- rbind(articles, newArticles)
}

# [3] Replace $plain_content by the article's length using nchar()
articles$nchar <- nchar(articles$plain_content)
articles$plain_content <- NULL
# Average article length by category
with(articles, tapply(nchar, category_name, mean))

# [4] Convert $post_date to Time (POSIXlt) format
articles$post_date <- strptime(articles$post_date, "%Y-%m-%dT%H:%M:%S.000Z")
# Number of articles by Hour of Day
table(articles$post_date$hour)
hist(articles$post_date$hour, breaks = -0.5:23.5, xlab = "Hour of Day", ylab = "# of Articles")
# Number of articles by Day of Week
table(articles$post_date$wday)
barplot(table(articles$post_date$wday), xlab = "Day of Week", ylab = "# of Articles")

# [5] Plot a time series of article lengths
library(ggplot2)
ggplot(articles, aes(x = post_date, y = nchar, color = category_name)) + geom_point(size = 4) + geom_line()
