#!/bin/bash

#inputDir=$1
inputDir=/diskmnt/Projects/CPTAC3CNV/gatk4wxscnv/inputs/

cd ${inputDir}
## generat target interval list file
### get rid of chr string
#cat ${inputDir}nexterarapidcapture_exome_targetedregions_v1.2.merged.bed | grep -v chrM | awk -F 'chr' '{print $2}' > ${inputDir}nexterarapidcapture_exome_targetedregions_v1.2.merged.nochr.bed
#java -jar ${inputDir}picard.jar BedToIntervalList I=${inputDir}nexterarapidcapture_exome_targetedregions_v1.2.merged.nochr.bed O=nexterarapidcapture_exome_targetedregions_v1.2.merged.bed.interval_list SD=Homo_sapiens_assembly19.fasta.dict
## generate proble interval list file
#grep CEX-probe- NexteraRapidCapture_Exome_Probes_v1.2.txt | grep -v chrM | cut -f 2-4 | awk -F 'chr' '{print $2}' > NexteraRapidCapture_Exome_Probes_v1.2.txt.bed

#java -jar ${inputDir}picard.jar BedToIntervalList I=${inputDir}NexteraRapidCapture_Exome_Probes_v1.2.txt.bed O=NexteraRapidCapture_Exome_Probes_v1.2.txt.bed.interval_list SD=${inputDir}Homo_sapiens_assembly19.fasta.dict

cm="java -jar picard.jar CollectHsMetrics I=/diskmnt/Projects/cptac_downloads/data/GDC_import/data/7ac90e00-bd10-44e5-91f1-4e51b1764945/CPT0079650009.WholeExome.RP-1303.bam O=/diskmnt/Projects/CPTAC3CNV/gatk4wxscnv/outputs/hs_metrics.txt R=/diskmnt/Projects/CPTAC3CNV/gatk4wxscnv/inputs/Homo_sapiens_assembly19.fasta BAIT_INTERVALS=${inputDir}NexteraRapidCapture_Exome_Probes_v1.2.txt.bed.interval_list TARGET_INTERVALS=${inputDir}nexterarapidcapture_exome_targetedregions_v1.2.merged.bed.interval_list>&collecthsmetrics_demo.log" 
echo ${cm}
