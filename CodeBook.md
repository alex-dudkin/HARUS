#The code book
describes the variables, the data, and any transformations
or work that were performed to clean up the data

##Variables
The run_analysis.R script contains the global variables
that specify default location of the Samsung dataset:

g_datadir <- "UCI HAR Dataset"          
- directory of the dataset.
The directory is created automatically as you unpack the Samsung archive into you working directory.

g_dirs2merge <- c("test","train") 
- subdirectories inside the dataset directory.
The subdirectories are created automatically as you unpack the Samsung archive.

g_mergedir <- "merged"
- the run_analysis.R script will create the directory inside your working directory.
The merged files will be put in there.


##Main Functions
- are executed automatically as you type in R console:
source("run_analysis.R")

SaveDataSet1()
- copies directory structure from the Samsung dataset into "merged" directory,
merges datafiles from "test" and "train" subdirectories and put the merged datafiles
into "merged" directory.



The following functions will create "DataSet?.txt" files contain the data
and "DataSetFeature?.txt" files contain the columns list.

SaveDataSet2()
- Extracts only the measurements on the mean and standard deviation for each measurement,
reads "X_merged.txt" and "features.txt" files,
selects "-mean()" and "-std()" columns from the dataset.

SaveDataSet3()
- Uses descriptive activity names to name the activities in the data set.
Reads "X_merged.txt", "y_merged.txt" and "activity_labels.txt" files, 
appends "ActivityCode" and "Activity" columns to dataset.

SaveDataSet4()
- Appropriately labels the data set with descriptive variable names.
Reads "X_merged.txt", "y_merged.txt" and "activity_labels.txt", "features.txt" files, 
translates the columns names into human readable,
appends "SubjectCode", "ActivityCode" and "Activity" columns to dataset.

SaveDataSet5()
- From the data set in step 4, creates a second, independent tidy data set
with the average of each variable for each activity and each subject.
Reads "DataSet4.txt" file,
evaluates "mean" values of all columns grouping by SubjectCode and Activity.
