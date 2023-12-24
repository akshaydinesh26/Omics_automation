#!/usr/bin/bash

# add threads and picard jar file location
# make sure java is in the path
# add reference of picarf jar file and GATK should be available in path.
# get latest version of GATK and picard
#add index which is the reference genome which was used for alignment and should have dict and fai index created in teh same location.
#add known reference which is gzipped and indexed vxf file
threads=10;
picardRef=;
index=;
knownref=;
#---------------------------------------------------------------------------------------------------------------------------------------
# Program structure
#this script will accomplish processing bam for variant calling(markdup)
# bam files are in input folder produced by alignment.sh script which named with samplename.
# output will produced in markdup folder 
#---------------------------------------------------------------------------------------------------------------------------------------

# run script in folder containing bam files as ./process_bam.sh input_folder
# samtools should be accessible from path.
# get input folder name in a variable

# get list of bam files 
fileName=($(ls *.bam | sed 's/.bam//g'));

#create output folder
mkdir ../processed_bam;
mkdir ../processed_bam/metrics;
mkdir ./temp;
outbin=($(pwd ./processed_bam));
tembin=($(pwd ./temp));
# process
for sample in ${fileName[@]};
 do
  echo "processing the bam file for sample ${sample}";
  #1. sort the bam file
  samsort "${sample}.bam" "${tembin}/${sample}_psort.bam";
  markdup "${tembin}/${sample}_psort.bam" "${tembin}/${sample}_markdup.bam" "${outbin}/metrics/${sample}_metric.txt";
  rm "${tembin}/${sample}_psort.bam";
  recaliberate_build "${tembin}/${sample}_markdup.bam" "${tembin}/${sample}_data.table"
  recaliberate_apply "${tembin}/${sample}_markdup.bam" "${tembin}/${sample}_data.table" "${outbin}/${sample}_processed.bam" 

done

#functions
#1 PICARD SORTSAM
samsort() {
# latest version of picard has done away with "parameter=value" model to "-parameter value" model
bamfile=$1;
outfile=$2;
picard -Xmx7g SortSam \
-I $bamfile \
-O $outfile \
-VALIDATION_STRINGENCY LENIENT \
-SORT_ORDER coordinate \
-MAX_RECORDS_IN_RAM 3000000 \
-CREATE_INDEX True;  
}

#2 picard markdup

markdup() {
infile=$1;
outfile=$2;
metricout=$3;
$picardRef -Xmx7g MarkDuplicates \
-I $infile \
-O $outfile \
-METRICS_FILE $metricout;
} 

# BASE QUALITY RECALIBERATION
#3 gatk BaseRecalibrator & applyBQSR
# build the model
recaliberate_build() {
infile=$1;
outfile=$2;
gatk --java-options "-Xmx7g" BaseRecalibrator \
-I $infile \
-R $index \
--known-sites $knownref \
-O $outfile;
}

#apply the model
recaliberate_apply() {
infile=$1;
inbsqr=$2;
outfile=$3;
gatk --java-options "-Xmx7g" ApplyBQSR \
-I $infile \
-R $index \
--bqsr-recal-file $inbsqr \
-O $outfile;
}
