#!/bin/bash

mainRunDir=$1
batchName=$2
outputDir=${mainRunDir}"outputs/"${batchName}"/"
outputGSpath=$3

if [ -d ${outputDir} ]; then
	gsutil -m cp -r ${outputDir} ${outputGSpath}
fi
