#For validation

#!/bin/bash

values=(387 388)
fractions=(0.1 0.3 0.5 0.7 0.9)
#fractions=(1.0 1.5 2.0 2.5)


for value in "${values[@]}"; do
    for fraction in "${fractions[@]}"; do
        input_txt="./glimpse2/ligate/$1.E250052437_L01_UDB-${value}.${fraction}x.txt"
        output_bcf="./glimpse2/ligate/$1.E250052437_L01_UDB-${value}.${fraction}x.bcf"

        # Генерация списка файлов
        ls -1v ./glimpse2/phased/_$1*${value}.${fraction}x.bcf > "$input_txt"

        # Запуск GLIMPSE2_ligate
        GLIMPSE2_ligate --input "$input_txt" --output "$output_bcf" --threads 48
    done
done

for value in "${values[@]}"; do
    for fraction in "${fractions[@]}"; do
        file_prefix="./glimpse2/ligate/$1.E250052437_L01_UDB-${value}.${fraction}x"

        # Удаление старого индекса
        rm -f "${file_prefix}.bcf.csi"

        # Конвертация BCF в VCF
        bcftools view "${file_prefix}.bcf" -Ov -o ./glimpse2/ligate/tmp

        # Замена в файле с помощью sed
        sed "s/\.gr\.dup_${fraction}x//g" ./glimpse2/ligate/tmp > ./glimpse2/ligate/tmp2

        # Конвертация обратно в BCF
        bcftools view -Ob -o "${file_prefix}.bcf" ./glimpse2/ligate/tmp2

        # Индексация нового BCF-файла
        bcftools index "${file_prefix}.bcf"

        # Удаление временных файлов
        rm ./glimpse2/ligate/tmp ./glimpse2/ligate/tmp2
    done
done
