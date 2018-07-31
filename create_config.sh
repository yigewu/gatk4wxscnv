#!/bin/bash

mainRunDir=$1
bamMapFile=$2
inputDir=${mainRunDir}"inputs/"
outputDir=${mainRunDir}"outputs/"
bamType=$3
javaPath=$4
gatkPath=$5
refFile=$6
exomeBedFile=$7
batchName=$8
cancerType=$9
normalType=${10}

mkdir -p ${outputDir}${batchName}
while read j
do
	touch "config_"${j}".yml" > "config_"${j}".yml"
	echo "JAVAPATH: '"${javaPath}"'" >> "config_"${j}".yml"
	echo "GATKPATH: '"${gatkPath}"'" >> "config_"${j}".yml"
	echo "referencePath: '"${inputDir}${refFile}"'" >> "config_"${j}".yml"
	echo "exomeBedPath: '"${inputDir}${exomeBedFile}"'" >> "config_"${j}".yml"
	echo "outputDIR: '"${outputDir}${batchName}"/"${j}"/'" >> "config_"${j}".yml"
	echo "normalBamPaths: '"${inputDir}${bamMapFile}"_"${bamType}"_"${normalType}"_normal_"${j}".list'" >> "config_"${j}".yml"
	echo "cancerBamPaths: '"${inputDir}${bamMapFile}"_"${bamType}"_tumor_"${j}".list'" >> "config_"${j}".yml"

	## make output directories
	mkdir -p ${outputDir}${batchName}"/"${j}
done<${cancerType}
echo "created the config files!"
