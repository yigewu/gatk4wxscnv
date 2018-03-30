WES CNV calling method:

We used GATK (version 4.beta.5) CNV workflow to detect somatic copy number variations in CPTAC3 UCEC and CCRC batch#3 whole exome sequencing data (using BAM files from tumors and normal tissues, 19 CCRC and 31 UCEC tumor-normal pairs). It first collected proportional coverage using target intervals and WXS BAM files. Then it created the CNV panel of normals so as to remove the batch effect from the tumor samples. The resulting coverage data was then normalize and segmented. Finally, it called copy number variants after filtering out copy number neutral regions and outlier coverage regions (All the parameters used are default).

Processing scripts(@ https://github.com/yigewu/gatk4wxscnv.b3) 
	refer to main.sh for coordination of specific scripts for each step
	
Contact: Yige Wu @ WashU (yigewu@wustl.edu)

