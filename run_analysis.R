# -------------------
# Author: Tomohisa Kobayashi
# 
# Date: 2018/01/21
# 
# Title: Peer-graded Assignment: Getting and Cleaning Data Course Project
# -------------------
  
library(readr)
library(tidyverse)

setwd("your working direcotry")

field_names <- readr::read_table("features.txt", col_names = "fields")
labels <- readr::read_table("activity_labels.txt", col_names = c("lab_id","label"))



#= train data prep
xtrain <- readr::read_table("train/X_train.txt", col_names = field_names$fields)
train_labels <- readr::read_table("train/y_train.txt", col_names = "lab_id")
train_users <- readr::read_table("train/subject_train.txt",col_names = "users")

train_dat <- xtrain %>% 
  dplyr::bind_cols(train_users,train_labels) %>% 
  dplyr::left_join(labels, by = "lab_id") %>% 
  dplyr::select(users,lab_id,label,everything())


#= test data prep
xtest <- readr::read_table("test/X_test.txt", col_names = field_names$fields)
test_labels <- readr::read_table("test/y_test.txt", col_names = "lab_id")
test_users <- readr::read_table("test/subject_test.txt",col_names = "users")

test_dat <- xtest %>% 
  dplyr::bind_cols(test_users,test_labels) %>% 
  dplyr::left_join(labels, by = "lab_id") %>% 
  dplyr::select(users,lab_id,label,everything())

#= merge train and test data to create one data set
dat_merged <- dplyr::bind_rows(train_dat,test_dat)


#= Extracts only the measurements on the mean and standard deviation for each measurement.
dat_m_std <- dat_merged %>% 
  dplyr::select(matches("mean|std"))
  

# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
dat_named <- dat_m_std %>% 
  dplyr::bind_cols(dat_merged[,c("users","lab_id","label")]) %>% 
  dplyr::select(users,lab_id,label,everything())



# creates a second, independent tidy data set with the average of each variable for each activity and each subject.
dat_means <- dat_named %>% 
  dplyr::group_by(users,label) %>% 
  dplyr::summarise_all(funs(mean)) 

# write.csv(dat_means,"tidy_dat.csv")


