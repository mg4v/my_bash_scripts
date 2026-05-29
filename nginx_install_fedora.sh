#!/bin/bash

## Установка сервера Nginx (Fedora) с подменой содержимого сайта по умолчанию

# Обновление списка пакетов
sudo dnf update -y

# Установка Nginx
sudo dnf install nginx -y

# Проверка статуса Nginx
sudo systemctl status nginx

# Открытие портов 80 для Nginx через firewalld (брандмауэр)
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload

# Создаем тестовый HTML-файл
echo '<h1>Hello, World!</h1>' | sudo tee /usr/share/nginx/html/index.nginx-fedora.html

# Показываем содержимое файла
cat /usr/share/nginx/html/index.nginx-fedora.html

# Проверяем конфигурацию Nginx на ошибки
sudo nginx -t

# Перезапускаем Nginx
sudo systemctl restart nginx