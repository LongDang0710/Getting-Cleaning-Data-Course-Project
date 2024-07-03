# Load necessary libraries
library(dplyr)

# Step 1: Merges the training and the test sets to create one data set.
# Read the training and test data
train_data <- read.table("UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("UCI HAR Dataset/train/y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

test_data <- read.table("UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Combine the training and test data
all_data <- rbind(train_data, test_data)
all_labels <- rbind(train_labels, test_labels)
all_subjects <- rbind(train_subjects, test_subjects)

# Step 2: Extract only the measurements on the mean and standard deviation for each measurement.
features <- read.table("UCI HAR Dataset/features.txt")
mean_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
all_data <- all_data[, mean_std_features]
names(all_data) <- features[mean_std_features, 2]

# Step 3: Use descriptive activity names to name the activities in the data set.
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
all_labels[, 1] <- activity_labels[all_labels[, 1], 2]
names(all_labels) <- "activity"

# Step 4: Appropriately label the data set with descriptive variable names.
names(all_subjects) <- "subject"
complete_data <- cbind(all_subjects, all_labels, all_data)

# Step 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data <- complete_data %>%
  group_by(subject, activity) %>%
  summarise_all(list(mean = mean))

# Write the tidy data set to a file
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)