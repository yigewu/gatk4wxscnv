#!/bin/bash

## the path to master directory containing "${toolDirName}" scripts, input dependencies and output directories
toolDirName="gatk4wxscnv"
mainRunDir="/diskmnt/Projects/CPTAC3CNV/"${toolDirName}"/"
bamMapDir="/diskmnt/Projects/cptac/GDC_import/import.config/CPTAC3.b2/"
bamMapFile="CPTAC3.b2.BamMap.dat"
refDir=" /diskmnt/Projects/Users/mwyczalk/data/docker/data/A_Reference/"
refFile="Homo_sapiens_assembly19.fasta"
exomeBedDir="/diskmnt/Projects/cptac/gatk4wxscnv/target_bed/"
exomeBedFile="nexterarapidcapture_exome_targetedregions_v1.2.bed"

bamType="WXS"
javaPath="/usr/bin/java"
gatkPath="/home/software/gatk-4.beta.5/gatk-package-4.beta.5-local.jar"

id=$1

## get dependencies into inputs directory, so as to not potentially change the original dependency files
bash get_dependencies.sh ${mainRunDir} ${bamMapDir} ${bamMapFile} ${refDir} ${refFile} ${exomeBedDir} ${exomeBedFile}
wait

## split the paths to the bam files into batches
bash split_bam_path.sh ${mainRunDir} ${bamMapFile} ${bamType}
wait

## create configure files
bash create_config.sh ${mainRunDir} ${bamMapFile} ${bamType} ${javaPath} ${gatkPath} ${refFile} ${exomeBedFile}
wait

## use tmux to run jobs
for c in CCRC UCEC; do
	bash run_tmux.sh ${id} ${c} "/home/software/gatk4wxscnv/" "gatk4wxscnv.py" " --config "${mainRunDir}${toolDirName}"/config_"${c}".yml" ${mainRunDir}"outputs/"${c} 
done
exit 1

## format outputs and copy to deliverables
bash rename_output.sh ${mainRunDir} ${bamMapFile} ${toolDirName}

