## This R script is part of a project in the Coursera "Getting and cleaning data" course.
## The data for the assignment was originally obtained from:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## The following assumptions are made:
## 1. This script ("run_analysis.R") is downloaded to your working directory.
## 2. The project data is downloaded from the following address
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## 3. The data is unzipped to your working directory ("./UCI HAR Dataset/").
## 4. NB This script depends on the package "dplyr" by Hadley Wickham. If needed,
# run the following code in the console before sourcing the script:
# install.packages("dplyr")
# source("run_analysis.R")

## Load required package "dplyr".
require(dplyr)

## Read files and create data frames.
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./UCI HAR Dataset/features.txt")
activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

## Merge test and training sets (first step with separate variables for data, activities and subjects).
mergeddata <- rbind(Xtrain,Xtest)
mergedactivity <- rbind(ytrain,ytest)
mergedsubjects <- rbind(subjecttrain,subjecttest)

## Extract only the measurements on the mean ("-mean()") and standard deviation ("-std()") for each measurement.
featuresmeanstd <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
mergeddatameanstd <- mergeddata[,featuresmeanstd]

## Use descriptive activity names to name the activities in the data set.
mergedactivity[,1]  <- activitylabels[mergedactivity[,1],2]

## Appropriately label the data set with descriptive variable names. 
names(mergeddatameanstd) <- features[featuresmeanstd,2]
names(mergedactivity) <- "activity"
names(mergedsubjects) <- "subject"

## Final merge to create one large data set (second step).
final <- cbind(mergedsubjects,mergedactivity,mergeddatameanstd)

## Create a second, independent tidy data set with the average of
## each variable for each activity and each subject (requires package "dplyr").

tidy <- final %>%
        group_by(subject, activity) %>%
        summarise_each(funs(mean))

## Save the tidy data set with average data to a txt file.
write.table(tidy, file="tidy.txt", row.names = FALSE)

## To read the data back into R for viewing, use the commands:
# tidy <- read.table("tidy.txt", header = TRUE)
# View(tidy)
## Credit to David Hood, especially for this last tip
# (https://class.coursera.org/getdata-031/forum/thread?thread_id=28)
