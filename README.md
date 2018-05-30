WES CNV calling method:

We used GATK (version 4.beta.5) CNV workflow to detect somatic copy number variations in CPTAC3 LUAD batch#1 whole exome sequencing data (using BAM files from tumors(11) and blood-normal(11) samples. It first collected proportional coverage using target intervals and WXS BAM files. Then it created the CNV panel of normals so as to remove the batch effect from the tumor samples. The resulting coverage data was then normalize and segmented. Finally, it called copy number variants after filtering out copy number neutral regions and outlier coverage regions (All the parameters used are default).

Processing scripts(@ https://github.com/yigewu/gatk4wxscnv/tree/LUAD.b1)
	refer to main.sh for coordination of specific scripts for each step
	
Contact: Yige Wu @ WashU (yigewu@wustl.edu)

