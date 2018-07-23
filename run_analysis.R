## Download files and unzip them
zipfile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(zipfile, destfile = "./zip.zip", method = "curl")
unzip("./zip.zip", exdir = "./wearable")
list.files("./wearable")
file.remove("./zip.zip")
dateDownloaded <- date()
dateDownloaded
## Load database column names
library(tidyverse)
features <- read.delim("./wearable/UCI\ HAR\ Dataset/features.txt", 
                       col.names = ("feature"), header = FALSE)
features <- as.vector(features$feature)
## Load database test
        ##Load database test subject
                testsub <- read.delim("./wearable/UCI\ HAR\ Dataset/test/subject_test.txt", 
                                      col.names = ("subject"), header = FALSE)
        ##Load database test data
                testx <- read.delim("./wearable/UCI\ HAR\ Dataset/test/X_test.txt",
                                    sep ="", col.names = (features) ,header = FALSE)
        ##Load database test activity
                testy <- read.delim("./wearable/UCI\ HAR\ Dataset/test/y_test.txt", 
                                    col.names = ("activity"), header = FALSE)
        ## Bind 3 intermediate files
                testsubxy <- cbind(testsub, testx, testy)
        ##Remove intermediate files
                rm(testsub, testx, testy)
## Load database train
        ##Load database train subject
                trainsub <- read.delim("./wearable/UCI\ HAR\ Dataset/train/subject_train.txt", 
                                       col.names = ("subject"), header = FALSE)
        ##Load database train data
                trainx <- read.delim("./wearable/UCI\ HAR\ Dataset/train/X_train.txt",sep ="", 
                                     col.names = (features) ,header = FALSE)
        ##Load database train activity        
                trainy <- read.delim("./wearable/UCI\ HAR\ Dataset/train/y_train.txt", 
                                     col.names = ("activity"), header = FALSE)
        ## Bind 3 intermediate files
                trainsubxy <- cbind(trainsub, trainx, trainy)
        ##Remove intermediate files
                rm(trainsub, trainx, trainy) 
## Merge both databases
        fulldataset <- rbind(testsubxy, trainsubxy)
##Remove intermediate files
        rm(testsubxy, trainsubxy)
## Extract only mean and standard deviation data
        selectdataset <- fulldataset %>% 
                select((matches(('*mean*|*std*|subject|activity'))))
##Replace numbers coded activity by descriptive names
        ## Recode activity
        fulldataset$activity <- as.factor(fulldataset$activity)
        fulldataset$activity <- 
                recode_factor(fulldataset$activity,
                              '1'= "WALKING", '2' = "WALKING_UPSTAIRS" , 
                              '3' = "WALKING_DOWNSTAIRS" , '4' = "SITTING",
                              '5' = "STANDING" , '6' = "LAYING")
##New subset database: mean by variable and subject
        lastdataset <- 
                selectdataset %>%
                group_by(subject, activity) %>%
                summarise_if(is.numeric, funs(mean(., na.rm = TRUE)))
##Remove intermediate files
        rm(fulldataset, selectdataset)
## Save dataset to upload
        write.table(lastdataset, "./tidydataset.txt", row.name=FALSE)
        