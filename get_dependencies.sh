#!/bin/bash

mainRunDir=$1
inputDir=${mainRunDir}"inputs/"
bamMapprefix=$2
refGSpath=$3
refFile=$4
exomeBedFile=$5
inputGSpath=$6

mkdir -p ${inputDir}
## copy BamMaps
for sample_type in tumor normal; do
	bamMapFile=${bamMapprefix}"."${sample_type}".bam_gcs_url.txt"
	baiMapFile=${bamMapprefix}"."${sample_type}".bam_gcs_url.txt"
	bamNameFile=${bamMapprefix}"."${sample_type}".bam_filename.txt"
	if [ -s ${inputDir}${bamMapFile} ]
	then
		echo "bamMap is available"
	else
		echo "bamMap is being copied"
		gsutil -m cp ${inputGSpath}${bamMapFile} ${inputDir}
	fi
	if [ -s ${inputDir}${baiMapFile} ]
	then
		echo "baiMap is available"
	else
		echo "baiMap is being copied"
		gsutil -m cp ${inputGSpath}${baiMapFile} ${inputDir}
	fi
	if [ -s ${inputDir}${bamNameFile} ]
	then
		echo "bam name file is available"
	else
		echo "bam name file is being copied"
		gsutil -m cp ${inputGSpath}${bamNameFile} ${inputDir}
	fi
done

## copy reference file
if [ -s ${inputDir}${refFile} ]
then
        echo "refFile is available"
else
        echo "refFile is being copied"
	gsutil -m cp ${refGSpath} ${inputDir}
fi

## copy exome bed file
if [ -s ${inputDir}${exomeBedFile} ]
then
        echo "exome target bed file is available"
else
        echo "exome target bed file is being copied"
	gsutil -m cp ${inputGSpath}${exomeBedFile} ${inputDir}
fi

## get the latest image
docker pull broadinstitute/gatk

echo "all dependencies complete!"
echo ""
