#For validation

./phase_common_static --input $1.filtered.vcf.gz --region $1 --output $1.phased5.bcf --thread $2

bcftools view  $1.phased5.bcf  -s ^E250052437_L01_UDB-387,E250052437_L01_UDB-388 --threads $2 -Ob -o $1.phased5.del_387_388.bcf
bcftools index -f $1.phased5.del_387_388.bcf
bcftools +fill-tags $1.phased5.del_387_388.bcf -- -t AF | bgzip -c > $1.phased5.del_387_388.sitesAF.vcf.gz
bcftools index $1.phased5.del_387_388.sitesAF.vcf.gz

bcftools view $1.phased5.bcf -s E250052437_L01_UDB-387 --threads $2 -Ob -o $1.phased5.387.bcf
bcftools index $1.phased5.387.bcf
bcftools view $1.phased5.bcf -s E250052437_L01_UDB-388 --threads $2 -Ob -o $1.phased5.388.bcf
bcftools index $1.phased5.388.bcf

bcftools view -s E250052437_L01_UDB-387 $1.filtered.vcf.gz -Oz -o $1.filtered.387.vcf.gz
bcftools index $1.filtered.387.vcf.gz
bcftools view -s E250052437_L01_UDB-388 $1.filtered.vcf.gz -Oz -o $1.filtered.388.vcf.gz
bcftools index $1.filtered.388.vcf.gz
