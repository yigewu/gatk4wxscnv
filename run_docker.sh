#!/bin/bash

## Usage: bash gs_localrunbystep.sh {LowPass/HighPass} {cancer} script_to_run

## identifiers
t=$1
c=$2

## combined identifier
d=$t"_"$c

## script name to run
scriptDir=$3
scriptName=$4

## user ID with permission to the input files
uid=$(id -u)


## the path to master directory containing "${toolDirName}" scripts, input dependencies and output directories
toolDirName=$7
mainRunDir=$8

## the path to master directory containing input BAM files
bamDir=$9

## the name of the docker image
imageName=${10}

## the path to the binary file for the language to run inside docker container
binaryFile=${11}

## extra argument for the script
arg=$5

## working directory inside the docker container
workDir=$6

mkdir -p ${mainRunDir}"logs"
mkdir -p ${workDir}

bashCMD="docker run --name "${scriptName}"_"${t}"_"${c}"D"$(date +%Y%m%d%H%M%S)" --user "${uid}" -v "${mainRunDir}":"${mainRunDir}" -v "${bamDir}":"${bamDir}" -w "${workDir}" "${imageName}" "${binaryFile}" "${scriptDir}${scriptName}${arg}

echo ${bashCMD}" >& "${mainRunDir}"logs/"${scriptName}"_"${t}"_"${c}"_"$(date +%Y%m%d%H%M%S)".log &"
echo "disown"
