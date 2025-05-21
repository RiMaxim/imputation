#For validation

#!/bin/bash

# Входной BAM-файл и выходная директория
BAM_FILE=$1  # Передается как аргумент
OUT_DIR=$2  # Передается как аргумент

# Проверка аргументов
if [ -z "$BAM_FILE" ] || [ -z "$OUT_DIR" ]; then
    echo "Использование: $0 <input.bam> <output_directory>"
    exit 1
fi

# Создаем выходную директорию, если её нет
mkdir -p "$OUT_DIR"

# Получаем среднее покрытие по всему геному
AVG_COV=$(samtools coverage "$BAM_FILE" | awk 'NR>1 {sum+=$7; count++} END {if (count>0) print sum/count; else print 0}')

# Проверяем, получилось ли вычислить среднее покрытие
if [ -z "$AVG_COV" ] || [ "$AVG_COV" == "0" ]; then
    echo "Ошибка: не удалось определить среднее покрытие. Проверьте BAM-файл."
    exit 1
fi

echo "Среднее покрытие: ${AVG_COV}x"

# Задаем уровни снижения покрытия
COVERAGES=(0.1 0.3 0.5 0.7 0.9)

# Генерируем BAM-файлы с разным покрытием
for COV in "${COVERAGES[@]}"; do
    # Вычисляем коэффициент субвыборки
    SCALE=$(echo "$COV / $AVG_COV" | bc -l)
....
    # Проверяем, что коэффициент корректный
    if (( $(echo "$SCALE > 1.0" | bc -l) )); then
        echo "Пропускаем $COV, так как оно больше исходного покрытия"
        continue
    fi
....
    # Создаём выходной файл
    OUT_BAM="$OUT_DIR/$(basename "$BAM_FILE" .bam)_${COV}x.bam"
....
    echo "Создаём BAM-файл с покрытием ${COV}x (коэффициент $SCALE)"
    samtools view -hb -s "$SCALE" "$BAM_FILE" -o "$OUT_BAM"
    samtools index "$OUT_BAM"

done

echo "Готово! Файлы сохранены в $OUT_DIR"
