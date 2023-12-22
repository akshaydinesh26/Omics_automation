/usr/bin/bash
# this is alignment file for paired end short reads with hisat2.
# make sure hisat2 which you will use is accessible from path and also samtools.
# assign number of threads to be used by aligner
# and add the index to be used
thread=10;
index=;

# make a comma seperated file(inlist) of input reads as "sample_name,readname". readname should be common for both reads.
# execute this script as ./alignment_short.sh inlist output_folder.
# after adding above execute the 
# dont alter anything below
# --------------------------------------------------------------------------------------------------------------------
#execute in the same folder with the read files
#for easy usage folders will end with tag "bin" prceded by 3 letter unique code like "out".
#input files will be "inlist" followed by a number like "inlist1".
#inlist will contain two columns one "unique sample id which will be 4 letter code-which can include letter" and 
#two "unique read name so that if paired-end both the sample should have the same name followed by _[1/2]" like "SAM1_1"
#inlist is csv file without header and ends in a newline

inlist1=$1;
outbin=$2;


#make inlist files available to 2 variables sample and readName
sample=( $(cut -d ',' -f1 ${inlist1} ) )
readName=( $(cut -d ',' -f2 ${inlist1} ) )
#alternative way of accoumplishing above
# while IFS="," read -r a b;
#  do
#   sample+=($a);
#   readName+=($b);
# done < <( cat ${inlist1})

#save number of samples available to a variable for for loop
len=($( expr ${#readName[@]} - 1))

#aligner is hisat2
for readn in $(seq 0 $len); 
do
 samp=${sample[${readn}]};
 reName=${readName[${readn}]};
 hisat2 $thread $reName $samp;
done


#bowtie
hisat_2() {
  local threads=$1
  local read1="${2}_1.fq.gz"
  local read2="${2}_2.fq.gz"
  local output="${outbin}/${3}.bam"
  hisat2 -p $threads -x $index -1 $read1 -2 $read2 | samtools view -@ $threads -bs -o $output -
}


