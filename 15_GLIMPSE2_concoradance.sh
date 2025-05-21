#For validation
#$1 is name of chomosome

#!/bin/bash

values=(387 388)
fractions=(0.1 0.3 0.5 0.7 0.9)

for value in "${values[@]}"; do
    for fraction in "${fractions[@]}"; do
        echo  "$1 ./shapeit5/$1.phased5.del_387_388.sitesAF.vcf.gz ./shapeit5/$1.phased5.${value}.bcf ./glimpse2/ligate/$1.E250052437_L01_UDB-${value}.${fraction}x.bcf" > ./glimpse2/concordance/$1.E250052437_L01_UDB-${value}.${fraction}x.concordance.txt
    done
done

for value in "${values[@]}"; do
    for fraction in "${fractions[@]}"; do
        input_file="./glimpse2/concordance/$1.E250052437_L01_UDB-${value}.${fraction}x.concordance.txt"
        output_file="./glimpse2/concordance/$1.E250052437_L01_UDB-${value}.${fraction}x.concordance"

        # Запуск команды GLIMPSE2_concordance для каждого файла
        GLIMPSE2_concordance --af-tag AF --gt-val --bins 0 0.005 0.01 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 --threads 48 --input "$input_file" --output "$output_file"
    done
done



gunzip /mnt/PROJECTS1/RI_MAXIM/8_glimpse2/concordance/*gz


input_prefix="./glimpse2/concordance"
output_prefix="./glimpse2/concordance"
final_output="./glimpse2/$1.output"

# Define depth levels and UDB values
depths=("0.1x" "0.3x" "0.5x" "0.7x" "0.9x")
udbs=("387" "388")

# Temporary files array
temp_files=()

# Extract the third column from each file
for udb in "${udbs[@]}"; do
    for depth in "${depths[@]}"; do
        input_file="${input_prefix}/$1.E250052437_L01_UDB-${udb}.${depth}.concordance.rsquare.grp.txt"
        output_file="${output_prefix}/$1.E250052437_L01_UDB-${udb}.${depth}.concordance.rsquare.grp.txt2"

        # Extract the third column
        awk '{print $4}' "$input_file" > "$output_file"

        # Store the temp file path
        temp_files+=("$output_file")
    done
done

# Merge all extracted columns
paste "${temp_files[@]}" > "$final_output"
cat "$final_output" >>output

rm "${temp_files[@]}"





















 1Help                                 2Save                                 3Mark                                 4Replac                               5Copy                                 6Move                                 7Search                               8Delete                               9PullDn                              10Quit
