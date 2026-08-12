#My working directory is: /Users/diplo/Desktop/Αναλύσεις/project2


library(DESeq2)
library(ggplot2)


data <- read.delim("/Users/diplo/Desktop/Αναλύσεις/mini_projects/project_2_DESeq2/wt_vs_KO_RNA.txt")

countData <- data[,-9]


colData = data.frame(row.names = colnames(countData), condition = c("WT","WT","WT","WT","KO","KO","KO","KO"))

colData$condition <- factor(colData$condition)

dds <- DESeqDataSetFromMatrix(countData = countData,
                              colData = colData,
                              design = ~condition)
dd2 <- DESeq(dds)
print(dd2)


res <- results(dd2, contrast=c("condition", "KO", "WT"))
res <- as.data.frame(res)


res$gene<-data[,9]

sd<-counts(dd2, normalized=T)
sd<-as.data.frame(sd)
sd$gene <-data[,9]

res_counts<- merge(res,sd,by="gene")


res_counts$CondWT <- rowMeans(res_counts[,8:11])
res_counts$CondKO <- rowMeans(res_counts[,12:15])
res_counts <- res_counts[,-c(8:15)]


res_counts$diffexpressed<- ifelse(!is.na(res_counts$pvalue) & !is.na(res_counts$log2FoldChange),
                             ifelse(res_counts$log2FoldChange >  1 & res_counts$pvalue < 0.05, "Upregulated", 
                               ifelse(res_counts$log2FoldChange < -1 & res_counts$pvalue < 0.05, "Downregulated","Not Significant")),"Not Significant") 


colours<- c("pink", "purple", "lightyellow") 
names(colours) <- c("Upregulated", "Downregulated", "Not Significant")

ggplot(data=res_counts, aes(x=log2FoldChange, y=-log10(pvalue), col=diffexpressed)) + 
  geom_point() + 
  geom_vline(xintercept=c(-1, 1), col="darkblue") + 
  geom_hline(yintercept= -log10(0.05), col="darkblue") +
  scale_colour_manual(values = colours)




