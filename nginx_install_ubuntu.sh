#!/bin/bash

## Устновка сервера nginx (Ubuntu) с подменой содержимого сайта по умолчанию

# Обновление списка пакетов
sudo apt update

# Установка Nginx
sudo apt install -y nginx

# Проверка статуса Nginx
sudo systemctl status nginx

# Открытие порта 80 для Nginx через UFW (брандмауэр)
if ! command -v ufw &>/dev/null; then
    echo "UFW not installed."
else
    sudo ufw allow 'Nginx HTTP'
    sudo ufw enable
fi

# Создаем тестовый HTML-файл
echo '<h1>Hello, My World!</h1>' | sudo tee /var/www/html/index.nginx-debian.html

# Показываем содержимое файла
cat /var/www/html/index.nginx-debian.html

# Проверяем конфигурацию Nginx на ошибки
sudo nginx -t

# Перезапускаем Nginx
sudo systemctl restart nginx