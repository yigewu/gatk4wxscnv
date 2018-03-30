#!/bin/bash

## the path to master directory containing "${toolDirName}" scripts, input dependencies and output directories
toolName="gatk4wxscnv"
batchName="b3"
toolDirName=${toolName}"."${batchName}
mainRunDir="/diskmnt/Projects/CPTAC3CNV/"${toolName}"/"
bamMapDir="/diskmnt/Projects/cptac_downloads/data/GDC_import/import.config/CPTAC3.b3/"
bamMapFile="CPTAC3.b3.BamMap.dat"
refDir=" /diskmnt/Projects/Users/mwyczalk/data/docker/data/A_Reference/"
refFile="Homo_sapiens_assembly19.fasta"
exomeBedDir="/diskmnt/Projects/cptac/gatk4wxscnv/target_bed/"
exomeBedFile="nexterarapidcapture_exome_targetedregions_v1.2.bed"
bamType="WXS"
javaPath="/usr/bin/java"
gatkPath="/home/software/gatk-4.beta.5/gatk-package-4.beta.5-local.jar"
## the path to master directory containing input BAM files
bamDir="/diskmnt/Projects/cptac_downloads/data/GDC_import"
## the name of the docker image
imageName="yigewu/gatk4wxscnv:v1"
## the path to the binary file for the language to run inside docker container
binaryFile="/miniconda3/bin/python3"
id=$1

## get dependencies into inputs directory, so as to not potentially change the original dependency files
cm="bash get_dependencies.sh ${mainRunDir} ${bamMapDir} ${bamMapFile} ${refDir} ${refFile} ${exomeBedDir} ${exomeBedFile}"
echo ${cm}

## split the paths to the bam files into batches
cm="bash split_bam_path.sh ${mainRunDir} ${bamMapFile} ${bamType}"
echo ${cm}

## create configure files
cm="bash create_config.sh ${mainRunDir} ${bamMapFile} ${bamType} ${javaPath} ${gatkPath} ${refFile} ${exomeBedFile} ${batchName}"
echo ${cm}

## use tmux to run jobs
for j in CCRC UCEC; do
	bash run_tmux.sh ${id} ${j} "/home/software/gatk4wxscnv/" "gatk4wxscnv.py" " --config "${mainRunDir}${toolDirName}"/config_"${j}".yml" ${mainRunDir}"outputs/"${batchName}"/"${j} ${toolDirName} ${mainRunDir} ${bamDir} ${imageName} ${binaryFile} 
done

## format outputs and copy to deliverables
cm="bash rename_output.sh ${mainRunDir} ${bamMapFile} ${toolName} ${batchName}"
echo ${cm}

