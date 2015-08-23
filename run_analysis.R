library(sqldf)
library(plyr)

#download and unzip initial data folder
dataUrl_zip<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataUrl_zip,destfile=".\\har_data.zip")
unzip("har_data.zip")

#read the necessary tables into R
x_test<-read.table(".\\UCI HAR Dataset\\test\\X_test.txt")
y_test<-read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
subject_test<-read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")
x_train<-read.table(".\\UCI HAR Dataset\\train\\X_train.txt")
y_train<-read.table(".\\UCI HAR Dataset\\train\\y_train.txt")
subject_train<-read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")
features<-read.table(".\\UCI HAR Dataset\\features.txt")
activity_labels<-read.table(".\\UCI HAR Dataset\\activity_labels.txt")

#add descriptive column names to small data sets for labels, subjects and features
names(y_test)<-"activity_id"
names(y_train)<-"activity_id"
names(subject_test)<-"subject_id"
names(subject_train)<-"subject_id"
names(activity_labels)<-c("activity_id","activity_name")
names(features)<-c("col_num","feature_name")

#add activity and subject colums to main (test and train) data sets
test<-cbind(x_test,y_test,subject_test)
train<-cbind(x_train,y_train,subject_train)

#combine test and train data into one data table using SQL UNION ALL query
full_data<-sqldf("SELECT * FROM train
                   UNION ALL
                   SELECT * FROM test")

#define features (their names and column number in main data sets) conataining
#mean() and std() values
features_ms<-features[grepl("mean()",features$feature_name,fixed=T)|
                              grepl("std()",features$feature_name,fixed=T),]

#narrow the main data set to the colums with std() and mean() features as well as
#activity_id and subject_id
idx_ms<-features_ms$col_num
full_data_ms<-full_data[,c(idx_ms,562,563)]

#join the narrowed data set with the activity label dictionary using the SQL
#JOIN operator and activity_id columns
full_data_ms<-sqldf("SELECT * FROM full_data_ms fd
                    left outer join 
                    activity_labels al 
                    on fd.activity_id=al.activity_id")

#delete the duplicate column for activity_id created after join
full_data_ms$activity_id<-NULL

#rename the columns corresponding to features with mean() and std() values
#in the narrowed data set set with appropriate descriptive names
feature_names<-as.character(features_ms$feature_name)
names(full_data_ms)[1:66]<-feature_names

#create an independent tidy data set with the average of each variable for 
#each activity and each subject
full_data_ms_mean<-ddply(full_data_ms, 
                         c("activity_id","activity_name","subject_id"), 
                         colwise(mean))

#save final tidy data set to a file
write.table(full_data_ms_mean, file = "isemenov_GCD_project_result.txt", 
            row.names = F)
