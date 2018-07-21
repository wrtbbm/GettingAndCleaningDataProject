library(reshape2)

filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# Load activity labels + features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation
featuresEx <- grep(".*mean.*|.*std.*", features[,2])
featuresEx.names <- features[featuresWanted,2]
featuresEx.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresEx.names = gsub('-std', 'Std', featuresWanted.names)
featuresEx.names <- gsub('[-()]', '', featuresWanted.names)


# Load test and train datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
train.Activities <- read.table("UCI HAR Dataset/train/Y_train.txt")
train.Subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train.Subjects, train.Activities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
test.Activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
test.Subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test.Subjects, test.Activities, test)

# merge all datasets 
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresEx.names)

# turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
