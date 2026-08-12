testData <- read.delim("GSE112717_Expression_Matrix_EryPEryD.txt")

# number of genes
num_of_genes <- nrow(testData)

# number of samples
num_of_samples <- ncol(testData)


testData_mean <- cbind(testData, new_column = NA)

testData_mean[,9] <- rowMeans(testData_mean[1:nrow(testData_mean),3:8])

save(testData_mean,file="testData_appended.Rda")

