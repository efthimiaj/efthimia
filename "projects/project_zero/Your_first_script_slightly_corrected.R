testData <- read.delim("GSE112717_Expression_Matrix_EryPEryD.txt")

# number of genes
num_of_genes <- nrow(testData)

# number of samples
num_of_samples <- ncol(testData)


testData_mean <- cbind(testData, new_column = NA)

testData_mean[,9] <- rowMeans(testData_mean[1:nrow(testData_mean),3:8])

save(testData_mean,file="testData_appended.Rda")


##############################################################################################################
##############################################################################################################
##############################################################################################################


# How I'd improve this code:

# (keeping the absolute path of your working directory is useful)
# Something like: My working directory is: ~/bomboclat/Desktop

# Same as yours 
testData <- read.delim("GSE112717_Expression_Matrix_EryPEryD.txt")

# Same as yours
num_of_genes <- nrow(testData)

# A bit different (the first two columns are not samples, that's why -2)
num_of_samples <- ncol(testData) - 2

# In R, you do not need an existing column to add info.
# You can add info to a column you create at the same time:
testData$column_I_just_created <- rowMeans(testData_mean[1:nrow(testData_mean),3:8])

# We use write table and not save to save our data (it's just easier) :
# We add the .txt extension when saving a data frame
write.table( testData,
             # File name
             "testData_appended.txt", 
             # Keep the names of the columns
             col.names=T, 
             # Don't keep the row names
             row.names=F,
             # It's a tab (\t) separated file
             sep="\t" )

# The write table options might change depending on your use-case. Generally, the ones you see here, are the norm.



#####################################################################################

#added from me: you don't need to create the testData_mean, you can just
testData$column_I_just_created <- rowMeans(testData[, 3:8], na.rm = TRUE)










