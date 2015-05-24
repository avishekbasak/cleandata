library(plyr)

# Create file objects
uci_hard_dir <- "UCI\ HAR\ Dataset"
feature_F <- paste(uci_hard_dir, "/features.txt", sep = "")
activity_F <- paste(uci_hard_dir, "/activity_labels.txt", sep = "")
xtrain_F <- paste(uci_hard_dir, "/train/X_train.txt", sep = "")
ytrain_F <- paste(uci_hard_dir, "/train/y_train.txt", sep = "")
subject_trn_F <- paste(uci_hard_dir, "/train/subject_train.txt", sep = "")
xtest_F  <- paste(uci_hard_dir, "/test/X_test.txt", sep = "")
ytest_F  <- paste(uci_hard_dir, "/test/y_test.txt", sep = "")
subject_tst_F <- paste(uci_hard_dir, "/test/subject_test.txt", sep = "")

# Read data from file
features <- read.table(feature_F, colClasses = c("character"))
activity <- read.table(activity_F, col.names = c("ActivityId", "Activity"))
xtrain <- read.table(xtrain_F)
ytrain <- read.table(ytrain_F)
subtrain <- read.table(subject_trn_F)
xtest <- read.table(xtest_F)
ytest <- read.table(ytest_F)
subtest <- read.table(subject_tst_F)


# Step 1. Merges the training and the test sets to create one data set.

trn_data <- cbind(cbind(xtrain, subtrain), ytrain)
test_data <- cbind(cbind(xtest, subtest), ytest)
sensor_data <- rbind(trn_data, test_data)
sensor_col_name <- rbind(rbind(features, c(562, "Subject")), c(563, "ActivityId"))[,2]
names(sensor_data) <- sensor_col_name


# Step 2. Extracts only the measurements on the mean and standard deviation for each measurement.
sensor_data_mean_std <- sensor_data[,grepl("mean|std|Subject|ActivityId", names(sensor_data))]

# Step 3. Uses descriptive activity names to name the activities in the data set
sensor_data_mean_std <- join(sensor_data_mean_std, activity, by = "ActivityId", match = "first")
sensor_data_mean_std <- sensor_data_mean_std[,-1]

# Step 4. Appropriately labels the data set with descriptive names.
names(sensor_data_mean_std) <- gsub('\\(|\\)',"",names(sensor_data_mean_std), perl = TRUE)
names(sensor_data_mean_std) <- make.names(names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('Acc',".Acceleration",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('GyroJerk',".Angular_Acceleration",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('Gyro',".Angular_Speed",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('Mag',".Magnitude",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('^t',".Time_Domain.",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('^f',".Frequency_Domain.",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('\\.mean',".Mean",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('\\.std',".Standard_Deviation",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('Freq\\.',".Frequency.",names(sensor_data_mean_std))
names(sensor_data_mean_std) <- gsub('Freq$',".Frequency",names(sensor_data_mean_std))


# Step5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
sensor_avg_by_act_sub = ddply(sensor_data_mean_std, c("Subject","Activity"), numcolwise(mean))
write.table(sensor_avg_by_act_sub, file = "tidy_data.txt",row.name=FALSE)
