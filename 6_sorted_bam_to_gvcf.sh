java -jar ./gatk-4.6.1.0/gatk-package-4.6.1.0-local.jar AddOrReplaceReadGroups -I $1.bam -O $1.gr.bam -ID group1 -SM $1 -PL Illumina -LB lib1 -PU unit1
java -jar ./gatk-4.6.1.0/gatk-package-4.6.1.0-local.jar MarkDuplicates -I $1.gr.bam -O $1.gr.dup.bam -M $1.dup.txt --REMOVE_DUPLICATES true --CREATE_INDEX true
rm $1.bam $1.gr.bam

java -jar ./gatk-4.6.1.0/gatk-package-4.6.1.0-local.jar HaplotypeCallerSpark -R ./reference/Ssal_v3.1_genomic.fna -I $1.gr.dup.bam -O $1.g.vcf.gz -ERC GVCF
