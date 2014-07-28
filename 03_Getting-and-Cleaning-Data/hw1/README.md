## Introduction
This repository is for the Programming Assignment of "Getting and Cleaning Data" by Coursera student [RyanLeiTaiwan](https://www.coursera.org/user/i/f5a617a5122f65d7569968c21d0943e6).

In my implementation, there is only one R script named run_analysis.R. I have re-ordered the steps in the instructions to make things easier. The revised steps are as follows:

1. [was 4.] Appropriately labels the data set with descriptive variable names.
2. [was 3.] Uses descriptive activity names to name the activities in the data set.
3. [was 1.] Merges the training and the test sets to create one data set.
4. [was 2.] Extracts only the measurements on the mean and standard deviation for each measurement.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

run_analysis() takes no input parameters, and will return a data frame as the required tiny dataset.

## How to run the program
* Put the run_analysis.R and the dataset zip file (downloaded [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)) in your working directory.
* Extract the zip file in your working directory. There should be a directory "UCI HAR Dataset" containing directories "train" and "test", and files "activity_labels.txt", "features_info.txt", "features.txt", "README.txt".
* Load the R script with source() command.
* In your working directory, run: **tidy <- run_analysis()**.

The program will read the necessary files in "UCI HAR Dataset", perform the cleaning, and export the tidy dataset to the file "tidy.txt". It will also return the same dataset as the data frame object "tidy".

## How to verify the answer
My tidy dataset contains 180 rows and 68 columns as explained by:
* 6 activities * 30 subjects = 180 rows.
  * We are asked to compute the means for all the remaining variables grouped by all {activity, subject} combinations.
* 66 mean-and-std-related variables + 1 activity + 1 subject = 68 columns.
  * NOTE: Be careful with regular expressions! There are 13 column names with "meanFreq()" that SHOULD NOT be included. So in tidy, there should only be 66 instead of 81 columns!!

You can use read.table("tidy.txt", header = TRUE) to read the data and compare with the correct answers.

However, you may only compare numeric and factor values. The variable names and factor levels behave differently when they are read back.
