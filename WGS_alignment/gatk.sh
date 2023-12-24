#!/usr/bin/bash

# add threads and picard jar file location
# make sure java is in the path
# add reference of picarf jar file and GATK should be available in path.
# get latest version of GATK 
# add index which is the reference genome which was used for alignment and should have dict and fai index created in teh same location.
# add known reference which is gzipped and indexed vcf file
index=;
threads=10;

# dont alter anything below
#---------------------------------------------------------------------------------------------------------------------------------------
# execute in the folder containing processed bam file in which markdup script is done.
# get bam file names 
fileName=($(ls *.bam | sed 's/.bam//g'));


#create output folder and temporary directory
mkdir ./variants;
mkdir ./temp;
outbin=($(pwd ./variants));

for file in ${fileName[@]};
do
gatk --java-options "-Xmx7g" HaplotypeCaller \
-I "${file}.bam" \
-R $index \
-ERC GVCF \
-O "${outbin}/${sample}.vcf.gz";
done