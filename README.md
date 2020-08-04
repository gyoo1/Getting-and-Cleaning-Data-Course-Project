# Getting-and-Cleaning-Data-Course-Project

Below is a detailed explanation of the code "run_analysis.R", which generates the dataset "tidy_data.txt"


The code first checks to see if a directory with the name "UCI HAR Dataset" has been created in the working directory and creates one if it is missing.

if(!file.exists("./UCI HAR Dataset")) {dir.create("./UCI HAR Dataset")}
setwd("./UCI HAR Dataset")



##1. Merge the training and the test datasets


Test datasets, including the subject identifiers, are loaded and combined into a single data frame.

X_test <- read.table("./test/X_test.txt")
Y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")
test <- cbind(subject_test, Y_test, X_test)


The same is done for the training datasets.

X_train <- read.table("./train/X_train.txt")
Y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")
train <- cbind(subject_train, Y_train, X_train)


The test and the train datasets are merged into one.

raw_data <- rbind(train, test) #merged dataset



##4. Rename Variables


I renamed the columns before performing the other steps to make referencing them easier.
Subject identifiers and the type of activity were named accordingly. The other variables were named following the names given in features.txt of the original dataset.

features <- read.table("./features.txt") #read variable names
names(raw_data) <- c("Subject ID", "Activity", features$V2) #rename columns
names(raw_data)



##2. Extract the means & stdev for each measurement


Along with the subject ID and the type of activity, only columns containing "mean()" or "std()" were extracted to create a data subset.

subset <- raw_data[, grepl("Subject ID|Activity|(mean\\())|(std\\())", names(raw_data))] #create data subset



##3. Rename activities


Levels in activity types were changed from the numbers 1:5 to more descriptive levels following activity_labels.txt of the original dataset.

library(plyr)
subset$Activity <- mapvalues(subset$Activity, from = c(1:6), 
                             to = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", 
                                    "SITTING", "STANDING", "LAYING"))



##5. Create Tidy Dataset


I obtained averages of the means and the standard deviations (std) for each subject and for each activity type, resulting in a separate row of variable averages for each subject-activity pair.

tidy_data <- aggregate(subset[, -(1:2)], list(subset$`Subject ID`, subset$Activity), mean)


The first two columns were renamed to be more descriptive and for more consistency.

names(tidy_data)[1:2] <- c("Subject ID", "Activity")


A txt file, tidy_data.txt, was created from the dataset.

write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE)
