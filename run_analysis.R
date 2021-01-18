library(reshape2)

# get data

zipFile <- "initialdata.zip"

if(!file.exists(zipFile)){
        fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileurl, destfile="./initaldata",  method="curl")}

if (!file.exists("UCI HAR Dataset")) { 
        unzip(zipFile)}

# Merges the training and the test sets to create one data set

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
s_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
s_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

x_data <- rbind(x_train,x_test)
y_data <- rbind(y_train,y_test)
s_data <- rbind(s_train,s_test)

# Extracts only the measurements on the mean and standard deviation for each measurement. 

feature <- read.table("./UCI HAR Dataset/features.txt")
all_data <-cbind(s_data,y_data,x_data)
colnames(all_data) <- c("Subject", "Activity", feature[,2])

col2Keep <- grep("-(mean|std).*", as.character(feature[,2]))
col2KeepNames <- feature[col2Keep,2]

all_data <- all_data[, col2Keep]

# Uses descriptive activity names to name the activities in the data set

activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
all_data$Activity <- factor(all_data$Activity, levels = activities[,1], labels = activities[,2])

#Appropriately labels the data set with descriptive variable names. 

allColNames <- colnames(all_data)
allColNames <- gsub("[\\(\\)-]", "", allColNames)
allColNames <- gsub("mean", "Mean", allColNames)
allColNames <- gsub("std", "Std", allColNames)
allColNames <- gsub("Acc", "Accelerometer", allColNames)
allColNames <- gsub("Gyro", "Gyroscope", allColNames)
allColNames <- gsub("BodyBody", "Body", allColNames)

colnames(all_data)<-allColNames

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

melted_data <- melt(all_data, id = c("Subject", "Activity"))
tidy_data <- dcast(melted_data, Subject + Activity ~ variable, mean)

write.table(tidy_data, "tidy_data.txt", row.names = FALSE, quote = FALSE)

