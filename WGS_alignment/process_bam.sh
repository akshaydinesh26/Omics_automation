#!/usr/bin/bash

threads=10;
#---------------------------------------------------------------------------------------------------------------------------------------
# Program structure
#this script will accomplish processing bam for variant calling(markdup)
# bam files are in input folder produced by alignment.sh script which named with samplename.
# output will produced in markdup folder 
#---------------------------------------------------------------------------------------------------------------------------------------

# run script in folder containing bam files as ./process_bam.sh input_folder
# samtools should be accessible from path.
# get input folder name in a variable
inpbin=$1;

# get list of bam files 
fileName=($(ls *.bam | sed 's/.bam//g'));

#create output folder
mkdir ../markdup_bam;
mkdir ./temp;
outbin=($(pwd ./markdup_bam));
tembin=($(pwd ./temp));
# process
for sample in ${fileName[@]};
 do
  echo "processing the bam file for sample ${sample}"
  samtools sort -@ $threads -n -o "${tembin}/${sample}_nsort.bam" "${sample}.bam";
  samtools fixmate -m "${tembin}/${sample}_nsort.bam" "${tembin}/${sample}_fixmate.bam";
  rm "${tembin}/${sample}_nsort.bam";
  samtools sort -@ $threads -o "${tembin}/${sample}_psort.bam" "${tembin}/${sample}_fixmate.bam";
  rm "${tembin}/${sample}_fixmate.bam";
  samtools markdup "${tembin}/${sample}_psort.bam" "${outbin}/${sample}_markdup.bam";
  rm "${tembin}/${sample}_psort.bam";
done