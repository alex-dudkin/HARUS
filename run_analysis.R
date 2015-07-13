<<<<<<< HEAD
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


=======
#test
>>>>>>> 3a6872a5d1c4a52a719ed968550a60e653477cf1
