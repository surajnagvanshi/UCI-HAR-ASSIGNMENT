#loading required libraries
library(plyr)
library(dplyr)

#Prepairing features
#loading test features
test_X<-read.table('./test/X_test.txt')
#loading train features
train_X<-read.table('./train/X_train.txt')
#concatenating test and train features
X<-rbind(train_X,test_X)
#loading feature names
features<-read.table('features.txt')
features<-features$V2
#substituting default column_names with feature names
names(X)<-features
#Extracts only the measurements on the mean and standard deviation for each measurement
X<-X[as.character(col_names[grepl(".std\\(\\)|.mean\\(\\)",features)])]


#prepairing activity vector for each measurement
#reading train activity vecctor
test_y<-read.table('./test/y_test.txt')
#reading test activity vector
train_y<-read.table('./train/y_train.txt')
#concatenating train and test activity vectors
y<-rbind(train_y,test_y)
#substituting vactivity vector name as activity
names(y)<-"activity"
#reading all the mapped activitiy names
activities<-read.table("activity_labels.txt")
#substuting activites with their names
y$activity<-mapvalues(y$activity, from = activities$V1, to = as.character(activities$V2))


#prepairing subjects vector
#reading test subjects vector
test_subjects<-read.table('test/subject_test.txt')
#reading train subjects vector
train_subjects<-read.table('train/subject_train.txt')
#concatenating train and test subject vectors
subjects<-rbind(train_subjects,test_subjects)
#substituting subjects vactor name as subject
names(subjects)<-"subject"


#joining feature vectors, subject vector and activity vector
data<-cbind(X,subjects,y)

#creating the second, independent tidy data set with the average of each variable for each activity and each subject
mean_grouped_by_activity_and_subject <- data %>% group_by(activity,subject) %>% summarise_all("mean")
#appending each column name with '_mean_by_activity_and_subject' except activity and subject column names
names(mean_grouped_by_activity_and_subject)[3:length(names(mean_grouped_by_activity_and_subject))]<-paste0(names(mean_grouped_by_activity_and_subject)[3:length(names(mean_grouped_by_activity_and_subject))],"_mean_by_activity_and_subject")
