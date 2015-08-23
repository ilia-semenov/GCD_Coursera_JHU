# GCD_Coursera_JHU

Getting and Cleaning Data - Coursera Course

Written by Ilia Semenov (@ilia-semenov)

Created 08/21/2015

Compatibility: Rv3

This repository contains the R script for retrieving and modifying the Human Activity Recognition Using Smartphones Dataset (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The script is performing the following:
* Downloads the data to lacal disk from the source URL as zip file
* Unzipps the file
* Reads 8 different tables with read.table
  * 3 tables for train data: sensor data, activity lables for data set, dataset with subjects of activities measured
  * 3 tables for test data: sensor data, activity lables for data set, dataset with subjects of activities measured
  * Activity label dictionary (ID to name)
  * Feature dictionary (names of columns in the main datasets)
* Merges the tables: 
  * Test and train data with their activity labels (IDs) and subjects (join)
  * Modified test and train data together (union)
* Extracts the columns corresponding to mean() and std() measurements from the modified data set using the features dictionary and grepl() function
* Joinf the modified data set with the activity dictionary to get clear activity names
* Names all the columns in modified data set using the features dictionary
* Groups all the data by activity name and subject id with mean() as a function (average of each variable for each activity and each subject)
* Saves final dataset in txt format to local disk
