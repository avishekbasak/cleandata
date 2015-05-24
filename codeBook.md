#Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

#Steps of transformation
run_analysis.R follow the steps for transformation

1. Merge training and test sets: Test and training data, subject ids and activity ids are merged to obtain a single data set. 
Variables are labelled with the names of features.

2. Extract mean and standard deviation variables: From the merged data set, extract intermediate data set with only the values of estimated mean 
and standard deviation.

3. Use descriptive activity names: A new column is added to intermediate data set with the activity description. This info is fetched from activity_labels.

4. Mark each Label variables appropriately: Labels given from the original collectors were changed to obtain more descriptive names as required in R.

5. Create final tidy data set: At the end, the final data set is created from intermediate dataset, where the variables are averaged for each 
activity and each subject.
