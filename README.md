# Coursera project for "Getting and Cleaning Data" course.
 
## Project objective: 
  To prepare tidy data that can be used for later analysis.

  The data is collected from the accelerometers inside the Samsung Galaxy S smartphone. 
  A full description of the data used is available at [UCI Machine Learning Repository site](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) from where the data was obtained. 

  Data used for the project is from: [UCI Machine Learning Repository Data Folder](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
   
### Script files:
  * run_analysis.r  - downloads the data, unzips it, reads pieces of data set from different files and assembles it to create additional tidy data sets as per project specifications. 
                         
### Input data files: 
  * activity_labels.txt: List of activity number and corresponding label
  * features.txt:        List of number and corresponding name of measures/derived values obtained from the smartphone 
  * subject_train.txt:   Subject number corresponding to each training observations
  * subject_test.txt:    Subject number corresponding to each test observations
  * y_train.txt:         Activity number for each training observation
  * y_test.txt:          Activity number for each test observation
  * x_train.txt:         Measurement/derived values for each training observation
  * x_test.txt:          Measurement/derived values for each test observation

### Output files:
  * combinedData_SubjectActivity.csv:          Tidy data set that combines training and test data 
  * combinedData_SubjectActivityMeanStd.csv:   Combined data with only mean and std columns
  * combinedAggregateData_SubjectActivity.csv: Mean of combined measurement values for each combination of subject and activity

### Notes:
  1. Used mode = "wb" for downloading the files guessing that the zip file should be treated as binary files. 
	2. Used the features.txt file to create column headings of the data frame as the number of columns was too large for manually setting them.
	3. Since the goal of this effort is to create tidy data for future analysis and the nature of analysis is not known, ALL mean and std measurements have been included.
	4. Tried to make the script generalized by calculating maximum column number before using it in aggregate function
	
