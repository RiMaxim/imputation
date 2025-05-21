bwa-mem2 index ./reference/Ssal_v3.1_genomic.fna
bwa-mem2 mem -t 50 ./reference/Ssal_v3.1_genomic.fna $1_R1_paired.fastq.gz $1_R2_paired.fastq.gz | samtools sort -o $1.bam -@ $2
