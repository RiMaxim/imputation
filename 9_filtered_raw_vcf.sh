java -jar ./gatk-4.6.1.0/gatk-package-4.6.1.0-local.jar VariantFiltration -R ./reference/Ssal_v3.1_genomic.fna -V $1.vcf.gz --filter-expression "ExcessHet > 54.69 || QD < 2.0 || QUAL < 30.0 || SOR > 3.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filter-name "SNP_Filter" -O tmp.vcf.gz

java -jar ./gatk-4.6.1.0/gatk-package-4.6.1.0-local.jar SelectVariants -R ./reference/Ssal_v3.1_genomic.fna -V tmp.vcf.gz --exclude-filtered -O tmp2.vcf.gz

bcftools view -m2 -M2 --threads 220 -v snps tmp2.vcf.gz -Oz -o tmp3.vcf.gz

vcftools --gzvcf tmp3.vcf.gz --minGQ 10 --minDP 4 --max-meanDP 24 --max-missing 0.9 --maf 0.005 --recode --recode-INFO-all --stdout | bgzip -c > $1.filtered.vcf.gz

tabix -p vcf $1.filtered.vcf.gz

rm tmp.vcf.gz tmp.vcf.gz.tbi tmp2.vcf.gz tmp2.vcf.gz.tbi tmp3.vcf.gz
