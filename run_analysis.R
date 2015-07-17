library(data.table)

g_datadir <- "UCI HAR Dataset"
g_dirs2merge <- c("test","train")
g_mergedir <- "merged"




# TASK 1
# Merges the training and the test sets to create one data set.

SaveDataSet1 <- function() {  
        #merge files from g_dirs2merge and save to g_mergedir 
        
        #dirs to merge
        dir1 <- paste0(g_datadir, "/", g_dirs2merge[1])
        dir2 <- paste0(g_datadir, "/", g_dirs2merge[2])
        
        #check if source data directories exist
        if (!file.exists(dir1)) {
                stop(paste("Directory is absent:", dir1))
        }
        if (!file.exists(dir2)) {
                stop(paste("Directory is absent:", dir2))
        }
        
        #create destination directories structure
        for (d1 in list.dirs(dir1, full.names = FALSE, recursive = TRUE)) {
                dir.create(
                        paste0(g_mergedir,"/",d1)
                        ,recursive = TRUE, showWarnings = FALSE
                )
        }
        
        # fname1 = filename 1 to merge
        for (fname1 in list.files(dir1, full.names = FALSE, recursive = TRUE)) {                    
                
                # fname2 = filename 2 to merge
                fname2 <- sub(
                        paste0(g_dirs2merge[1],"\\.txt$")
                        ,paste0(g_dirs2merge[2],".txt")
                        ,fname1
                )    
                
                # fname3 = merged filename 
                fname3 <- sub(
                        paste0(g_dirs2merge[1],"\\.txt$")
                        ,paste0(g_mergedir,".txt")
                        ,fname1
                )         
                
                #get merged data
                merged_df <- MergeFiles(
                        paste0(dir1, "/", fname1)
                        ,paste0(dir2, "/", fname2)
                )
                
                #write merged data to file
                #message(paste0(g_mergedir,"/", fname3))
                write.table(
                        merged_df
                        ,file = paste0(g_mergedir,"/", fname3)
                        ,row.names = FALSE, col.names = FALSE
                )
        }
        
        
}  

MergeFiles <- function(file1, file2) {
        #returns data.frame
        
        df1 <- read.table(file1, stringsAsFactors = FALSE)
        df2 <- read.table(file2, stringsAsFactors = FALSE)
        rbind(df1, df2)
}




# TASK 2
# Extracts only the measurements on the mean and standard deviation for each measurement.

SaveDataSet2 <- function() { 
        #saves mean and std variables to file
        
        extract_dt <- DataSet2()
        write.table(
                extract_dt
                ,file = paste0(g_mergedir,"/DataSet2.txt")
                ,row.names = FALSE, col.names = FALSE
        )
        SaveDataSetFeatures2()
}

SaveDataSetFeatures2 <- function() {
        varnames_dt <- MeanStdVarNames()
        feat_dt <- cbind(as.data.table(rownames(varnames_dt)), varnames_dt[,varname])
        write.table(
                feat_dt
                ,file = paste0(g_mergedir,"/DataSetFeatures2.txt")
                ,row.names = FALSE, col.names = FALSE, quote = FALSE
        )
}

DataSet2 <- function() {
        #returns data.table with mean and std variables
        
        merged_df <- read.table(
                paste0(g_mergedir,"/X_merged.txt")
                ,stringsAsFactors = FALSE
        )
        
        #extract only ..-mean() and ..-std() variables 
        
        varnames_dt <- MeanStdVarNames()
        merged_dt1 <- as.data.table(merged_df[,varnames_dt$varcode])
        merged_dt1
}

MeanStdVarNames <- function() {
        #filter variables list, keep Mean and Std variables only, returns data.table
        
        varnames_df <- read.table(
                paste0(g_datadir,"/features.txt")
                ,col.names = c("varcode", "varname"))
        
        #extract only mean() and std() variables
        
        as.data.table(
                varnames_df[grep("mean\\(\\)$|std\\(\\)$", varnames_df[,2]),]
        )
}





# TASK 3
# Uses descriptive activity names to name the activities in the data set

SaveDataSet3 <- function() { 
        #saves mean and std and activity variables to file
        
        activity_dt <- DataSet3()
        write.table(
                activity_dt
                ,file = paste0(g_mergedir,"/DataSet3.txt")
                ,row.names = FALSE, col.names = FALSE
        )
        SaveDataSetFeatures3()
}

SaveDataSetFeatures3 <- function() {
        varnames_dt <- MeanStdVarNames()
        varnames_dt <- rbind(
                varnames_dt
                ,data.table(
                        varcode=nrow(varnames_dt)+1:2
                        ,varname=c("ActivityCode","Activity")
                ))
        feat_dt <- cbind(as.data.table(rownames(varnames_dt)), varnames_dt[,varname])
        
        write.table(
                feat_dt
                ,file = paste0(g_mergedir,"/DataSetFeatures3.txt")
                ,row.names = FALSE, col.names = FALSE, quote = FALSE
        )
}


DataSet3 <- function() {
        #returns data.table of mean, std and activity columns
        
        activity_dt <- DataSet2()
        
        #add ActivityCode and Activity columns
        
        cbind(activity_dt, DescriptiveActivityColumn())
}

DescriptiveActivityColumn <- function() {
        #returns activity data.table with descriptive activity names
        
        activity_label_dt <- as.data.table(read.table(
                paste0(g_datadir,"/activity_labels.txt")
                ,col.names = c("LabelActivityCode","LabelActivity")
        ))
        
        activity_dt <- as.data.table(read.table(
                paste0(g_mergedir,"/y_merged.txt")
                ,col.names = "ActivityCode"
        ))
        
        #return data.table with ActivityCode and Activity columns
        
        activity_dt[,
                Activity:=activity_label_dt[
                        LabelActivityCode==ActivityCode, LabelActivity
                ]
        ]
        #uncomment if ActivityCode column doesn't needed:
        #activity_dt2 <- activity_dt1[,.(Activity)]
} 



# TASK 4         
# Appropriately labels the data set with descriptive variable names. 

SaveDataSet4 <- function() {
        #write descriptively labeled table to file
        
        label_dt <- DataSet4()
        write.table(
                label_dt
                ,file = paste0(g_mergedir,"/DataSet4.txt")
                ,row.names = FALSE, col.names = TRUE
        )
        SaveDataSetFeatures4(label_dt)
}
        

SaveDataSetFeatures4 <- function(label_dt) {
        #write dataset features file
        
        feat_dt <- data.table(1:length(colnames(label_dt)), colnames(label_dt))
        write.table(
                feat_dt
                ,file = paste0(g_mergedir,"/DataSetFeatures4.txt")
                ,row.names = FALSE, col.names = FALSE, quote = FALSE
        )
}


DataSet4 <- function() {
        #returns data.table with descriptive varnames and activity and subject columns
        
        merged_df <- read.table(
                paste0(g_mergedir,"/X_merged.txt")
                ,stringsAsFactors = FALSE
        )
        
        #extract only ..-mean() and ..-std() variables with descriptive names 
        
        varnames_dt <- DescriptiveVarNames()
        label_dt1 <- as.data.table(merged_df[,varnames_dt$varcode])
        setnames(label_dt1, varnames_dt$LongVarName)
        
        #add ActivityCode and Activity columns
        
        label_dt2 <- cbind(label_dt1, DescriptiveActivityColumn())
        
        #add SubjectCode column
        
        label_dt2 <- cbind(label_dt2, SubjectCodeColumn())
        label_dt2
}


DescriptiveVarNames <- function() {
        #extract and descriptive translate only mean() and std() variables, returns data.table
        varnames__1 <- MeanStdVarNames()

        sub_dt <- data.table()
        sub_dt <- rbind(sub_dt, data.table(pattern="-mean\\(\\)", replacement="Mean"))
        sub_dt <- rbind(sub_dt, data.table(pattern="-std\\(\\)", replacement="Std"))
        sub_dt <- rbind(sub_dt, data.table(pattern="^t", replacement="Time"))
        sub_dt <- rbind(sub_dt, data.table(pattern="^f", replacement="Frequency"))
        sub_dt <- rbind(sub_dt, data.table(pattern="Acc", replacement="Acceleration"))
        sub_dt <- rbind(sub_dt, data.table(pattern="Gyro", replacement="Gyroscope"))
        sub_dt <- rbind(sub_dt, data.table(pattern="Mag", replacement="Magnitude"))

        #add column to store translated varname
        varnames__1[, LongVarName:=varname]
        
        #get the variable name descriptive
        mapply(function(x, y) {
                varnames__1[, LongVarName:=sub(x, y, varnames__1$LongVarName)]
        }, sub_dt$pattern, sub_dt$replacement)
        
        varnames__1
}



SubjectCodeColumn <- function() {
        #return data.table with SubjectCode column
        subject_dt <- as.data.table(read.table(
                paste0(g_mergedir,"/subject_merged.txt")
                ,col.names = "SubjectCode"))
} 


# TASK 5
# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

SaveDataSet5 <- function() {
        #write tidy dataset to file
        
        tidy_dt <- DataSet5()
        write.table(
                tidy_dt
                ,file = paste0(g_mergedir,"/DataSet5.txt")
                ,row.names = FALSE, col.names = TRUE
        )
        SaveDataSetFeatures5(tidy_dt)

        write.table(
                tidy_dt
                ,row.names = FALSE, col.names = TRUE
        )
        
}


SaveDataSetFeatures5 <- function(tidy_dt) {
        #write dataset features file
        
        feat_dt <- data.table(1:length(colnames(tidy_dt)), colnames(tidy_dt))
        write.table(
                feat_dt
                ,file = paste0(g_mergedir,"/DataSetFeatures5.txt")
                ,row.names = FALSE, col.names = FALSE, quote = FALSE
        )
}

DataSet5 <- function() {
        dt4 <- as.data.table(read.table(
                paste0(g_mergedir,"/DataSet4.txt")
                ,stringsAsFactors = FALSE
                ,header = TRUE
        ))
        dt5 <- dt4[, lapply(.SD, mean), by=list(SubjectCode, ActivityCode, Activity)]
}


SaveDataSet1()
SaveDataSet2()
SaveDataSet3()
SaveDataSet4()
SaveDataSet5()
