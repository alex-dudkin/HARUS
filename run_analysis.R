g_datadir <- "UCI HAR Dataset"
g_dirs2merge <- c("test","train")
g_mergedir <- "merged"
#testdir <- "UCI HAR Dataset/test"
#traindir <- "UCI HAR Dataset/train"
#inertdir <- "Inertial Signals"

mergeFiles <- function(file1, file2) {
        f1 <- read.table(file1, stringsAsFactors = FALSE)
        f2 <- read.table(file2, stringsAsFactors = FALSE)
        rbind(f1, f2)
}

mergeDatasets <- function(mergedir=g_mergedir, datadir=g_datadir, dirs2merge=g_dirs2merge) {  
        dir1 <- paste0(datadir, "/", dirs2merge[1])
        dir2 <- paste0(datadir, "/", dirs2merge[2])
        
        for (d1 in list.dirs(dir1, full.names = FALSE, recursive = TRUE)) {
                dir.create(paste0(mergedir,"/",d1), recursive = TRUE, showWarnings = FALSE)
        }
        
        for (f1 in list.files(dir1, full.names = FALSE, recursive = TRUE)) { 
                f2 <- sub(paste0(dirs2merge[1],"\\.txt$"), paste0(dirs2merge[2],".txt"), f1) 
                f3 <- sub(paste0(dirs2merge[1],"\\.txt$"), paste0(mergedir,".txt"), f1) # get result (merged) file name 
                
                dt3 <- mergeFiles(paste0(dir1, "/", f1), paste0(dir2, "/", f2))
                #print(paste0(mergedir,"/", f3))
                write.table(dt3, file = paste0(mergedir,"/", f3), row.names = FALSE, col.names = FALSE)
        }
        
        
}  

MeanAndStd <- function(mergedir=g_mergedir, datadir=g_datadir) {
        cols_dt <- read.table(paste0(datadir,"/features.txt"))
        cols_dt1 <- cols_dt[grep("mean\\(\\)|std\\(\\)",cols_dt[,2]),]     
        
        dt <- read.table(paste0(mergedir,"/X_merged.txt"), stringsAsFactors = FALSE)
        dt1 <- dt[,cols_dt1[,1]]
        colnames(dt1) <- cols_dt1[,2]
        
        #write.table(dt1, file = paste0(mergedir,"/MeanAndStd.txt"), row.names = FALSE, col.names = TRUE)
}
