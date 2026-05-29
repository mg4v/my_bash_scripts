#!/bin/bash

## Установка сервера nginx (Ubuntu) с новым сайтом и управлением через специально созданного пользователя

# Обновляем репозитории
sudo apt update

# Устанавливаем Nginx
sudo apt install -y nginx

# Создание пользователя nginx
if id "nginx" &>/dev/null; then
    echo "Пользователь nginx уже существует."
else
    sudo useradd -r -s /usr/sbin/nologin nginx
    echo "Создан пользователь nginx."
fi

# Настройка прав владельца и группы для каталога сайтов
DOMAIN="my-example.com"
SITE_DIR="/var/www/${DOMAIN}"
SITE_HTML="${SITE_DIR}/html"

# Создаем структуру папок для сайта
sudo mkdir -p "${SITE_HTML}"
sudo chown -R nginx:nginx "$SITE_DIR"
sudo chmod -R 755 "$SITE_DIR"

# Создаем конфигурационный файл для сайта
cat <<EOF | sudo tee "/etc/nginx/sites-available/${DOMAIN}.conf"
server {
    listen 80;
    server_name ${DOMAIN} www.${DOMAIN};

    root ${SITE_HTML};
    index index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Активируем сайт
sudo ln -sf "/etc/nginx/sites-available/${DOMAIN}.conf" "/etc/nginx/sites-enabled/"

# Изменяем пользователя запуска nginx в основном конфиге
sudo sed -i '/^user/c\user nginx;' /etc/nginx/nginx.conf

# Проверяем конфигурацию Nginx на наличие ошибок
sudo nginx -t

# Запускаем сервис Nginx от имени пользователя nginx
sudo systemctl start nginx.service
sudo systemctl reload nginx.service

# Добавляем правила брандмауэра UFW (при наличии)
if command -v ufw &>/dev/null; then
    sudo ufw allow 'Nginx Full' || true
    sudo ufw enable || true
fi

# Создаем тестовую страницу
echo '<h1>Привет мир от моего сайта!</h1>' | sudo tee "${SITE_HTML}/index.html"

# Просмотр результатов
cat "${SITE_HTML}/index.html"

# Проверяем статус службы Nginx
sudo systemctl status nginx