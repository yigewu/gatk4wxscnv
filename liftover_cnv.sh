#!/bin/bash

## Usage: liftover from hg19 to hg38 coordinates

mainRunDir=$1
inputDir=${mainRunDir}"inputs/"
outputDir=${mainRunDir}"outputs/"
bamMapFile=$2
toolName=$3
batchName=$4
cancerType=$5
crossmapPath="/diskmnt/Projects/Users/lwang/miniconda3/envs/crossmap/bin/CrossMap.py"
chainfilePath="/diskmnt/Datasets/TCGA/MC3/GRCh38_liftOver/GRCh37_to_GRCh38.chain.gz"

scriptDir=${mainRunDir}${toolName}"."${batchName}"/"
liftinDir=${mainRunDir}"deliverables/"${batchName}"/"
liftoutDir=${liftinDir}"liftover/"
mkdir -p ${liftoutDir} 
cd ${liftinDir}
ls *cnv > ${liftoutDir}"cnv_files.txt"

while read j; do
	echo  $j
	newfilename=$(echo ${j} | awk -F '\\.cnv' '{print $1".b38.cnv"}')
	## write start coordinates in the cnv file as a bed file
	head -1 ${j} > ${liftoutDir}"header.cnv"
	cat ${j} | grep -v Chromosome | awk '{print $2"\t"$3"\t"$3}' | python ${scriptDir}"bed1to0.py" > ${liftoutDir}"tmp_start.b37.bed"
	wc ${liftoutDir}"tmp_start.b37.bed"

	## get the build 38 coordinates of build 19 start coordiantes as a bed file
	${crossmapPath} bed ${chainfilePath} ${liftoutDir}"tmp_start.b37.bed" > ${liftoutDir}"tmp_start.b38.bed"
	wc ${liftoutDir}"tmp_start.b38.bed"

	grep -v Fail ${liftoutDir}"tmp_start.b38.bed" > ${liftoutDir}"tmp_start.b38.noFail.bed"
	wc ${liftoutDir}"tmp_start.b38.noFail.bed"

	## rewrite orginal cnv file as a bed file to intersect with b38 bed file
	cat ${j} | grep -v Chromosome | awk -v OFS='\t' '{print $2,$3,$3,$1,$2,$3,$4,$5,$6,$7}' | python ${scriptDir}"bed1to0.py" > ${liftoutDir}"tmp_start.b37.2bemerged.bed"
	wc ${liftoutDir}"tmp_start.b37.2bemerged.bed"

	bedtools intersect -a ${liftoutDir}"tmp_start.b37.2bemerged.bed" -b ${liftoutDir}"tmp_start.b38.noFail.bed" -wo -f 1 > ${liftoutDir}"tmp_start.b38.merged.bed"
	wc ${liftoutDir}"tmp_start.b38.merged.bed"

	cat ${liftoutDir}"tmp_start.b38.merged.bed" | awk -v OFS='\t' '{print $15,$16,$17,$4,$5,$6,$7,$8,$9,$10}' | python ${scriptDir}"bed0to1.py" | awk  -v OFS='\t' '{print $4,$5,$2,$7,$8,$9,$10}' > ${liftoutDir}${newfilename}
	wc ${liftoutDir}${newfilename}	
	
	## iterate for end coordinates
        ## write end coordinates in the cnv file as a bed file
        cat ${liftoutDir}${newfilename} | grep -v Chromosome | awk '{print $2"\t"$4"\t"$4}' | python ${scriptDir}"bed1to0.py" > ${liftoutDir}"tmp_end.b37.bed"
	wc ${liftoutDir}"tmp_end.b37.bed"

        ## get the build 38 coordinates of build 19 end coordiantes as a bed file
        ${crossmapPath} bed ${chainfilePath} ${liftoutDir}"tmp_end.b37.bed" > ${liftoutDir}"tmp_end.b38.bed"
	wc ${liftoutDir}"tmp_end.b38.bed"

        grep -v Fail ${liftoutDir}"tmp_end.b38.bed" > ${liftoutDir}"tmp_end.b38.noFail.bed"
	wc ${liftoutDir}"tmp_end.b38.noFail.bed"

        ## rewrite orginal cnv file as a bed file to intersect with b38 bed file
        cat ${liftoutDir}${newfilename} | grep -v Chromosome | awk -v OFS='\t' '{print $2,$4,$4,$1,$2,$3,$4,$5,$6,$7}' | python ${scriptDir}"bed1to0.py" > ${liftoutDir}"tmp_end.b37.2bemerged.bed"
	wc ${liftoutDir}"tmp_end.b37.2bemerged.bed"

        bedtools intersect -a ${liftoutDir}"tmp_end.b37.2bemerged.bed" -b ${liftoutDir}"tmp_end.b38.noFail.bed" -wo -f 1 > ${liftoutDir}"tmp_end.b38.merged.bed"
	wc ${liftoutDir}"tmp_end.b38.merged.bed"

        cat ${liftoutDir}"tmp_end.b38.merged.bed" | awk -v OFS='\t' '{print $15,$16,$17,$4,$5,$6,$7,$8,$9,$10}' | python ${scriptDir}"bed0to1.py" | awk  -v OFS='\t' '{print $4,$5,$6,$2,$8,$9,$10}' > ${liftoutDir}"tmp.cnv"
	wc ${liftoutDir}"tmp.cnv"
	
	cat ${liftoutDir}"header.cnv" ${liftoutDir}"tmp.cnv" > ${liftoutDir}${newfilename}
done<${liftoutDir}"cnv_files.txt"
