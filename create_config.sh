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

for j in CCRC UCEC; do
	touch "config_"${j}".yml" > "config_"${j}".yml"
	echo "JAVAPATH: '"${javaPath}"'" >> "config_"${j}".yml"
	echo "GATKPATH: '"${gatkPath}"'" >> "config_"${j}".yml"
	echo "referencePath: '"${inputDir}${refFile}"'" >> "config_"${j}".yml"
	echo "exomeBedPath: '"${inputDir}${exomeBedFile}"'" >> "config_"${j}".yml"
	echo "outputDIR: '"${outputDir}${j}"/"${j}"'" >> "config_"${j}".yml"
	echo "normalBamPaths: '"${inputDir}${bamMapFile}"_"${bamType}"_normal_"${j}".list'" >> "config_"${j}".yml"
	echo "cancerBamPaths: '"${inputDir}${bamMapFile}"_"${bamType}"_tumor_"${j}".list'" >> "config_"${j}".yml"

	## make output directories
	mkdir -p ${outputDir}${j}"/"${j}
done
