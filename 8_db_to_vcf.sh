#!/bin/bash

# Путь к GATK
GATK_JAR="./gatk-4.6.1.0/gatk-package-4.6.1.0-local.jar"
REF="./reference/Ssal_v3.1_genomic.fna"

# Список папок и диапазонов
declare -A folder_ranges=(
    [NC_059442.1]="4012 4186"
    [NC_059443.1]="4187 4282"
    [NC_059444.1]="4283 4388"
    [NC_059445.1]="4389 4479"
    [NC_059446.1]="4480 4572"
    [NC_059447.1]="4573 4669"
    [NC_059448.1]="4670 4738"
    [NC_059449.1]="4739 4767"
    [NC_059450.1]="4768 4929"
    [NC_059451.1]="4930 5055"
    [NC_059452.1]="5056 5167"
    [NC_059453.1]="5168 5269"
    [NC_059454.1]="5270 5384"
    [NC_059455.1]="5385 5486"
    [NC_059456.1]="5487 5597"
    [NC_059457.1]="5598 5694"
    [NC_059458.1]="5695 5782"
    [NC_059459.1]="5783 5867"
    [NC_059460.1]="5868 5956"
    [NC_059461.1]="5957 6053"
    [NC_059462.1]="6054 6113"
    [NC_059463.1]="6114 6177"
    [NC_059464.1]="6178 6230"
    [NC_059465.1]="6231 6280"
    [NC_059466.1]="6281 6335"
    [NC_059467.1]="6336 6391"
    [NC_059468.1]="6392 6437"
    [NC_059469.1]="6438 6479"
    [NC_059470.1]="6480 6523"
)

# Обработка всех папок
for folder in "${!folder_ranges[@]}"; do
    read start end <<< "${folder_ranges[$folder]}"
    mkdir -p "$folder"

    # Переместить файлы
    for ((i=start; i<=end; i++)); do
        f="GENOMICS_DB_$i"
        if [[ -e "$f" ]]; then
            mv "$f" "$folder/"
        fi
    done

    # Перейти в папку
    cd "$folder" || continue

    # Выполнить GenotypeGVCFs для каждого номера
    for ((i=start; i<=end; i++)); do
        echo "Processing GENOMICS_DB_$i..."
        java -jar "$GATK_JAR" GenotypeGVCFs \
            -R "$REF" \
            -V gendb://GENOMICS_DB_$i \
            -O "$i.vcf.gz"
    done

    # Собрать все vcf.gz
    VCF_FILES=""
    for file in *.vcf.gz; do
        VCF_FILES+=" -I $file"
    done

    # Итоговый VCF
    java -jar "$GATK_JAR" GatherVcfs $VCF_FILES -O "../$folder.vcf.gz"

    # Вернуться назад
    cd   
done
