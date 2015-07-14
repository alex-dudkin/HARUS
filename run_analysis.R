g_datadir <- "UCI HAR Dataset"
g_dirs2merge <- c("test","train")
g_mergedir <- "merged"

MergeFiles <- function(file1, file2) {
        f1 <- read.table(file1, stringsAsFactors = FALSE)
        f2 <- read.table(file2, stringsAsFactors = FALSE)
        rbind(f1, f2)
}

#task 1    Merges the training and the test sets to create one data set.
MergeDatasets <- function(mergedir=g_mergedir, datadir=g_datadir, dirs2merge=g_dirs2merge) {  
        dir1 <- paste0(datadir, "/", dirs2merge[1])
        dir2 <- paste0(datadir, "/", dirs2merge[2])
        
        for (d1 in list.dirs(dir1, full.names = FALSE, recursive = TRUE)) {
                dir.create(paste0(mergedir,"/",d1), recursive = TRUE, showWarnings = FALSE)
        }
        
        # f1 = filename 1 to merge, f2 = filename 2 to merge
        # f3 = result merged filename 
        for (f1 in list.files(dir1, full.names = FALSE, recursive = TRUE)) {                    
                f2 <- sub(paste0(dirs2merge[1],"\\.txt$"), paste0(dirs2merge[2],".txt"), f1)    
                f3 <- sub(paste0(dirs2merge[1],"\\.txt$"), paste0(mergedir,".txt"), f1)         
                
                dt3 <- MergeFiles(paste0(dir1, "/", f1), paste0(dir2, "/", f2))
                #print(paste0(mergedir,"/", f3))
                write.table(dt3, file = paste0(mergedir,"/", f3), row.names = FALSE, col.names = FALSE)
        }
        
        
}  

#task 2    Extracts only the measurements on the mean and standard deviation for each measurement.
ExtractMeanStd <- function(mergedir=g_mergedir, datadir=g_datadir) {
        varnames_dt <- HumanVarNames(mergedir, datadir)

        dt <- read.table(paste0(mergedir,"/X_merged.txt"), stringsAsFactors = FALSE)
        #extract only ..-mean() and ..-std() variables 
        dt1 <- as.data.table(dt[,varnames_dt$varcode])
        setnames(dt1, varnames_dt$humanvar)
        #add activity column
        dt2 <- cbind(dt1, DescriptiveActivityColumn(mergedir, datadir))
        #add subject code column
        dt2 <- cbind(dt2, SubjectCodeColumn(mergedir, datadir))
        
        write.table(dt2, file = paste0(mergedir,"/MeanAndStd.txt"), row.names = FALSE, col.names = TRUE)
        dt2
}



#task 3    Uses descriptive activity names to name the activities in the data set
DescriptiveActivityColumn <- function(mergedir=g_mergedir, datadir=g_datadir) {
        activity_label_dt <- read.table(paste0(datadir,"/activity_labels.txt"), col.names = c("ActivityCode","Activity"), row.names = 1)
        activity_dt <- read.table(paste0(mergedir,"/y_merged.txt"), col.names = "ActivityCode")
        activity_dt1 <- as.data.table(activity_dt)[, Activity:=activity_label_dt[ActivityCode,]]
        activity_dt2 <- activity_dt1[,.(Activity)]
        
        # f <- split(dt1, activity_dt)
        # f <- split(dt1, activity_dt2)
        # f <- split(dt2[, !c("Activity","SubjectCode"), with=FALSE], paste(dt2$SubjectCode, dt2$Activity))
        # sapply(f, function(x) apply(x, 2, mean))  
} 

SubjectCodeColumn <- function(mergedir=g_mergedir, datadir=g_datadir) {
        subject_dt <- as.data.table(read.table(paste0(mergedir,"/subject_merged.txt"), col.names = "SubjectCode"))
} 


#task 4    Appropriately labels the data set with descriptive variable names. 
HumanVarNames <- function(mergedir=g_mergedir, datadir=g_datadir) {
        varnames_dt <- read.table(paste0(datadir,"/features.txt"), col.names = c("varcode", "varname"))
        #extract only mean() and std() variables
        varnames_dt1 <- as.data.table(varnames_dt[grep("mean\\(\\)$|std\\(\\)$", varnames_dt[,2]),])
        sub_dt <- data.table()
        sub_dt <- rbind(sub_dt, data.table(pattern="-mean\\(\\)", replacement="Mean"))
        sub_dt <- rbind(sub_dt, data.table(pattern="-std\\(\\)", replacement="Std"))
        sub_dt <- rbind(sub_dt, data.table(pattern="^t", replacement="Time"))
        sub_dt <- rbind(sub_dt, data.table(pattern="^f", replacement="Fft"))
        sub_dt <- rbind(sub_dt, data.table(pattern="Acc", replacement="Acceleration"))
        sub_dt <- rbind(sub_dt, data.table(pattern="Gyro", replacement="Gyroscope"))
        sub_dt <- rbind(sub_dt, data.table(pattern="Mag", replacement="Magnitude"))

        varnames_dt1[, humanvar:=varname]
        mapply(function(x, y) {
                varnames_dt1[, humanvar:=sub(x, y, varnames_dt1$humanvar)]
        }, sub_dt$pattern, sub_dt$replacement)
        varnames_dt1
}


