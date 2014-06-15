complete <- function(directory, id = 1:332) {
    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'id' is an integer vector indicating the monitor ID numbers
    ## to be used
    
    ## Return a data frame of the form:
    ## id nobs
    ## 1  117
    ## 2  1041
    ## ...
    ## where 'id' is the monitor ID number and 'nobs' is the
    ## number of complete cases
    
    # [1] Create an empty data frame for answer with column names specified.
    ans <- data.frame(id = numeric(0), nobs = numeric(0))
    
    # [2] Read the files one by one, and append the answer.
    for (fid in id) {        
        filename <- sprintf("%s/%03d.csv", directory, fid)
        dat <- read.csv(filename)
        ans <- rbind(ans, data.frame(id = fid, nobs = sum(complete.cases(dat))))
    }
    ans
}