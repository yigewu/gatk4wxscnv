#!/bin/bash

mainRunDir=$1
bamMapFile=$2
inputDir=${mainRunDir}"inputs/"
bamType=$3
cancerType=$4
normalType=$5

for i in tumor; do
    while read j
	do
        grep -i ${i} ${inputDir}${bamMapFile} | grep -i ${j} | grep -i ${bamType} |  awk -F '\\s' '{print $6}' | awk -F 'import' '{print $1"import"$2}' > ${inputDir}${bamMapFile}"_"${bamType}"_"${i}"_"${j}".list" 
    	done<${cancerType}
done

for i in normal; do
    while read j
        do
        grep -i ${normalType} ${inputDir}${bamMapFile} | grep -i ${i} | grep -i ${j} | grep -i ${bamType} |  awk -F '\\s' '{print $6}' | awk -F 'import' '{print $1"import"$2}' > ${inputDir}${bamMapFile}"_"${bamType}"_"${normalType}"_"${i}"_"${j}".list"
        done<${cancerType}
done
echo "split the BAMs map file!"
