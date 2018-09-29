#!/bin/bash

## Usage: divide by diesease and make manifest file

mainRunDir=$1
inputDir=${mainRunDir}"inputs/"
outputDir=${mainRunDir}"outputs/"
bamMapFile=$2
toolName=$3
batchName=$4
cancerType=$5
crossmapPath="/diskmnt/Projects/Users/lwang/miniconda3/envs/crossmap/bin/CrossMap.py"
chainfilePath="/diskmnt/Datasets/TCGA/MC3/GRCh38_liftOver/GRCh37_to_GRCh38.chain.gz"

scriptDir=${mainRunDir}${toolName}"."${batchName}"/"
liftinDir=${mainRunDir}"deliverables/"${batchName}"/"
liftoutDir=${liftinDir}"liftover/"
mkdir -p ${liftoutDir} 
cd ${liftoutDir}

## clean up tmp files
rm tmp*
rm header.cnv

bashCMD="bash /home/mwyczalk_test/bin/make_manifest.sh"

while read disease; do
	mkdir -p ${disease}
	bashCMD_disease=${bashCMD}
	grep ${disease} ${inputDir}${bamMapFile} | cut -f 2 | uniq > ${disease}.caseID.txt
	while read caseID; do
		mv ${caseID}.${toolName}.b38.cnv ${disease}"/"
		tmp=${bashCMD_disease}" "${caseID}.${toolName}.b38.cnv
		bashCMD_disease=${tmp}
	done<${disease}.caseID.txt
	cd ${disease}
	${bashCMD_disease} > Manifest.txt
	cd ..
done<${scriptDir}${cancerType}
