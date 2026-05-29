#!/bin/bash

# Удаление HAProxy
echo "Удаление HAProxy..."
sudo dnf remove haproxy -y

# Удаление созданных каталогов и файлов
echo "Очистка оставленных директорий и файлов..."
sudo rm -rf /etc/haproxy
sudo rm -rf /var/lib/haproxy
sudo rm -f /var/lib/haproxy/stats
sudo rm -f /usr/sbin/haproxy

# Удаление пользователя haproxy
echo "Удаление пользователя haproxy..."
sudo userdel haproxy

# Проверка статуса после удаления
echo "Проверка наличия остатков..."
# shellcheck disable=SC2143
if [[ $(sudo rpm -qa | grep haproxy) ]]; then
    echo "Ошибка: HAProxy все еще установлен."
else
    echo "HAProxy успешно удалён."
fi

# Завершение работы
echo "Процесс завершён."