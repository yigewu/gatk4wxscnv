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
	configFile="config_"${j}".yml"
	touch ${configFile} > ${configFile}
	echo "JAVAPATH: '"${javaPath}"'" >> ${configFile}
	echo "GATKPATH: '"${gatkPath}"'" >> ${configFile}
	echo "referencePath: '"${inputDir}${refFile}"'" >> ${configFile}
	echo "exomeBedPath: '"${inputDir}${exomeBedFile}"'" >> ${configFile}
	echo "outputDIR: '"${outputDir}${batchName}"/"${j}"/'" >> ${configFile}
	echo "normalBamPaths: '"${inputDir}${bamMapFile}"_"${bamType}"_"${normalType}"_normal_"${j}".list'" >> ${configFile}
	echo "cancerBamPaths: '"${inputDir}${bamMapFile}"_"${bamType}"_tumor_"${j}".list'" >> ${configFile}

	## make output directories
	mkdir -p ${outputDir}${batchName}"/"${j}
done<${cancerType}

mkdir -p ${outputDir}${batchName}
while read j
do
	configFile="config_"${j}"_"${normalType}"_normal.yml"
	outDir=${outputDir}${batchName}"/"${j}"_germline/"
        touch ${configFile} > ${configFile}
        echo "JAVAPATH: '"${javaPath}"'" >> ${configFile}
        echo "GATKPATH: '"${gatkPath}"'" >> ${configFile}
        echo "referencePath: '"${inputDir}${refFile}"'" >> ${configFile}
        echo "exomeBedPath: '"${inputDir}${exomeBedFile}"'" >> ${configFile}
        echo "outputDIR: '"${outDir}"'" >> ${configFile}
        echo "normalBamPaths: '"${inputDir}${bamMapFile}"_"${bamType}"_"${normalType}"_normal_"${j}".list'" >> ${configFile}
        echo "cancerBamPaths: '"${inputDir}${bamMapFile}"_"${bamType}"_"${normalType}"_normal_"${j}".list'" >> ${configFile}
        ## make output directories
        mkdir -p ${outDir}
done<${cancerType}
echo "created the config files!"
