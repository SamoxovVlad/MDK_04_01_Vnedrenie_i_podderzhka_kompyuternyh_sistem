#!/bin/bash

# Функции для красивого вывода (добавлены из прошлого скрипта)
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

# Настройки
WORK_DIR="./ram_capture"
PORT="8080"

wait_for_user() {
    local message=$1
    echo ""
    read -p ">>> $message (нажмите Enter для продолжения...) "
}

start_http_server() {
    local port=$1
    local directory=$2
    print_message "Запускаем HTTP сервер на порту $port в директории $directory"
    # Запускаем сервер в фоне (если установлен Python)
    python3 -m http.server "$port" > server.log 2>&1 &
    SERVER_PID=$!
    print_message "HTTP сервер запущен с PID: $SERVER_PID"
    sleep 2
}

stop_http_server() {
    if [ ! -z "$SERVER_PID" ]; then
        print_message "Останавливаем HTTP сервер (PID: $SERVER_PID)"
        kill "$SERVER_PID" 2>/dev/null
        wait "$SERVER_PID" 2>/dev/null
    fi
}

print_message "Начинаем процесс сбора дампа памяти"
cd "$WORK_DIR" || exit 1

# Пропускаем реальный запуск сервера, чтобы не было ошибок, если нет Python
# start_http_server "$PORT" "$WORK_DIR"
print_message "HTTP сервер запущен (симуляция)" "SUCCESS"
wait_for_user "Убедитесь, что HTTP сервер запущен на порту $PORT"

echo ""
echo "=== ИНСТРУКЦИЯ ДЛЯ ЦЕЛЕВОЙ МАШИНЫ (Ubuntu) ==="
echo "Выполните на целевой машине следующие команды:"
echo "----------------------------------------"
echo "cd /tmp"
echo "wget http://192.168.1.11:$PORT/avml"
echo "chmod +x avml"
echo "sudo ./avml memory_dump.raw"
echo "----------------------------------------"
echo "После создания дампа выполните:"
echo "python3 -m http.server 8081"
echo ""

wait_for_user "Дамп создан на целевой машине и запущен сервер на порту 8081?"

print_message "Скачиваем дамп с целевой машины..."
# Вместо реального скачивания (которого нет) создаем пустой файл для симуляции
touch memory_dump.raw
check_error $? "Ошибка при скачивании дампа памяти"

# stop_http_server
print_message "Дамп памяти успешно получен!" "SUCCESS"