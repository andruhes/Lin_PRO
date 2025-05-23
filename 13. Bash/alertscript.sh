#!/bin/bash

# Настройки
LOG_FILE="/var/log/apache2/access.log"  # Путь к файлу логов
LAST_RUN_FILE="/tmp/last_run_time"       # Файл для хранения времени последнего запуска
EMAIL="it@andruhes.ru"            # Адрес электронной почты для отправки
LOCK_FILE="/tmp/script.lock"              # Файл блокировки
SMTP_SERVER="192.168.10.5"                # SMTP сервер

# Функция для отправки письма
send_email() {
    local subject="$1"
    local body="$2"
    
    {
        echo "To: $EMAIL"
        echo "Subject: $subject"
        echo "From: $EMAIL"
        echo
        echo -e "$body"
    } | sendmail -t -S "$SMTP_SERVER"
}

# Проверка на одновременный запуск
if [ -e "$LOCK_FILE" ]; then
    echo "Скрипт уже запущен."
    exit 1
fi

# Создание файла блокировки
touch "$LOCK_FILE"

# Получение времени последнего запуска
if [ -e "$LAST_RUN_FILE" ]; then
    LAST_RUN=$(cat "$LAST_RUN_FILE")
else
    LAST_RUN=0
fi

# Обновление времени последнего запуска
date +%s > "$LAST_RUN_FILE"

# Сбор данных
CURRENT_TIME=$(date +%s)

# Список IP адресов с наибольшим количеством запросов
IP_LIST=$(awk -v last_run="$LAST_RUN" '$4 >= "[" strftime("%d/%b/%Y:%H:%M:%S", last_run) {
    print $1
}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 10)

# Список запрашиваемых URL с наибольшим количеством запросов
URL_LIST=$(awk -v last_run="$LAST_RUN" '$4 >= "[" strftime("%d/%b/%Y:%H:%M:%S", last_run) {
    print $7
}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 10)

# Ошибки веб-сервера/приложения
ERRORS=$(awk -v last_run="$LAST_RUN" '$4 >= "[" strftime("%d/%b/%Y:%H:%M:%S", last_run) && $9 ~ /^5/ {
    print $0
}' "$LOG_FILE")

# Список всех кодов HTTP ответа с указанием их количества
HTTP_CODES=$(awk -v last_run="$LAST_RUN" '$4 >= "[" strftime("%d/%b/%Y:%H:%M:%S", last_run) {
    print $9
}' "$LOG_FILE" | sort | uniq -c | sort -nr)

# Формирование тела письма
EMAIL_BODY="Список IP адресов с наибольшим количеством запросов:\n$IP_LIST\n\n"
EMAIL_BODY+="Список запрашиваемых URL с наибольшим количеством запросов:\n$URL_LIST\n\n"
EMAIL_BODY+="Ошибки веб-сервера/приложения:\n$ERRORS\n\n"
EMAIL_BODY+="Список всех кодов HTTP ответа:\n$HTTP_CODES\n"

# Отправка письма
send_email "Отчет о запросах" "$EMAIL_BODY"

# Удаление файла блокировки
rm -f "$LOCK_FILE"