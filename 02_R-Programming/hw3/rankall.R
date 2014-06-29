## Note: I'm trying NOT to use any for loops in this assignment.

# Input:
#   outcome: one of "heart attack", "heart failure", or "pneumonia"
#   num: ranking of a hospital in EACH state for that outcome
# Output:
#   2-column data frame containing the hospital in each state that has the ranking specified in num

rankall <- function(outcome, num = "best") {
    ## [1] Read outcome data
    dat <- read.csv("outcome-of-care-measures.csv", colClasses = "character", na.strings="Not Available")
    
    ## [2] Check that outcome is valid    
    # Convert outcome input to column name in dat
    col <- NULL
    if (outcome == "heart attack") {
        col <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"  # col 11
    }
    else if (outcome == "heart failure") {
        col <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"  # col 17
    }
    else if (outcome == "pneumonia") {
        col <- "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"  # col 23
    }
    else {
        stop("invalid outcome")
    }    
    
    ## [3] For each state, find the hospital of the given rank
    # Split the data frame by state and subset the important columns
    # sp: a "list" of data frames
    sp <- split(dat[, c("Hospital.Name",col)], dat$State)
    # Use lapply() to perform ordering and find the hospital by rank "num"
    # for each data frame in sp
    hospitals <- lapply(sp, orderAndFindByRank, col, num)
    
    ## [4] Return a data frame with the hospital names and the (abbreviated) state name
    states <- names(hospitals)  # vector of states
    hospitals <- unname(unlist(hospitals))  # vector of hospital names
    # cbind(vector of hospital names, vector of states) => convert into data frame
    ans <- as.data.frame(cbind(hospitals, states))
    # Adjust the col names and row names
    colnames(ans) <- c("hospital", "state")
    rownames(ans) <- states    
    ans
}

# Order a data frame by col (outcome), and answer the hospital name at rank "num"
orderAndFindByRank <- function(df, col, num) {
    ordered <- df[order(as.numeric(df[,col]), df[,"Hospital.Name"]),]
    
    hospital <- NULL
    if (num == "best") {
        hospital <- ordered[1, "Hospital.Name"]
    } else if (num == "worst") {
        hospital <- ordered[sum(!is.na(ordered[,col])), "Hospital.Name"]
    } else if (num >= 1 & num <= sum(!is.na(ordered[,col]))) {
        hospital <- ordered[num, "Hospital.Name"]
    } else {
        hospital <- NA
    }
    hospital
}
