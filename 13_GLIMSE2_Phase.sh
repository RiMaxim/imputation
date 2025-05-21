#For validation

#!/bin/bash

# Указываем путь к папке с файлами .bin
BIN_DIR="./glimpse2/chunks/"

# Определяем образцы и покрытия
samples=("E250052437_L01_UDB-387" "E250052437_L01_UDB-388")
coverages=("0.1x" "0.3x" "0.5x" "0.7x" "0.9x")

# Проходим по каждому файлу в папке BIN_DIR
for bin_file in "$BIN_DIR"/*.bin; do
    # Извлекаем имя файла без пути и расширения
    bin_name=$(basename "$bin_file" .bin)

    for sample in "${samples[@]}"; do
        for cov in "${coverages[@]}"; do
            bam_file="./lowCoverage/${sample}/${sample}.gr.dup_${cov}.bam"
            output="./glimpse2/phased/${bin_name}.${sample}.${cov}.bcf"

            # Проверяем, существует ли BAM-файл
            if [[ ! -f "$bam_file" ]]; then
                echo "Ошибка: файл $bam_file не найден!" >&2
                continue
            fi

            echo "Фазирование: $bam_file -> $output"

            # Запускаем GLIMPSE2_phase и сохраняем логи
            GLIMPSE2_phase --bam-file "$bam_file" --reference "$bin_file" --output "$output" --threads 100 --Kpbwt 600 > "${output}.log" 2>&1
        done
    done
done
