#!/bin/bash

## Usage: bash run_tmux.sh {tumor/normal} {CCRC/UCEC} {script_name_to_run} 

## batch identifiers, t for tumor/normal, c for cancer type
t=$1
c=$2

## script name to run
scriptDir=$3
scriptName=$4

## user ID with permission to the input files
uid=$(id -u)

## group ID with permission to the input files
gid="2001"

## the path to master directory containing "${toolDirName}" scripts, input dependencies and output directories
toolDirName="gatk4wxscnv"
mainRunDir="/diskmnt/Projects/CPTAC3CNV/"${toolDirName}

## the path to master directory containing input BAM files
bamDir="/diskmnt/Projects/cptac/GDC_import"

## the name of the docker image
imageName="yigewu/gatk4wxscnv:v1"

## the path to the binary file for the language to run inside docker container
binaryFile="/miniconda3/bin/python3"

## extra argument for the script
arg=$5

## working directory inside the docker container
workDir=$6

bashCMD="tmux new-session -d -s "${toolDirName}"_"${scriptName}"_"${t}"_"${c}" 'docker run --user "${uid}":"${gid}" -v "${mainRunDir}":"${mainRunDir}" -v "${bamDir}":"${bamDir}" -w "${workDir}" "${imageName}" "${binaryFile}" "${scriptDir}${scriptName}${arg}" |& tee "${scriptName}"_"${t}"_"${c}".log'" 
echo $bashCMD
#$bashCMD
