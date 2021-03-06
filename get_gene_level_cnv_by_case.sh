#!/bin/bash
## get gene-level copy number values
## modified from 

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
outputbatchDir=${outputDir}${batchName}"/"
genelevelFile=$9
version=${10}
id=${11}
cancerType=${12}
toolDirName=${13}

while read j
do
	mkdir -p ${outputbatchDir}${j}"/gene_level_by_case"
	cd ${outputbatchDir}${j}
	ls *.seg | while read file; do
		sample=$(echo $file | cut -f1 -d'.')
		case=$(echo $sample | grep -f - ${inputDir}${bamMapFile} | awk -F ' ' '{print $2}' | uniq )
		echo $case
		sed '1d' $file | cut -f2,3,4,6 | bedtools intersect -loj -a ${inputDir}"unique_genes.sorted.rmchr.bed" -b - | python ${mainRunDir}"gatk4wxscnv."${batchName}"/gene_segment_overlap.py" > ${outputbatchDir}${j}/gene_level_by_case/$case.gene_level_by_case.log2.seg
	done
done<${mainRunDir}${toolDirName}"/"${cancerType}

while read j
do
	cd ${outputbatchDir}${j}
	cd gene_level_by_case
        ls *.seg | cut -f1 -d'.' > samples.txt
	genelevelOut=${genelevelFile}"."${j}"."${batchName}".v"${version}"."${id}".tsv"
	echo gene > ${genelevelOut}
	cut -f1 $(head -1 samples.txt).gene_level_by_case.log2.seg >> ${genelevelOut}
	cat samples.txt | while read sample; do
		echo ${sample}
		echo $sample > smp
		cut -f5 $sample.gene_level_by_case.log2.seg >> smp
		paste ${genelevelOut} smp > tmp2
		mv -f tmp2 ${genelevelOut}
		rm -f smp
	done
done<${mainRunDir}${toolDirName}"/"${cancerType}
