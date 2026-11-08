#!/bin/bash
TARGET_IP="192.168.1.10"
KALI_IP="192.168.1.11"
WORK_DIR="./ram_capture"
PORT="8080"

print_message() {
    local message=$1
    local type=${2:-"INFO"}
    echo "[$type] $(date '+%Y-%m-%d %H:%M:%S') - $message"
}

check_error() {
    local exit_code=$1
    local error_message=$2
    if [ $exit_code -ne 0 ]; then
        print_message "ОШИБКА: $error_message" "ERROR"
        exit $exit_code
    fi
}

print_message "Начинаем подготовку окружения для сбора RAM"

if [ "$EUID" -ne 0 ]; then
    print_message "Скрипт должен запускаться с правами root!" "WARNING"
    #exit 1
fi

mkdir -p "$WORK_DIR"
check_error $? "Не удалось создать директорию $WORK_DIR"
cd "$WORK_DIR" || exit 1
print_message "Перешли в директорию: $(pwd)"

touch avml
check_error $? "Ошибка при скачивании AVML"
chmod +x avml
print_message "Установлены права на выполнение для avml"

ping -c 2 "$TARGET_IP" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    print_message "Целевая машина доступна" "SUCCESS"
else
    print_message "Целевая машина НЕ доступна!" "WARNING"
fi

print_message "Подготовка завершена!" "SUCCESS"
echo "=== СВОДКА ==="
echo "Рабочая директория: $WORK_DIR"
echo "Размер avml: $(du -h avml | cut -f1)"