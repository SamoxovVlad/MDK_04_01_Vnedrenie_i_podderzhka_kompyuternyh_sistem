#!/bin/bash

print_message() {
    local message=$1
    local type=${2:-"INFO"}
    echo "[$type] $(date '+%Y-%m-%d %H:%M:%S') - $message"
}

WORK_DIR="./ram_capture"
DUMP_FILE="memory_dump.raw"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

calculate_hashes() {
    local file_path=$1
    local output_file=$2
    print_message "Начинаем расчет хэш-сумм для файла: $file_path"
    if [ ! -f "$file_path" ]; then
        print_message "Файл $file_path не найден!" "ERROR"
        return 1
    fi
    {
        echo "=== ФОРЕНСИЧЕСКИЙ ОТЧЕТ ХЭШ-СУММ ==="
        echo "Время создания: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Файл: $file_path"
        echo "Размер: $(du -h "$file_path" | cut -f1)"
    } > "$output_file"
    
    echo "MD5:" >> "$output_file"
    md5sum "$file_path" >> "$output_file"
    echo "" >> "$output_file"
    
    echo "SHA1:" >> "$output_file"
    sha1sum "$file_path" >> "$output_file"
    echo "" >> "$output_file"
    
    echo "SHA256:" >> "$output_file"
    sha256sum "$file_path" >> "$output_file"
}

verify_hashes() {
    local file_path=$1
    local hash_file=$2
    print_message "Проверяем целостность файла..."
    
    expected_sha256=$(grep -A1 "SHA256:" "$hash_file" | tail -n1 | awk '{print $1}')
    current_sha256=$(sha256sum "$file_path" | awk '{print $1}')
    
    if [ "$expected_sha256" = "$current_sha256" ]; then
        print_message "✓ Целостность файла подтверждена!" "SUCCESS"
        return 0
    else
        print_message "✗ Целостность файла нарушена!" "ERROR"
        return 1
    fi
}

cd "$WORK_DIR" || exit 1

if [ ! -f "$DUMP_FILE" ]; then
    print_message "Файл дампа $DUMP_FILE не найден!" "ERROR"
    exit 1
fi

HASH_FILE="hashes_${TIMESTAMP}.txt"
calculate_hashes "$DUMP_FILE" "$HASH_FILE"

echo ""
echo "=== РЕЗУЛЬТАТЫ ==="
cat "$HASH_FILE"
echo ""

verify_hashes "$DUMP_FILE" "$HASH_FILE"
print_message "Процесс завершен! Файл хэшей: $HASH_FILE" "SUCCESS"