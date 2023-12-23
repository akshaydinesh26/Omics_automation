#usr/bin/bash

aligner=$1
inlist1=$2

sample=( $(cut -d ',' -f1 ${inlist1} ) )
readName=( $(cut -d ',' -f2 ${inlist1} ) )

#alternative way of saving columns of csv to arrays not used
#while IFS="," read -r a b;
# do
#  sample+=($a);
#   readName+=($b);
# done < <( cat ${inlist1})

len=($( expr ${#readName[@]} - 1))


if [[ "$aligner" == "bowtie" ]]
then
 for readn in $(seq 0 $len);
  do
   samp=${sample[${readn}]}
   reName=${readName[${readn}]}
   echo "doing for sample $samp"
   echo "doing with readname $reName"
 done
elif [[ "$aligner" == "bowtie2" ]]
then
 for readn in $(seq 0 $len);
  do
   samp=${sample[${readn}]}
   reName=${readName[${readn}]}
   echo "doing for sample $samp"
   echo "doing with readname $reName"
 done
elif [[ "$aligner" == "bwa" ]]
then
 for readn in $(seq 0 $len);
  do
   samp=${sample[${readn}]}
   reName=${readName[${readn}]}
   echo "doing for sample $samp"
   echo "doing with readname $reName"
 done
else
  printf "#error in input\n#aligner input not recogonizable"
fi