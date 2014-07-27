# Input: NONE
# Output: a tidy dataset
# Note: I have re-ordered the steps in the instructions to make things easier
#   ?. -> 0. Read all the data files.
#   4. -> 1. Appropriately labels the data set with descriptive variable names.
#   3. -> 2. Uses descriptive activity names to name the activities in the data set.
#   1. -> 3. Merges the training and the test sets to create one data set.
#   2. -> 4. Extracts only the measurements on the mean and standard deviation for each measurement.
#   5. -> 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

run_analysis <- function() {
    ## 0. Read all the data files.
    message("| 0. Read all the data files")
    message("|-- 1 of 8: reading activity_labels...")
    activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
    message("** done")
    message("|-- 2 of 8: reading features...")
    features <- read.table("UCI HAR Dataset/features.txt")
    message("** done")
    
    message("|-- 3 of 8: reading X_train...")
    X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
    message("** done")
    message("|-- 4 of 8: reading y_train...")
    y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
    message("** done")
    message("|-- 5 of 8: reading subject_train...")
    subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
    message("** done")
    
    message("|-- 6 of 8: reading X_test...")
    X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
    message("** done")
    message("|-- 7 of 8: reading y_test...")
    y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
    message("** done")
    message("|-- 8 of 8: reading subject_test...")
    subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
    message("** done")
    
    ## 1. Appropriately labels the data set with descriptive variable names.
    message("| 1. Appropriately labels the data set with descriptive variable names.")
    names(X_train) <- features[,2]
    names(y_train) <- "activity"
    names(subject_train) <- "subject"    
    names(X_test) <- features[,2]
    names(y_test) <- "activity"
    names(subject_test) <- "subject"
    message("** done")
    
    ## 2. Uses descriptive activity names to name the activities in the data set.
    # Convert y_train and y_test to factors and re-level them using activity_labels
    message("| 2. Uses descriptive activity names to name the activities in the data set.")
    y_train[,] <- as.factor(y_train[,])
    y_test[,] <- as.factor(y_test[,])
    levels(y_train[,]) <- activity_labels$V2
    levels(y_test[,]) <- activity_labels$V2
    
    # Extra thing that I find reasonable:
    #   Convert subject_train and subject_test to factors, too
    subject_train[,] <- as.factor(subject_train[,])
    subject_test[,] <- as.factor(subject_test[,])
    message("** done")

    ## 3. Merges the training and the test sets to create one data set.
    message("| 3. Merges the training and the test sets to create one data set.")
    # Combine 2 cbind() and 1 rbind() in one line to hopefully save memory and time
    merged <- rbind(cbind(X_train, y_train, subject_train), cbind(X_test, y_test, subject_test))
    message("** done")
    
    ## 4. Extracts only the measurements on the mean and standard deviation for each measurement.
    ### NOTE: Be careful with regular expressions!
    ###       There are 13 column names with "meanFreq()" that SHOULD NOT be included.
    ###       So in tidy, there should only be 66 + 2 = 68 instead of 79 + 2 = 81 columns!!
    message("| 4. Extracts only the measurements on the mean and standard deviation for each measurement.")
    extracted <- merged[, c(grep("-mean[(][)]|-std[(][])]", names(merged)), ncol(merged)-1, ncol(merged))]
    message("** done")
    
    ## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    message("| 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.")
    ### NOTE: In tidy, there should be 6 activities * 30 subjects = 180 rows!
    tidy <- aggregate(. ~ activity + subject, data = extracted, mean)
    message("|-- Also exporting the object to \"tidy.txt\" without the row names...")
    write.table(tidy, "tidy.txt", row.names = FALSE)
    message("** done")
    message("| run_analysis() returned a tidy dataset")
    tidy
}
