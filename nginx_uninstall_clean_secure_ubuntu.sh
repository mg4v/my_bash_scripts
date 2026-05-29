#!/bin/bash

## Удаление сервера nginx (Ubuntu) с полным очищением создаваемых ресурсов и пользователя

# Переменная доменного имени сайта
DOMAIN="my-example.com"

# Имя пользователя, созданного для nginx
USERNAME="nginx"

# Стартовые проверки
if [[ $(id -u) != 0 ]]; then
    echo "Ошибка: Необходимо запустить скрипт с правами администратора!"
    exit 1
fi

# Удаление файла конфигурации сайта
CONF_FILE="/etc/nginx/sites-available/${DOMAIN}.conf"
if [[ -f "$CONF_FILE" ]]; then
    sudo unlink "/etc/nginx/sites-enabled/${DOMAIN}.conf"
    sudo rm -f "$CONF_FILE"
    echo "Удалён конфигурационный файл сайта."
else
    echo "Конфигурационный файл сайта не найден."
fi

# Удаление директорий сайта
SITE_DIR="/var/www/$DOMAIN"
if [[ -d "$SITE_DIR" ]]; then
    sudo rm -rf "$SITE_DIR"
    echo "Удалены файлы и директории сайта."
else
    echo "Директория сайта не найдена."
fi

# Удаление записей брандмауэра (если установлены)
if command -v ufw &>/dev/null && sudo ufw status verbose | grep -qE '^Status:\s+active$'; then
    if sudo ufw status numbered | grep -qE "\s+[[:digit:]]+\s+Nginx\s"; then
        sudo ufw delete allow 'Nginx Full'
        echo "Правила UFW для Nginx удалены."
    else
        echo "Нет активных правил UFW для Nginx."
    fi
else
    echo "UFW либо не установлен, либо неактивен."
fi

# Удаление основного пакета Nginx
if dpkg -l | grep -qw nginx; then
    sudo apt purge -y nginx*
    sudo apt autoremove -y
    echo "Основной пакет Nginx удалён."
else
    echo "Nginx не установлен."
fi

# Удаление пользователя nginx
if id "$USERNAME" >/dev/null 2>&1; then
    sudo deluser --remove-home "$USERNAME"
    echo "Пользователь '$USERNAME' удалён."
else
    echo "Пользователь '$USERNAME' не обнаружен."
fi

# Перезагрузка демона для обновления списков сервисов
sudo systemctl daemon-reload

# Сообщение о завершении очистки
echo "Процесс очистки завершён успешно."