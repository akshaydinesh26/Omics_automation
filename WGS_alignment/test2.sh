#/usr/bin/bash

aligner=$1

if [[ "$aligner" == "bowtie" ]]
then
 echo " its bowtie"
elif [[ "$aligner" == "bowtie2" ]]
then
  echo " its bowtie2"
elif [[ "$aligner" == "bwa" ]]
then
  echo " its bwa mem"
else
  printf "#error in input\n#aligner input not recogonizable"
fi