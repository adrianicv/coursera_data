############################################
# Coursera Getting and Cleaning Data class #
#             Peer Assessment              #
############################################

#################################################
# The author's (my) system settings:            #
# platform       "x86_64-pc-linux-gnu"          #
# arch           "x86_64"                       #
# os             "linux-gnu"                    #
# system         "x86_64, linux-gnu"            #
# status         ""                             #
# major          "3"                            #
# minor          "1.0"                          #
# year           "2014"                         #
# month          "04"                           #
# day            "10"                           #
# svn rev        "65387"                        #
# language       "R"                            #
# version.string "R version 3.1.0 (2014-04-10)" #
# nickname       "Spring Dance"                 #
#################################################

# ommited in this script: setting working directory with setwd()
# example: setwd('/some/folder/structure/UCI HAR Dataset')

#######################################
# PART 1:                             #
# - combine test and trainings sets   #
# - use activity names instead of ids #
# - extract 'mean' and 'std' features #
#######################################

# read features, assigne discriptive column names:
features <- read.table('features.txt', sep='', col.names=c('activityId', 'activityName'))
# remove the parenthesis '()' which then will look nicer when using feature names as column headers:
features[,2] <- sub('()', '', features[,2], fixed=TRUE)

# extract feature ids of features with 'mean' or 'std' in the feature names:
feature.id.mean.std <- grep(pattern='\\b(mean|std)\\b', x=features[,2])

# read training data sets, assign descriptive column names:
X.train <- read.table(file='train/X_train.txt', sep='', col.names=features[,2])
subjects.train <- read.table(file='train/subject_train.txt', sep='', col.names='subjectId')
y.train <- read.table(file='train/y_train.txt', sep='', col.names='activityId')

# read test data sets, assign descriptive column names:
X.test <- read.table(file='test/X_test.txt', sep='', col.names=features[,2])
subjects.test <- read.table(file='test/subject_test.txt', sep='', col.names='subjectId')
y.test <- read.table(file='test/y_test.txt', sep='', col.names='activityId')

# read activity labels: 
activities <- read.table('activity_labels.txt', col.names=c('activityId', 'activityName'))

# merge X:
X <- rbind(X.train, X.test)

# merge subjects:
subjects <- rbind(subjects.train, subjects.test)

# merge y:
y <- rbind(y.train, y.test)

# create activity names data set:
activityName <- activities[c(y$activityId), 2]

# merge X, subject and activity names:
X.subject.activityName <- cbind(X, subjects, activityName)
# NOW WE HAVE THE COMPLETE MERGED DATA SET WITH ACTIVITY NAMES.

# create similar data set as above, now only with 'mean' and 'std' measurements (but including subjectIds and activityNames):
X.mean.std.subject.activityName <- cbind(X[,feature.id.mean.std], subjects, activityName)
# NOW WE HAVE THE MERGED DATA SET WITH ACTIVITY NAMES, BUT ONLY WITH MEANS AND STANDARD DEVIATION MEASUREMENTS.

#######################################################################################
# PART 2:                                                                             #
# - create new tidy data set with averages for each variable per activity and subject #
#######################################################################################
tidy.by.activity.and.subject <- aggregate(formula=.~activityName+subjectId, data=X.mean.std.subject.activityName, FUN=mean)
# NOW WE HAVE A TIDY DATA SET WITH THE AVERAGES FOR EACH 'mean' and 'std' MEASUREMENT PER ACTIVITY NAME AND SUBJECT ID.
# In SQL it would be something like:
# 'select activityName, subjectId, avg(tBodyAcc.mean.X), avg(tBodyAcc.mean.Y) /*some more avg(...) here*/ from someTableName by activityName, subjectId;'

# write tidy data set to file:
write.table(tidy.by.activity.and.subject, "means_by_activity_subject.dat", row.names=FALSE)
# NOW WE HAVE IT ON DISK. INCLUDING HEADERS. SPACE SEPERATED.
