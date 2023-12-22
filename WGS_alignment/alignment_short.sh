/usr/bin/bash
# this is alignment file for paired end short reads.
# make sure bowtie2/bowtie/bwa mem which you will use is accessible from path and also samtools.
# assign number of threads to be used by aligner
# and add the index to be used
thread=10;
index=;

# make a comma seperated file(inlist) of input reads as "sample_name,readname". readname should be common for both reads.
# execute this script as ./alignment_short.sh inlist output_folder aligner_name.
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
aligner=$3;


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

#considering only bowtie2 or bwa mem or bowtie now.
#if statements for aligner choise which excecutes different commands




if [[ "$aligner" == "bowtie" ]]
then
 for readn in $(seq 0 $len);
  do
   samp=${sample[${readn}]}
   reName=${readName[${readn}]}
   echo "executing bowtie with sample $samp"
   bowtie_1 $thread $reName $samp
 done
elif [[ "$aligner" == "bowtie2" ]]
then
 for readn in $(seq 0 $len);
  do
   samp=${sample[${readn}]}
   reName=${readName[${readn}]}
   echo "executing bowtie2 with sample $samp"
   bowtie_2 $thread $reName $samp
 done
elif [[ "$aligner" == "bwa" ]]
then
 for readn in $(seq 0 $len);
  do
   samp=${sample[${readn}]}
   reName=${readName[${readn}]}
   echo "executing bwa mem with sample $samp"
   bwa_1 $thread $reName $samp
 done
else
  printf "#error in input\n#aligner input not recogonizable"
fi

#functions of aligners 
# for function input
# $1 -- threads required by program
# $2 -- readName as input
# $3 -- output file name will be sampleaname
#bowtie2
bowtie_2() {
  local threads=$1
  local read1="${2}_1.fq.gz"
  local read2="${2}_2.fq.gz"
  local output="${outbin}/${3}.bam"
  bowtie2 -p $threads -x $index -1 $read1 -2 $read2 | samtools view -@ $threads -bs -o $output -
}

#bowtie
bowtie_1() {
  local threads=$1
  local read1="${2}_1.fq.gz"
  local read2="${2}_2.fq.gz"
  local output="${outbin}/${3}.bam"
  bowtie -p $threads -x $index -1 $read1 -2 $read2 | samtools view -@ $threads -bs -o $output -
}

#bwa mem
bwa_1() {
  local threads=$1
  local read1="${2}_1.fq.gz"
  local read2="${2}_2.fq.gz"
  local output="${outbin}/${3}.bam"
  bwa mem -t $threads $index $read1 $read2 | samtools view -@ $threads -bs -o $output -
}
