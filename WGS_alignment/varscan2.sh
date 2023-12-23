#/usr/bin/bash
#!/usr/bin/bash

#create .fai indexed index 
# with samtools faidx input_reference.fasta
#reference index
#add varscan2 jarfile location
index=;
varscanRef=;

# get file names of the bam file.
# samtools and varscan2 should be available in the path.
#java compatible with varscan jar file should be in path.
# change below to change varscan parameters
avgQual=15;
minCov=8;
minVarCount=2;
pval=0.00001;


# dont alter anything below
#---------------------------------------------------------------------------------------------------------------------------------------
# execute in the folder containing processed bam file in which markdup script is done.
# get bam file names 
fileName=($(ls *.bam | sed 's/.bam//g'));


#create output folder and temporary directory
mkdir ./variants;
mkdir ./variants/snp;
mkdir ./variants/indel;
mkdir ./temp;
outbin=($(pwd ./variants));
tembin=($(pwd ./temp));

for file in ${fileName[@]};
do
 #mpileup
 samtools mpileup -f $index -s "${file}.bam" -o "${tembin}/${file}.mpileup";
 #variant calling
 java -jar $varscanRef mpileup2snp "${tembin}/${file}.mpileup" --min-coverage $minCov --min-read2 $minVarCount --min-avg-qual $avgQual --p-value $pval --output-vcf 1 > "${outbin}/snp/${file}_snp.vcf";
 java -jar $varscanRef mpileup2indel "${tembin}/${file}.mpileup" --min-coverage $minCov --min-read2 $minVarCount --min-avg-qual $avgQual --p-value $pval --output-vcf 1 > "${outbin}/snp/${file}_indel.vcf";
done