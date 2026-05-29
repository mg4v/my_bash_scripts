#!/bin/bash

## Устновка сервера nginx (Ubuntu) с добавлением нового сайта
### Пока не разобрались, как добавить новый сайт в конфигурацию Nginx по умолчанию

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

# Проверяем доступность страницы по умолчанию
curl http://localhost

# Создаем директорию для сайта
DOMAIN="my-example.com"
sudo mkdir -p /var/www/${DOMAIN}/html

# Создаем конфигурационный файл для сайта
cat <<EOF | sudo tee /etc/nginx/sites-available/${DOMAIN}.conf
server {
    listen 80;
    server_name ${DOMAIN} www.${DOMAIN};

    root /var/www/${DOMAIN}/html;
    index index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Активируем сайт
sudo ln -s /etc/nginx/sites-available/${DOMAIN}.conf /etc/nginx/sites-enabled/

# Проверяем конфигурацию Nginx на ошибки
sudo nginx -t

# Перезапускаем Nginx
sudo systemctl restart nginx

# Создаем тестовый HTML-файл
echo "<h1>Hello, My World!</h1>" | sudo tee /var/www/${DOMAIN}/html/index.html

# Показываем содержимое файла
cat /var/www/${DOMAIN}/html/index.html