setwd("~/coursera-cleaningData/coursera-gettingcleaningData")
url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

download.file(url, "Dataset.zip")
unzip("Dataset.zip")
setwd("~/coursera-cleaningData/coursera-gettingcleaningData/UCI HAR Dataset")

file.names <- paste0("test", '/', dir("test", pattern =".txt"))

X <- rbind(read.table("test/X_test.txt"), read.table("train/X_train.txt"))
colnames(X) <- read.table("features.txt")[,2]
X <- X[,grepl("mean|std", colnames(X))]

y <- rbind(read.table("test/y_test.txt"), read.table("train/y_train.txt"))
labelMap <- read.table('activity_labels.txt', stringsAsFactors=FALSE)
for(row in 1:nrow(labelMap)) {
  label <- labelMap[row,1]
  activity <- labelMap[row,2]
  y[y == label] <- activity
}
colnames(y) <- c("activity")

subject_test <- rbind(read.table("test/subject_test.txt"), 
                      read.table("train/subject_train.txt"))
colnames(subject_test) <- c("subject") # Subject is the person performing the test.

combined <- cbind(X, y, subject_test)
write.csv(combined, "mergedData.csv")


library(dplyr)
library(tidyr)


df <- tbl_df(combined)

tidy <- df %>%
  gather(measurement, value, -activity, -subject) %>%
  group_by(activity, subject, measurement) %>%
  summarize(avgMeasurement = mean(value))

write.csv(tidy, "combinedTidyAverage.csv")
write.table(tidy, "combinedTidyAverage.txt", row.name=FALSE)



