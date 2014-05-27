## --------------------------------------------------------------------------------------------------------
## Script of commands used for "Getting and Cleaning Data" course project 
## --------------------------------------------------------------------------------------------------------
## Revision History:
##   May 26, 2014, Dhawal Kulkarni - Initial version based on assignment specifications
##
## Contents:
## 1) run_analysis.R - script to prepare tidy data that can be used for later analysis.
##                     The data is collected from the accelerometers inside the Samsung Galaxy S smartphone. 
##                     A full description of the data used is available at the site where the data was obtained: 
##                     http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
##
##                     Data used for the project is from: 
##                     https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
##
##                     The script downloads the data, unzips it, reads pieces of data set from different files and assembles it
##                     to create additional tidy data sets as per project specifications. 
##                         
## Input: 
##   1) activity_labels.txt: List of activity number and corresponding label
##   2) features.txt:        List of number and corresponding name of measures/derived values obtained from the smartphone 
##   3) subject_train.txt:   Subject number corresponding to each training observations
##   4) subject_test.txt:    Subject number corresponding to each test observations
##   5) y_train.txt:         Activity number for each training observation
##   6) y_test.txt:          Activity number for each test observation
##   7) x_train.txt:         Measurement/derived values for each training observation
##   8) x_test.txt:          Measurement/derived values for each test observation
##
## Output:
##   1) combinedData_SubjectActivity.csv:          Tidy data set that combines training and test data 
##   2) combinedData_SubjectActivityMeanStd.csv:   Combined data with only mean and std columns
##   3) combinedAggregateData_SubjectActivity.csv: Mean of combined measurement values for each combination of subject and activity
##
## --------------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------------
# Get the data (note: mode = "wb" required for binary files - excel, images)
# --------------------------------------------------------------------------------------------------------
fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "human_activity_data_set.zip", mode = "wb" )
list.files()

# record date
dateDownloaded = date()
dateDownloaded

# Unzip the file
unzip("human_activity_data_set.zip")
list.files()

# --------------------------------------------------------------------------------------------------------
# Merge the training and the test sets to create one data set.
# --------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------
# Read data common to training and test
# --------------------------------------------------------------------------------------------------------
# Read labels corresponding to each activity number
file.name  <- "UCI HAR Dataset/activity_labels.txt"
activity.ColName <- c("activityNumber", "activityLabel")
activity.Label   <- read.table(file.name, col.names=activity.ColName, header=F)

# Column names for measurement/derived values
file.name            <- "UCI HAR Dataset/features.txt"
measure.ColName      <- c("measureNumber","measureLabel")
values.MeasureLabel  <- read.table(file.name, col.names=measure.ColName, header=F)

# Setup vector to be used for setting measurement/derived value column names for training, test and combined data set
values.ColName       <- t(values.MeasureLabel$measureLabel)

# --------------------------------------------------------------------------------------------------------
# Read training data
# --------------------------------------------------------------------------------------------------------
# Read subject number for each training observation
file.name  <- "UCI HAR Dataset/train/subject_train.txt"
subject.ColName   <- c("subjectNumber")
trainingObservation.SubjectNumber <- read.table(file.name, col.names=subject.ColName, header=F)

# Read activity number for each training observation
file.name          <- "UCI HAR Dataset/train/y_train.txt"
activity.ColName   <- c("activityNumber")
trainingObservation.ActivityNumber <- read.table(file.name, col.names=activity.ColName, header=F)

# Read measurement/derived values for each training observation
file.name        <- "UCI HAR Dataset/train/x_train.txt"
values.Training  <- read.table(file.name, col.names=values.ColName, header=F)

# --------------------------------------------------------------------------------------------------------
# Read test data
# --------------------------------------------------------------------------------------------------------

# Read subject number for each test observation
file.name  <- "UCI HAR Dataset/test/subject_test.txt"
testObservation.SubjectNumber <- read.table(file.name, col.names=subject.ColName, header=F)

# Read activity number of each test observation
file.name  <- "UCI HAR Dataset/test/y_test.txt"
testObservation.ActivityNumber <- read.table(file.name, col.names=activity.ColName, header=F)

# Read measurement and derived values for each test observation
file.name  <- "UCI HAR Dataset/test/x_test.txt"
values.Test <- read.table(file.name, col.names=values.ColName, header=F)

# --------------------------------------------------------------------------------------------------------
# Combine training and test data into following form: (SubjectNumber, ActivityNumber, ActivityLabel, Values)
# --------------------------------------------------------------------------------------------------------
# combine rows
combinedValues                     <- rbind(values.Training, values.Test)
combinedObservation.SubjectNumber  <- rbind(trainingObservation.SubjectNumber, testObservation.SubjectNumber)
combinedObservation.ActivityNumber <- rbind(trainingObservation.ActivityNumber, testObservation.ActivityNumber)

# Merge the data on activity number
combinedObservation.Activity = merge(combinedObservation.ActivityNumber,activity.Label,by.x="activityNumber",by.y="activityNumber", all=FALSE)

# combine columns
combinedData.SubjectActivity <- cbind(combinedObservation.SubjectNumber, combinedObservation.Activity, combinedValues)

# Save data set to a file
write.table(combinedData.SubjectActivity, file = "combinedData_SubjectActivity.csv", sep = ",", col.names = TRUE, row.names = FALSE, qmethod = "double")

# --------------------------------------------------------------------------------------------------------
# Create a subset with only mean and std measurement columns for each subject and activity combination
#
# Since the goal of this effort is to create tidy data for future analysis and the nature of analysis
# is not known, ALL mean and std measurements have been included
# --------------------------------------------------------------------------------------------------------
# Prepare vector to select only columns that have mean and std values in them
measureLabel.Mean.Std  <- subset(values.MeasureLabel,grepl("-mean()",measureLabel,fixed=TRUE) | grepl("-std()",measureLabel,fixed=TRUE))
measureNumber.Mean.Std <- measureLabel.Mean.Std$measureNumber 

# New Data Set with only values for "-mean()" and "-std()" measures
combinedValues.Mean.Std <- combinedValues[,measureNumber.Mean.Std]

# Create new combined data set with only values for "-mean()" and "-std()" measures
combinedData.SubjectActivityMeanStd <- cbind(combinedObservation.SubjectNumber, combinedObservation.Activity, combinedValues.Mean.Std)

# Save data set to a file
write.table(combinedData.SubjectActivityMeanStd, file = "combinedData_SubjectActivityMeanStd.csv", sep = ",", col.names = TRUE, row.names = FALSE, qmethod = "double")

# --------------------------------------------------------------------------------------------------------
# Create aggregate dataset with average of each measure for each subject activity combination
# --------------------------------------------------------------------------------------------------------
maxCol <- dim(combinedData.SubjectActivity)[2]
combinedAggregateData.SubjectActivity <- aggregate(combinedData.SubjectActivity[,4:maxCol], list(combinedData.SubjectActivity[,1],combinedData.SubjectActivity[,2],combinedData.SubjectActivity[,3]), FUN=mean)

# Save data set to a file
write.table(combinedAggregateData.SubjectActivity, file = "combinedAggregateData_SubjectActivity.csv", sep = ",", col.names = TRUE, row.names = FALSE, qmethod = "double")

# --------------------------------------------------------------------------------------------------------
# Clean up the memory and close
# --------------------------------------------------------------------------------------------------------
rm(list=ls())
q()
n
# ============================================================================================================================