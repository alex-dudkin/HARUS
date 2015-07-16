1.      Unpack the Samsung dataset archive into working directory,
        preserving the archive directory structure.
        The dataset should be contained in 'UCI HAR Dataset' directory.
        The run_analysis.R script contains a few variables that specify
        the default location of the dataset.
        You can tweak the variables as needed. See CodeBook.md for the details.

2.      Put the script run_analysis.R into working directory.

3.      The run_analysis.R script requires the data.table package; 
        if you haven't installed the package, follow the link
        https://github.com/Rdatatable/data.table/wiki/Installation

4.      Execute run_analysis.R script by typing in the RStudio console:
        source("run_analysis.R")
        The execution will take about 2 minutes.
        The output files will be put in the "merged" directory.
