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
cp ${bamMapDir}${bamMapFile} ${inputDir}${bamMapFile}
cp ${refDir}${refFile} ${inputDir}${refFile}
cp ${exomeBedDir}${exomeBedFile} ${inputDir}${exomeBedFile}
 
