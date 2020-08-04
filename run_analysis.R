if(!file.exists("./UCI HAR Dataset")) {dir.create("./UCI HAR Dataset")}
setwd("./UCI HAR Dataset")

##1. Merge the training and the test datasets
X_test <- read.table("./test/X_test.txt")
Y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")
test <- cbind(subject_test, Y_test, X_test)

X_train <- read.table("./train/X_train.txt")
Y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")
train <- cbind(subject_train, Y_train, X_train)

raw_data <- rbind(train, test) #merged dataset

##4. Rename Variables
features <- read.table("./features.txt") #read variable names
names(raw_data) <- c("Subject ID", "Activity", features$V2) #rename columns
names(raw_data)

##2. Extract the means & stdev for each measurement
subset <- raw_data[, grepl("Subject ID|Activity|(mean\\())|(std\\())", names(raw_data))] #create data subset

##3. Rename activities
library(plyr)
subset$Activity <- mapvalues(subset$Activity, from = c(1:6), 
                             to = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", 
                                    "SITTING", "STANDING", "LAYING"))

##5. Create Tidy Dataset
tidy_data <- aggregate(subset[, -(1:2)], list(subset$`Subject ID`, subset$Activity), mean)
names(tidy_data)[1:2] <- c("Subject ID", "Activity")

write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE)




