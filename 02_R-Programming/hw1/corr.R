corr <- function(directory, threshold = 0) {
    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'threshold' is a numeric vector of length 1 indicating the
    ## number of completely observed observations (on all
    ## variables) required to compute the correlation between
    ## nitrate and sulfate; the default is 0
    
    ## Return a numeric vector of correlations
    
    # [1] Create an empty numeric vector for answer.
    ans <- c(numeric(0))
    
    # [2] Read the files one by one, and append the answer.
    id <- 1:332  # for convenience
    for (fid in id) {
        filename <- sprintf("%s/%03d.csv", directory, fid)
        dat <- read.csv(filename)
        
        # [3] Keep only the complete cases.
        dat.complete <- dat[complete.cases(dat),]
        
        # [4] If number of complete cases > threshold, compute the correlation,
        #     and append the value in answer.
        if (nrow(dat.complete) > threshold) {
            ans <- c(ans, cor(dat.complete$sulfate, dat.complete$nitrate))
        }
    }
    ans
}