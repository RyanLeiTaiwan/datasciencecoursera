pollutantmean <- function(directory, pollutant, id = 1:332) {
    ## 'directory' is a character vector of length 1 indicating
    ## the location of the CSV files
    
    ## 'pollutant' is a character vector of length 1 indicating
    ## the name of the pollutant for which we will calculate the
    ## mean; either "sulfate" or "nitrate".
    
    ## 'id' is an integer vector indicating the monitor ID numbers
    ## to be used
    
    ## Return the mean of the pollutant across all monitors list
    ## in the 'id' vector (ignoring NA values)

    # [1] Read the files one by one, and append into a single data frame.
    dat <- data.frame()
    for (fid in id) {
        filename <- sprintf("%s/%03d.csv", directory, fid)
        dat <- rbind(dat, read.csv(filename))
    }
    
    # [2] Return the mean, ignoring NA values.
    mean(dat[[pollutant]], na.rm = TRUE)  # cannot use $ with variables
}