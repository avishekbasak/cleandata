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
sensorMeanStd <- sensor_data[,grepl("mean|std|Subject|ActivityId", names(sensor_data))]

# Step 3. Uses descriptive activity names to name the activities in the data set
sensorMeanStd <- join(sensorMeanStd, activity, by = "ActivityId", match = "first")
sensorMeanStd <- sensorMeanStd[,-1]

# Step 4. Appropriately labels the data set with descriptive names.
names(sensorMeanStd) <- gsub('\\(|\\)',"",names(sensorMeanStd), perl = TRUE)
names(sensorMeanStd) <- make.names(names(sensorMeanStd))
names(sensorMeanStd) <- gsub('Acc',".Acceleration",names(sensorMeanStd))
names(sensorMeanStd) <- gsub('GyroJerk',".Angular_Acceleration",names(sensorMeanStd))
names(sensorMeanStd) <- gsub('Gyro',".Angular_Speed",names(sensorMeanStd))
names(sensorMeanStd) <- gsub('Mag',".Magnitude",names(sensorMeanStd))
names(sensorMeanStd) <- gsub('^t',".Time_Domain.",names(sensorMeanStd))
names(sensorMeanStd) <- gsub('^f',".Frequency_Domain.",names(sensorMeanStd))
names(sensorMeanStd) <- gsub('\\.mean',".Mean",names(sensorMeanStd))
names(sensorMeanStd) <- gsub('\\.std',".Standard_Deviation",names(sensorMeanStd))
names(sensorMeanStd) <- gsub('Freq\\.',".Frequency.",names(sensorMeanStd))
names(sensorMeanStd) <- gsub('Freq$',".Frequency",names(sensorMeanStd))


# Step5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
sensor_avg_by_act_sub = ddply(sensorMeanStd, c("Subject","Activity"), numcolwise(mean))
write.table(sensor_avg_by_act_sub, file = "tidy_data.txt",row.name=FALSE)
