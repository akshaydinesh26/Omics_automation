# TEST FOR READING INPUT OF FILES 

#/usr/bin/bash
infile=$1;

while IFS="," read -r a b;
 do
  ar1+=($a);
  ar2+=($b);
done < <( cat ${infile})

for i in ${ar2[@]};
 do
  echo "doing for $i";
  echo $i;
done