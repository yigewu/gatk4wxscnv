#!/bin/bash

## the name of the master directory holding inputs, outputs and processing codes
toolName="gatk4wxscnv"
## the name of the batch
batchName="CPTAC3.b4.GC_corrected"
## the name the directory holding the processing code
toolDirName=${toolName}"."${batchName}
## the path to the master directory
mainRunDir="/diskmnt/Projects/CPTAC3CNV/"${toolName}"/"
## the path to the directory holding the manifest for BAM files
bamMapDir="/diskmnt/Projects/cptac_downloads/data/GDC_import/import.config/CPTAC3.b4/"
## the name of the manifiest for BAM files
bamMapFile="CPTAC3.b4.BamMap.dat"
## the path to the directory holding the reference fasta file
refDir=" /diskmnt/Projects/Users/mwyczalk/data/docker/data/A_Reference/"
## the name of the reference fasta file
refFile="Homo_sapiens_assembly19.fasta"
## the path to the directory holding the exome target bed file
exomeBedDir="/diskmnt/Projects/cptac/gatk4wxscnv/target_bed/"
## the name of the exome target bed file
exomeBedFile="nexterarapidcapture_exome_targetedregions_v1.2.bed"
## the type of the BAM file
bamType="WXS"
## the path to the java binary
javaPath="/usr/bin/java"
## the path to the gatk jar file
gatkPath="/home/software/gatk-4.beta.5/gatk-package-4.beta.5-local.jar"
## the path to the parent directory containing input BAM files
bamDir="/diskmnt/Projects/cptac_downloads/data/GDC_import"
## the name of the docker image
imageName="yigewu/gatk4wxscnv:v1"
## the path to the binary file for the language to run inside docker container
binaryFile="/miniconda3/bin/python3"
## the date of the processing
id=$1
if [ $# -eq 0 ]
  then
    echo "No date supplied"
    exit 1
fi
## the name of the processing version
version=1.1
## the file prefix for the gene-level CNV report
genelevelFile="gene_level_CNV"
## the file containing the cancer types to be processed
cancerType="cancer_types.txt"
## tissue type of the normal samples
normalType="blood"
inputDir=${mainRunDir}"inputs/"
outputDir=${mainRunDir}"outputs/"

## get dependencies into inputs directory, so as to not potentially change the original dependency files
cm="bash get_dependencies.sh ${mainRunDir} ${bamMapDir} ${bamMapFile} ${refDir} ${refFile} ${exomeBedDir} ${exomeBedFile}"
#${cm}

## split the paths to the bam files into batches
cm="bash split_bam_path.sh ${mainRunDir} ${bamMapFile} ${bamType} ${cancerType} ${normalType}"
${cm}

## create configure files
cm="bash create_config.sh ${mainRunDir} ${bamMapFile} ${bamType} ${javaPath} ${gatkPath} ${refFile} ${exomeBedFile} ${batchName} ${cancerType} ${normalType}"
${cm}

## use tmux to run jobs
while read j
do
	bash run_tmux.sh ${id} ${j} ${mainRunDir}${toolDirName}'/' "gatk4wxscnv.py" " --config "${mainRunDir}${toolDirName}"/config_"${j}".yml" ${mainRunDir}"outputs/"${batchName}"/"${j} ${toolDirName} ${mainRunDir} ${bamDir} ${imageName} ${binaryFile} 
done<${cancerType}

## get gene-level copy number values
cm="bash get_gene_level_cnv_by_case.sh ${mainRunDir} ${bamMapFile} ${bamType} ${javaPath} ${gatkPath} ${refFile} ${exomeBedFile} ${batchName} ${genelevelFile} ${version} ${id} ${cancerType} ${toolDirName}"
echo ${cm}

## format outputs and copy to deliverables
cm="bash rename_output.sh ${mainRunDir} ${bamMapFile} ${toolName} ${batchName} ${cancerType} ${toolDirName}"
echo ${cm}

## liftover .cnv output to build 38
cm="bash liftover_cnv.sh ${mainRunDir} ${bamMapFile} ${toolName} ${batchName} ${cancerType} ${toolDirName} &>${mainRunDir}logs/liftover_${batchName}.txt"
echo ${cm}

cm="bash make_manifest.sh ${mainRunDir} ${bamMapFile} ${toolName} ${batchName} ${cancerType} ${toolDirName}"
echo ${cm}

## clean up docker containers
cm="bash clean_docker_containers.sh ${imageName}"
echo $cm

## push current git repository to remote
cm="bash push_git.sh ${batchName} ${version}"
echo ${cm}
