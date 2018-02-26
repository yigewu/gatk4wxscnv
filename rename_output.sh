#!/bin/bash

## Usage: rename the output to consistent format

mainRunDir=$1
inputDir=${mainRunDir}"inputs/"
outputDir=${mainRunDir}"outputs/"
bamMapFile=$2
toolDirName=$3

for j in CCRC UCEC; do
	cd ${outputDir}${j}
	mkdir -p tmp
	ls *cnv  > tmp/output_list
	while IFS= read -r filename; do
		echo ${filename} | awk -F ${j} '{print $2}' | awk -F '.' '{print $1}' > tmp/tmp_specimen
		cat tmp/tmp_specimen | grep -f - ${inputDir}${bamMapFile} | awk -F '\\s' '{print $2}' | uniq > tmp/tmp_case

		cp ${filename} ${mainRunDir}"deliverables/"$(cat tmp/tmp_case)"."${toolDirName}".cnv"
	done < tmp/output_list
done
