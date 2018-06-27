#!/bin/bash

## the name of the master directory holding inputs, outputs and processing codes
toolName="gatk4wxscnv"
## the name the directory holding the processing code
toolDirName=${toolName}
## the path to the master directory
mainRunDir="/home/yigewu2012/"
## the google cloud bucket path to inputs
inputGSpath="gs://dinglab/yige/gatk4wxscnv/inputs/"
## the google cloud bucket path to outputs
outputGSpath="gs://dinglab/yige/gatk4wxscnv/outputs/"
## the path to the directory holding the reference fasta file
refGSpath="gs://dinglab/reference/Homo_sapiens_assembly19.fasta"
## the name of the reference fasta file
refFile="Homo_sapiens_assembly19.fasta"
## the name of the exome target bed file, needs to be edited!
exomeBedFile="SureSelect_All_Exon_V2_with_annotation.hg19.bed"
## the name of the batch
batchName=${exomeBedFile}
## the name of the manifiest for BAM files
bamMapprefix=${batchName}
## the type of the BAM file
bamType="WXS"
## the path to the java binary
javaPath="/usr/bin/java"
## the path to the gatk jar file
gatkPath="/home/software/gatk-4.beta.5/gatk-package-4.beta.5-local.jar"
## the path to the parent directory containing input BAM files
bamDir=${mainRunDir}"bams/"
## the name of the docker image
imageName="yigewu/gatk4wxscnv:v1"
## the path to the binary file for the language to run inside docker container
binaryFile="/miniconda3/bin/python3"
## the date of the processing
id=$1
if [ $# -eq 0 ]
  then
    echo "No date supplied!"
    exit 1
fi
## the name of the processing version
version=1.0
## the file prefix for the gene-level CNV report
genelevelFile="gene_level_CNV"
## the file containing the cancer types to be processed
cancerType="cancer_types.txt"
## tissue type of the normal samples
normalType="blood"
## the path to local directory holding the log files
logDir=${mainRunDir}"logs/"

## prep_vm.sh and config_disks.sh should only run once
## mount new disk

if  grep -Fq ${batchName} ${logDir}"completed_batchName.txt"
then
	echo "${batchName} already completed!"
else
	cm="bash config_disks.sh ${mainRunDir}"

	## get dependencies into inputs directory, so as to not potentially change the original dependency files
	cm="bash get_dependencies.sh ${mainRunDir} ${bamMapprefix} ${refGSpath} ${refFile} ${exomeBedFile} ${inputGSpath}"
	${cm}

	## split the paths to the bam files into batches
	cm="bash copy_bams.sh ${mainRunDir} ${bamMapprefix} ${batchName}"
	${cm}

	## create configure files
	cm="bash create_config.sh ${mainRunDir} ${bamMapprefix} ${bamType} ${javaPath} ${gatkPath} ${refFile} ${exomeBedFile} ${batchName} ${cancerType} ${normalType}"
	${cm}

	## use tmux to run jobs
	while read j
	do
		bash run_docker.sh ${id} ${j} "/home/software/gatk4wxscnv/" "gatk4wxscnv.py" " --config "${mainRunDir}${toolDirName}"/config_"${j}".yml" ${mainRunDir}"outputs/"${batchName}"/"${j} ${toolDirName} ${mainRunDir} ${bamDir} ${imageName} ${binaryFile} 
	done<${cancerType}

	## copy output to google storage
	cm="bash copy_output.sh ${mainRunDir} ${batchName} ${outputGSpath}"
	${cm}

fi

## get gene-level copy number values
cm="bash get_gene_level_cnv.sh ${mainRunDir} ${bamMapprefix} ${bamType} ${javaPath} ${gatkPath} ${refFile} ${exomeBedFile} ${batchName} ${genelevelFile} ${version} ${id} ${cancerType} ${toolDirName}"
echo ${cm}

## format outputs and copy to deliverables
cm="bash rename_output.sh ${mainRunDir} ${bamMapprefix} ${toolName} ${batchName} ${cancerType} ${toolDirName}"
echo ${cm}

cm="bash push_git.sh ${batchName} ${version}"
echo ${cm}

## clean up docker containers
cm="bash clean_docker_containers.sh ${imageName}"
echo $cm

