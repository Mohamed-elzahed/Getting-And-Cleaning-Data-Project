library(dplyr)
features <- read.table('UCI HAR Dataset/features.txt', col.names = c('n', 'functions'))
activities <- read.table('UCI HAR Dataset/activity_labels.txt', col.names = c('code', 'activity'))
subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt', col.names = 'subject')
x_test <- read.table('UCI HAR Dataset/test/X_test.txt', col.names = features$functions)
y_test <- read.table('UCI HAR Dataset/test/y_test.txt', col.names = 'code')
subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt', col.names = 'subject')
x_train <- read.table('UCI HAR Dataset/train/X_train.txt', col.names = features$functions)
y_train <- read.table('UCI HAR Dataset/train/y_train.txt', col.names = 'code')
#Merges the training and the test sets to create one data set.
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
mergedData <- cbind(subject, x, y)
#Extracts only the measurements on the mean and standard deviation 
#for each measurement.
tidyData <- mergedData %>%
        select(subject, code, contains('mean'), contains('std'))
#Uses descriptive activity names to name the activities in the data set
tidyData$code <- activities[tidyData$code,2]
#Appropriately labels the data set with descriptive variable names.
names(tidyData)[1] = 'Subject'
names(tidyData)[2] = 'Activity'
names(tidyData) <- gsub('Acc', 'Accelerometer', names(tidyData))
names(tidyData) <- gsub('angle', 'Angle', names(tidyData))
names(tidyData) <- gsub('Gyro', 'Gyroscope', names(tidyData))
names(tidyData) <- gsub('gravity', 'Gravity', names(tidyData))
names(tidyData) <- gsub('BodyBody', 'Body', names(tidyData))
names(tidyData) <- gsub('Mag', 'Magnitude', names(tidyData))
names(tidyData) <- gsub('tBody', 'TimeBody', names(tidyData))
names(tidyData) <- gsub('^t', 'Time', names(tidyData))
names(tidyData) <- gsub('^f', 'Frequency', names(tidyData))
names(tidyData) <- gsub('mean', 'Mean', names(tidyData), ignore.case = T)
names(tidyData) <- gsub('std', 'STD', names(tidyData), ignore.case = T)
names(tidyData) <- gsub('freq', 'Frequency', names(tidyData), ignore.case = T)
#From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable 
#for each activity and each subject.
summarized_data <- tidyData %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
write.table(summarized_data, 'means.txt', row.names = F)
















