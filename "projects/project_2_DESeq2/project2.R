#My working directory is: /Users/diplo/Desktop/Αναλύσεις/project2


library(DESeq2)
library(ggplot2)

#import the txt file
data <- read.delim("/Users/diplo/Desktop/Αναλύσεις/project_2_DESeq2/wt_vs_KO_RNA.txt")

#remove the gene names column
countData <- data[,-9]

#create the metadata data frame which contains the columns of countData as rows and a column condition
colData <- data.frame(row.names = colnames(countData), condition = c("WT","WT","WT","WT","KO","KO","KO","KO"))

#factoring the column condition
colData$condition <- factor(colData$condition)

#create the dds object
dds <- DESeqDataSetFromMatrix(countData = countData,
                              colData = colData,
                              design = ~condition)
#hit it!
dd2 <- DESeq(dds)
print(dd2)

#with results you extract a data frame from the DESeq analysis
res <- results(dd2, contrast=c("condition", "KO", "WT"))
res <- as.data.frame(res)

# create column in the res data frame with the gene names from the 9th column of data
res$gene<-data[,9]

#extract raw or normalized counts from the DESeqDataSet
sd<-counts(dd2, normalized=T)
sd<-as.data.frame(sd)
sd$gene <-data[,9]


#merge the two dataframes
res_counts<- merge(res,sd,by="gene")

#create new columns that contain the means of the WT and KO columns
res_counts$CondWT <- rowMeans(res_counts[,8:11])
res_counts$CondKO <- rowMeans(res_counts[,12:15])

#delete all the other columns of the reps and keep the columns with the means
res_counts <- res_counts[,-c(8:15)]



filtered_res_counts<- subset(res_counts, res_counts$pvalue<0.05 & 
                               res_counts$CondWT>20 & 
                               res_counts$CondKO>20 & 
                               (res_counts$log2FoldChange > 1|res_counts$log2FoldChange < -1))


filtered_res_counts$diffexpressed<-ifelse(filtered_res_counts$log2FoldChange >  1 & filtered_res_counts$pvalue < 0.05, "Upregulated", "Downregulated" )


colours<- c("pink", "purple")
names(colours) <- c("Upregulated", "Downregulated")


ggplot(data=filtered_res_counts, aes(x=log2FoldChange, y=-log10(pvalue), col=diffexpressed)) + 
  geom_point() + 
  geom_vline(xintercept=c(-1, 1), col="darkblue") + 
  geom_hline(yintercept= -log10(0.05), col="darkblue") +
  scale_colour_manual(values = colours)
                      

#be kind i am just a girl


                      