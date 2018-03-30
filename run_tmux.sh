#!/bin/bash

## Usage: bash run_tmux.sh {tumor/normal} {CCRC/UCEC} {script_name_to_run} 

## batch identifiers, t for date for differentiating runs, c for cancer type
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

bashCMD="tmux new-session -d -s "${toolDirName}"_"${scriptName}"_"${t}"_"${c}" 'docker run --user "${uid}":"${gid}" -v "${mainRunDir}":"${mainRunDir}" -v "${bamDir}":"${bamDir}" -w "${workDir}" "${imageName}" "${binaryFile}" "${scriptDir}${scriptName}${arg}" |& tee "${mainRunDir}"logs/"${scriptName}"_"${t}"_"${c}".log'" 
echo $bashCMD
#$bashCMD
