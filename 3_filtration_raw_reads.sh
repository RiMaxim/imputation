java -jar ./Trimmomatic-0.39/trimmomatic-0.39.jar \
PE \
-threads $2 \
-phred33 \
$1_1.fastq.gz $1_2.fastq.gz \
$1_R1_paired.fastq.gz $1_R1_unpaired.fastq.gz \
$1_R2_paired.fastq.gz $1_R2_unpaired.fastq.gz \
LEADING:3 TRAILING:20 SLIDINGWINDOW:4:20 MINLEN:50
