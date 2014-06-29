# Input:
#   state: 2-character abbreviated state name
#   outcome: one of "heart attack", "heart failure", or "pneumonia"
# Output:
#   name of the hospital that has the lowest mortality for the specified outcome in that state.

best <- function(state, outcome) {
    ## [1] Read outcome data
    dat <- read.csv("outcome-of-care-measures.csv", colClasses = "character", na.strings="Not Available")
    
    ## [2] Check that state and outcome are valid
    # Use unique(dat[,"State"]) to get the state list:
    #   "AL" "AK" "AZ" "AR" "CA" ... "WA" "WV" "WI" "WY" "GU"
    stateList <- unique(dat[, "State"])
    # If state is not found in stateList, give an error
    if (sum(stateList == state) == 0) {
        stop("invalid state")
    }
    
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
        
    ## [3] Return hospital name in that state with lowest 30-day death rate
    # Subset the important columns
    dat <- dat[dat[,"State"] == state, c("Hospital.Name",col)]
    # Use order() to sort the data frame by columns
    ordered <- dat[order(as.numeric(dat[,col]), dat[,"Hospital.Name"]),]
    ans <- ordered[1,"Hospital.Name"]
}
