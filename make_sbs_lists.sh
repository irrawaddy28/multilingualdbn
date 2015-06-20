#!/bin/bash
# Create unsupervised training list file for sbs data

corpus=/ws/rz-cl-2/hasegawa/amitdas/corpus/www.sbs.com.au
listdir=$corpus/lists
wavdir=$corpus/seg2

# E.g. 
# This creates the unsupervised train list file for albanian which is = {all albanian audio clips} \ {sup. train  set + sup. test set + discarded set}
# cd  $corpus/lists/albanian
# comm -13  <(awk '{print $1}' albanian.txt|sort -u) <(find $corpus/seg2/albanian -type f -iname "*.wav"|sort -u|awk -F"/" '{print $NF}') > train.unsupervised.txt

langdirs=$(find $listdir -mindepth 1 -type d)
for dir in `echo $langdirs`; do	
	lang=$(echo $dir|awk -F"/" '{print $NF}')	
	comm -13  <(awk '{print $1}' ${dir}/${lang}.txt|sort -u) <(find ${wavdir}/$lang -type f -iname "*.wav"|sort -u|awk -F"/" '{print $NF}') > ${dir}/train.unsupervised.txt
	echo "$lang: created  ${dir}/train.unsupervised.txt"
done
