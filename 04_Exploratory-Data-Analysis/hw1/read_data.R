## File: read_data.R
## Input: NONE
## Output: subset of the dataset from dates 2007-02-01 and 2007-02-02
## Description:
##   [1] Read and subset the dataset to be 2880 rows and 9 columns.
##   This script is called by plot*.R.
##   Please make sure the filename variable is set correctly.

read_data <- function() {
    filename <- "household_power_consumption.txt"
    # Even though nrows = 1, I'll only use the header (names)
    header <- read.table(filename, header = T, sep = ";", nrows = 1)
    # Specifying colClasses will save memory
    colClasses <- c(rep("character", 2), rep("numeric", 7))

    ## I have noticed several ways of reading and subsetting the data from
    ## the course forum in July, 2014. I will try to implement all of them.

    ## I define the method variable to be one of the 5 reading methods.
    ## If the current method fails on your system environment, change it to another factor value and try again.
    ## My system: Mac OS X 10.9.4, 16 GB RAM, 256 GB SSD.
    method = factor("CHEAT",
                     levels = c("CHEAT", "FREAD", "PIPE", "SQLDF", "NORMAL"))
    message(paste("|-- method =", method))

    ## method name is NA
    if (is.na(method)) {
        message("Possible reading method:")
        print(levels(method))
        stop("Invalid reading method. You should set 'method' as one of them.")
    }


    ## [method 1, cheating] Count the EXACT number of rows to skip and to read: 0.59 sec
    # This is not smart, but I list it as method 1 for the sake of easy grading:
    #   a. It has the least platform compatibility issues.
    #   b. It does not require additional packages.
    #   c. It runs very fast.
    # But you are encouraged to try other methods if you are interested.
    else if (method == "CHEAT") {
        dat <- read.table(filename, header = F, sep = ";", colClasses = colClasses, na.strings = "?", skip = 66637, nrows = 2880)
        names(dat) <- names(header)
    }

    ## [method 2] fread() in {data.table} package: 1.31 sec
    else if (method == "FREAD") {
        library(data.table)
        dat <- fread(filename, sep = ";", colClasses = "character", na.strings = "?")
        dat <- dat[grep("^[1-2]/2/2007",dat$Date),]

        # Convert the classes using the data table way
        # IMPORTANT: data table cannot accept POSIXlt values, so we need to explicitly convert to POSIXct.
        # See http://stackoverflow.com/questions/21487614/error-creating-r-data-table-with-date-time-posixlt
        dat[, Time := as.POSIXct(strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S"))]
        dat[, Date := as.Date(Date, "%d/%m/%Y")]

        dat[, Global_active_power := as.numeric(Global_active_power)]
        dat[, Global_reactive_power := as.numeric(Global_reactive_power)]
        dat[, Voltage := as.numeric(Voltage)]
        dat[, Global_intensity := as.numeric(Global_intensity)]
        dat[, Sub_metering_1 := as.numeric(Sub_metering_1)]
        dat[, Sub_metering_2 := as.numeric(Sub_metering_2)]
        dat[, Sub_metering_3 := as.numeric(Sub_metering_3)]
    }

    ## [method 3] pipe + UNIX grep (This will FAIL on Windows!!): 2.35 sec
    # I have skipped converting the NA symbols since there aren't any in the subset.
    else if (method == "PIPE") {
        conn <- pipe(paste("grep ^[1-2]/2/2007 ", filename))
        dat <- read.table(conn, header = F, sep = ";", colClasses = colClasses, na.strings = "?")
        # The connection is closed automatically after read.table(), so we shouldn't
        # manually call close(conn).
        names(dat) <- names(header)
    }

    ## [method 4] read.csv.sql() in {sqldf} package: 36 sec
    # VERY SLOW on Mac!! And even HANG on Windows!!!
    # I have skipped converting the NA symbols since there aren't any in the subset.
    else if (method == "SQLDF") {
        library(sqldf)
        dat <- read.csv2.sql(filename, "SELECT * FROM file WHERE Date = '1/2/2007' OR Date = '2/2/2007'")
    }

    ## [reference] normal read.table: 23 sec
    else if (method == "NORMAL") {
        dat <- read.table(filename, header = T, sep = ";", colClasses = colClasses, na.strings = "?")
        dat <- dat[grep("^[1-2]/2/2007",dat$Date),]
    }

    ## Invalid method name
    else {
        message("Possible reading method:")
        print(levels(method))
        stop("Invalid reading method. You should set 'method' as one of them.")
    }

    # Finally, convert the Date and Time variables to corresponding R classes
    # Don't convert for FREAD method because it's already done using the data table way.
    if (method != "FREAD") {
        dat$Time <- strptime(paste(dat$Date, dat$Time), "%d/%m/%Y %H:%M:%S")
        dat$Date <- as.Date(dat$Date, "%d/%m/%Y")
    }

    # Return the subset from dates 2007-02-01 and 2007-02-02
    dat
}
