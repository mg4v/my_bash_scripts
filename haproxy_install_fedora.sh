#!/bin/bash

# Обновление системы
echo "Updating system..."
sudo dnf upgrade -y

# Установка HAProxy
echo "Installing HAProxy..."
sudo dnf install haproxy -y

# Создание каталога для HAProxy
echo "Creating directories for HAProxy..."
sudo mkdir -p /etc/haproxy
sudo mkdir -p /var/lib/haproxy
sudo touch /var/lib/haproxy/stats

# Символьная ссылка для двоичного файла
echo "Setting symbolic link for binary file..."
sudo ln -s /usr/local/sbin/haproxy /usr/sbin/haproxy

# Добавление пользователя для HAProxy
echo "Adding new user for HAProxy..."
sudo useradd -r haproxy

# Разрешение автоматического запуска при загрузке
echo "Enabling automatic startup..."
sudo systemctl enable haproxy

# Настройка конфигурации HAProxy
echo "Configuring HAProxy..."

cat << EOF | sudo tee /etc/haproxy/haproxy.cfg
global
    log /dev/log    local0
    log /dev/log    local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
    stats timeout 30s
    user haproxy
    group haproxy
    daemon

defaults
    log     global
    mode    http
    option  httplog
    option  dontlognull
    timeout connect 5000
    timeout client  50000
    timeout server  50000

frontend http_front
    bind *:80
    stats uri /haproxy?stats
    default_backend http_back

backend http_back
    balance roundrobin
    server server1 192.168.1.10:80 check
    server server2 192.168.1.11:80 check
EOF

# Старт HAProxy
echo "Starting HAProxy..."
sudo systemctl start haproxy

# Проверка статуса
echo "Checking HAProxy status..."
sudo systemctl status haproxy

# Сообщение об успешном завершении
echo "Installation and setup complete!"