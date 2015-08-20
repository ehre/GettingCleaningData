# CodeBook
This code book describes the variables, the data, and the transformations and work performed to clean up the data in the Coursera course project "Getting and Cleaning Data".
## The original data set
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained, [the Human Activity Recognition Using Smartphones Data Set (UCI Machine Learning Repository).](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones )

I refer to the web page and the files "README.txt" and "features_info.txt" in the UCI HAR data set for a full description of the original data.

In summary, the experiments have been carried out with a group of 30 volunteers. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix **'t'** to denote time) were captured and filtered. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ). 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the **'f'** to indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for each pattern, resulting in a 561-feature vector with time and frequency domain variables.

## Transformations of the data set
Since the data had been partioned into a training set and a data set, the data files were first read into R individually. The 561 feature vector data is located in "./UCI HAR Dataset/train/X_train.txt" and "./UCI HAR Dataset/test/X_test.txt". Similarly, the data on activities and subjects are found in "y_train.txt", "y_test.txt", "subject_train.txt" and "subject_test.txt". The description of features and activities are located in "features.txt" and "activity_labels.txt", respectively.
```
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./UCI HAR Dataset/features.txt")
activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
```
The data, activity and subjects were intitially merged into separate data frames, all with 10299 rows.
```
mergeddata <- rbind(Xtrain,Xtest)
mergedactivity <- rbind(ytrain,ytest)
mergedsubjects <- rbind(subjecttrain,subjecttest)
```
Next, only the measurements on mean and standard deviation for each feature were extracted. **Only variable names containing "-mean()" or "-std()" were included**, since it was explicitly stated in "features_info.txt" that this represented values estimated from the signals. Other variables containing "mean" were therefore excluded. This resulted in reducing the data from 561 to 66 features (variables).
```
featuresmeanstd <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
mergeddatameanstd <- mergeddata[,featuresmeanstd]
```
To name the activities with descriptive activity names, the names from the file "activity_labels.txt" (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) were applied on the corresponding activity number.
```
mergedactivity[,1]  <- activitylabels[mergedactivity[,1],2]
```
To appropriately label the data set with decriptive variable names, the naming convention in the file "features.txt" was kept and applied to the respective columns in the merged data. There has been a discussion on the Coursera forums whether this assignment includes "cleaning" the variable names further, for instance removing parentheses and changing all names to lower case. **I decided not to do any further manipulation on the variable names**, because keeping the original names makes it easier to go back to the UCI HAR dataset and compare.
The variable containing information on activities and subjects were labelled "activity" and subject", respectively.
```
names(mergeddatameanstd) <- features[featuresmeanstd,2]
names(mergedactivity) <- "activity"
names(mergedsubjects) <- "subject"
```
To create one final large merged dataset, the data frames for subjects, activities and data were merged.
```
final <- cbind(mergedsubjects,mergedactivity,mergeddatameanstd)
```
To create a second, independent tidy data set with the average of each variable for each subject and each activity, I decided to use the package "dplyr", `require(dplyr)`.
```
tidy <- final %>%
        group_by(subject, activity) %>%
        summarise_each(funs(mean))
```

This results in a 180x68 data frame. The 180 rows are constructed from the 6 activities recorded for each of the 30 subjects. The 68 columns are the variables "subject", "activity" and the 66 features containing the calculated average per activity and subject. This represents tidy data in the "wide" format.

The tidy data set with average data was then saved to a txt file.
```
write.table(tidy, file="tidy.txt", row.names = FALSE)
```
## Variables in the tidy data set

####Excerpt from "tidy.txt":

| subject | activity | tBodyAcc-mean()-X | ...|
|---------|----------|-------------------|----|
|     1   | LAYING   |     0.2215982     | ...|
|   ...   |   ...    |        ...        | ...|

- **Variable 1, subject**:
An integer variable 1:30, representing the 30 subjects in the trial.

- **Variable 2, activity**:
A factor variable with six levels, containing descriptive names for the 6 activities recorded for each subject (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING))

- **Variable 3:68, features**:
66 numeric variables, where all features are normalized and bounded within [-1,1]. As described above, each entry represents the average of multiple measurements per subject and activity. 
The variable names, eg **tBodyAcc-mean()-X**, have the following naming convention:
1. The names all start with "t" (="time domain signal") or "f" (="frequency domain signal").
2. Then, the vector is described, for instance "BodyAcc" stands for "Body Acceleration Signal". For a full description of all abbreviations, see the file "features_info.txt" in the original UCI HAR data set.
3. Then, information on whether the variable contains the mean value "-mean()" or the standard deviation "-mean()" for the vector.
4. Finally, for variables that end in "-X", "-Y" or "-Z", this indicates the dimension on the X, Y or Z axis.
