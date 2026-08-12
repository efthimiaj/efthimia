#!/bin/bash

#current working directory: /home/efthimia


#fetch the tar file from the canonical location at NCBI
wget --output-document sratoolkit.tar.gz https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz

#extract the contents of the tar file
tar -vxzf sratoolkit.tar.gz

#add toolkit to path
export PATH=/home/efthimia/sratoolkit.3.2.1-ubuntu64/bin:$PATH


#Verify that the binaries will be found by the shell
which fastq-dump


#make the directory for the downloaded by prefetch files
mkdir fastq
cd fastq

#make the directory for the temporary files
mkdir tmp


#maybe loop through the SRRs
for run in $(cat ../SRR/accessions.txt); do
echo "processing $run"

#download the file
prefetch "$run"

#convert to fastq format with fasterq-dump, -t for temporary directory and -p for multithreading(?)      
fasterq-dump -p -t /home/efthimia/fastq/tmp --outdir /home/efthimia/fastq/"$run"

#gzip the fastq files
gzip "${run}"*.fastq

echo "$run is completed"

done
