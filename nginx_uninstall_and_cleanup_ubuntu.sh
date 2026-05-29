#!/bin/bash

## Удаление сервера nginx (Ubuntu) и очистка конфигурации

# Остановка службы Nginx
sudo systemctl stop nginx

# Деактивация сайта
DOMAIN="my-example.com"
sudo rm -f /etc/nginx/sites-enabled/${DOMAIN}.conf

# Удаление конфигурационного файла сайта
sudo rm -f /etc/nginx/sites-available/${DOMAIN}.conf

# Удаление директории сайта
sudo rm -rf /var/www/${DOMAIN}

# Удаление Nginx
sudo apt remove -y nginx

# Очистка зависимых файлов и настроек
sudo apt autoremove -y

# Закрываем порт 80 для Nginx через UFW (если установлен)
if command -v ufw &>/dev/null; then
    sudo ufw delete allow 'Nginx HTTP'
fi

# Убедимся, что служба Nginx больше не запущена
sudo systemctl daemon-reload