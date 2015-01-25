1.    Merges the training and the test sets to create one data set.
2.    Extracts only the measurements on the mean and standard deviation for each measurement. 
3.    Uses descriptive activity names to name the activities in the data set
4.    Appropriately labels the data set with descriptive variable names. 

5.    From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Above is the steps given in on the project page. I would elaborate each step. 

1. I used rbind to get the full data, since the data. Now I have a X data frame with column name
   V1 - V561, and Y data frame.
2. Here I combine this step with step 4.  I assign the column name first, 
   because from each of the column name I could determin if this is a mean 
   or frequency by regex macthing keywork "mean" and "std". At the same 
   time, I collect the column name by deleting "()" and replacing "-" by ".". 
   At the end of process I reassign the column names.
3. Here mutate function would map each integer to a factor by using function "labeltofactor"
4. Done with step 2.
5. evalone function would do the mean by Activity.Subject combinate with respect
   to a given column name and returns an matrix.
   getonedf function would use evalone by returns the same result but as a data frame with
   column name "Activity.Subject" and the column name
   then I merge this one data frame with the rest of the data frame by column "Activity.Subject"


Done.
   