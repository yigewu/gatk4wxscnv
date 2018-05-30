#!/bin/bash

## Usage: rename the output to consistent format

mainRunDir=$1
inputDir=${mainRunDir}"inputs/"
outputDir=${mainRunDir}"outputs/"
bamMapFile=$2
toolName=$3
batchName=$4
cancerType=$5

mkdir -p ${mainRunDir}"deliverables/"${batchName}
while read j
do
	cd ${outputDir}${batchName}"/"${j}
	mkdir -p tmp
	ls *cnv  > tmp/output_list
	while IFS= read -r filename; do
		echo ${filename} | awk -F '.' '{print $1}' > tmp/tmp_specimen
		cat tmp/tmp_specimen | grep -f - ${inputDir}${bamMapFile} | awk -F '\\s' '{print $2}' | uniq > tmp/tmp_case

		cp ${filename} ${mainRunDir}"deliverables/"${batchName}"/"$(cat tmp/tmp_case)"."${toolName}".cnv"
	done < tmp/output_list
done<${cancerType}
