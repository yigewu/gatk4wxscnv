#!/bin/bash

mainRunDir=$1
inputDir=${mainRunDir}"inputs/"

bamMapDir=$2
bamMapFile=$3
refDir=$4
refFile=$5
exomeBedDir=$6
exomeBedFile=$7

## copy BamMaps
if [ -s ${inputDir}${bamMapFile} ]
then
	echo "bamMap is available"
else
	echo "bamMap is being copied"
	cp ${bamMapDir}${bamMapFile} ${inputDir}${bamMapFile}
fi

## copy reference file
if [ -s ${inputDir}${refFile} ]
then
        echo "refFile is available"
else
        echo "refFile is being copied"
	cp ${refDir}${refFile} ${inputDir}${refFile}
fi

## copy exome bed file
if [ -s ${inputDir}${exomeBedFile} ]
then
        echo "exome target bed file is available"
else
        echo "exome target bed file is being copied"
	cp ${exomeBedDir}${exomeBedFile} ${inputDir}${exomeBedFile}
fi

cd ${inputDir}
wget https://github.com/broadinstitute/picard/releases/download/2.18.14/picard.jar
wget ftp://webdata2:webdata2@ussd-ftp.illumina.com/documentation/Chemistry_Documentation/SamplePreps_Nextera/NexteraRapidCapture/NexteraRapidCapture_Exome_Probes_v1.2.txt

