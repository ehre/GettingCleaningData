#Getting and Cleaning Data
Course Project for the Coursera/Johns Hopkins University "Getting and Cleaning Data" course.

##Introduction
In this course project, the assignment was to download a copy of [**the  Human Activity Recognition Using Smartphones Data Set**  from the UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones), and from the raw data produce an independent, tidy data set according to the project instructions.

## Repository content
1. **README.md** - this file!
2. **run_analysis.R** - R script that performs the assignment
3. **CodeBook.md** - A code book that explains all variables and transformations.
4. **tidy.txt** - the output file from run_analysis.R

## About run_analysis.R
Briefly, the R script called **run_analysis.R** does the following:

 1. Merges the training and the test sets to create one data set.
 2. Extracts only the measurements on the mean and standard deviation for each measurement.
 3. Uses descriptive activity names to name the activities in the data set.
 4. Appropriately labels the data set with descriptive variable names.
 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Further details can be found in **CodeBook.md** and in the inline comments of **run_analysis.R**

##Requirements
The following assumptions are made:

 1. The script ("**run_analysis.R**") is downloaded to your working directory.
 2. The project data is downloaded from the following address https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
 3. The data is unzipped to your working directory ("./UCI HAR Dataset/").
 4. Please note that this script depends on the package "dplyr" by Hadley Wickham. If needed, add the first line of code below in the console before sourcing the script:

```
install.packages("dplyr")
source("run_analysis.R")
```

## Examining the output file
To examine the output in "tidy.txt", I would recommend to use RStudio, and enter the following commands in the console:

```
tidy <- read.table("tidy.txt", header = TRUE)
View(tidy)
```

## Credits
David Hood was most helpful in the Coursera forum, please see his [detailed FAQ for the course project](https://class.coursera.org/getdata-031/forum/thread?thread_id=28%29).