#Separate file genome_intervals.list by rows and additinal 1-29 rows by 1 mnl length. See results here genome_intervals.tar.gz. Files 30.list....4011.list are other intervals; 4012.list...6523.list - normal chromosomes.
for i in {30..6523}; do
java -jar ./gatk-4.6.1.0/gatk-package-4.6.1.0-local.jar GenomicsDBImport --genomicsdb-workspace-path GENOMICS_DB_$i --tmp-dir ./tmp --sample-name-map sample_map.txt --reader-threads 1 -L ./genome_intervals/$i.list
done


