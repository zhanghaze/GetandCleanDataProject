library(dplyr)

labels <-  read.csv("./UCI HAR Dataset/activity_labels.txt",header=FALSE, sep="")
featurenams <- read.csv("./UCI HAR Dataset/features.txt",header=FALSE, sep="")

# note that seq=" " doesn't work..
testdataX <- read.csv("./UCI HAR Dataset/test/X_test.txt",header=FALSE, sep="")
testdatay <- read.csv("./UCI HAR Dataset/test/y_test.txt",header=FALSE, sep="")

traindataX <- read.csv("./UCI HAR Dataset/train/X_train.txt",header=FALSE, sep="")
traindatay <- read.csv("./UCI HAR Dataset/train/y_train.txt",header=FALSE, sep="")

traindataz <- read.csv("./UCI HAR Dataset/train/subject_train.txt",header=FALSE, sep="")
testdataz <- read.csv("./UCI HAR Dataset/test/subject_test.txt",header=FALSE, sep="")

#handle data x
fullX <- rbind(testdataX, traindataX)
colnames(fullX) <- as.matrix(featurenams[,2])
newcols <- NULL
for(name in names(fullX)) {
    if(!grepl("*mean*", name) && !grepl("*std*", name)) {
        fullX[name] <- NULL
    } else {
        # substitut char for a better field name.
        newname <- gsub("\\(","",name)
        newname <- gsub("\\)","",newname)
        newname <- gsub("-",".",newname)
        newcols <- c(newcols, newname) 
    }
}
colnames(fullX) <- newcols


# handle data y
fully <- rbind(testdatay, traindatay)
labeltofactor <- function(label){
    return(as.factor(labels[label,2]))
}
transy <-mutate(fully, V1=labeltofactor(V1))
transy <-rename(transy, Activity=V1)


# handle data z
fullz <- rbind(testdataz, traindataz)
fullz <-rename(fullz, Subject=V1)



# combine X and Y for further analysis
alldata <- cbind(fullX,transy, fullz)

# basically, this calls with(data, tapply(field, category, func))
evalone <- function(colname ){
    return( eval(parse(text=paste0("with(alldata, tapply (",colname, ",list(Activity,Subject), mean))"))))
}

# for each feature create a data frame
getonedf <- function(name) {
    tmp <- evalone(name)
    rn <- rownames(tmp)
    cn <- colnames(tmp)
    tmpnum <- as.vector(tmp)
    colnamActivity <- NULL;
    colnamSubject <- NULL;
    for(tcn in colnames(tmp)) {
        for(trn in rownames(tmp)) {
            colnamActivity <- c(colnamActivity, trn)
            colnamSubject <- c(colnamSubject, tcn)
            #colnam <- c(colnam, paste0(trn,".",tcn))
        }
    }
    #colnam <- as.factor(colnam)
    colnamActivity <- as.factor(colnamActivity);
    colnamSubject <- as.factor(colnamSubject);
    #dfx <- data.frame(colnam,tmpnum)
    dfx <- data.frame(colnamSubject,colnamActivity, tmpnum);
    colnames(dfx) <- c("Subject","Activity",name)
    return(dfx)
}

# iterate all column and merge the result.
cleaneddf <- NULL;
for(name in names(fullX)){
    if(is.null(cleaneddf)) {
        cleaneddf <- getonedf(name)
    } else {
        #cleaneddf <- merge(cleaneddf, getonedf(name), by.x = "Activity.Subject", by.y = "Activity.Subject", all = TRUE)
        cleaneddf <- merge(cleaneddf, getonedf(name), all = TRUE)
    }
}

#save the result.
write.table(cleaneddf, file="cleaneddata.txt", row.names= FALSE)









