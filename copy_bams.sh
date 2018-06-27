#!/bin/bash

mainRunDir=$1
inputDir=${mainRunDir}"inputs/"

bamDir=${mainRunDir}"bams/"
mkdir -p ${bamDir}

bamMapprefix=$2
logDir=${mainRunDir}"logs/"
batchName=$3

for sample_type in tumor normal; do
	subBamDir=${bamDir}${sample_type}"/"
	mkdir -p ${subBamDir}

	subBamMap=${inputDir}${bamMapprefix}"."${sample_type}".bam_gcs_url.txt"
	subBamName=${inputDir}${bamMapprefix}"."${sample_type}".bam_filename.txt"
	subBam2copy=${inputDir}${sample_type}"bams2copy.txt" 
	touch ${subBam2copy} > ${subBam2copy}
	while read bam_name; do
		echo ${bam_name}
		if [ -s ${subBamDir}${bam_name} ];
		then
			echo ${bam_name}" copied!"
		else
			cat ${subBamMap} | grep ${bam_name} >> ${subBam2copy}
		fi
	done<${subBamName}
	cat ${subBam2copy} | gsutil -m cp -c -L ${subBamDir}"cp.log" -I ${subBamDir}
done
