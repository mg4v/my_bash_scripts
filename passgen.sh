#!/bin/bash

# Функция для генерации пароля
generate_password() {
    local length=$1
    local symbols="$2"

    cat /dev/urandom | tr -dc "$symbols" | fold -w $length | head -n 1
}

# Основной цикл программы
while true; do
    # Если были введены параметры ранее, предлагаем использовать их снова
    if [[ -n "$password_length" && -n "$allowed_symbols" ]]; then
        read -p "Использовать прежнюю длину ($password_length) и состав символов? (y/n): " use_old
        if [[ "$use_old" =~ [Yy] ]]; then
            # Используем старые параметры
            :
        else
            # Очистка старых параметров
            unset password_length allowed_symbols
        fi
    fi

    # Если параметры не заданы, запрашиваем их заново
    if [[ -z "$password_length" || -z "$allowed_symbols" ]]; then
        # Получаем длину пароля
        read -p "Укажите желаемую длину пароля: " password_length

        # Формирование набора символов
        allowed_symbols=""

        # Цифры
        read -p "Нужны ли цифры в пароле? (y/n): " digits
        if [[ "$digits" =~ [Yy] ]]; then
            allowed_symbols+='0-9'
        fi

        # Заглавные буквы
        read -p "Нужны ли заглавные латинские буквы? (y/n): " uppercase_letters
        if [[ "$uppercase_letters" =~ [Yy] ]]; then
            allowed_symbols+='A-Z'
        fi

        # Строчные буквы
        read -p "Нужны ли строчные латинские буквы? (y/n): " lowercase_letters
        if [[ "$lowercase_letters" =~ [Yy] ]]; then
            allowed_symbols+='a-z'
        fi

        # Специальные символы
        read -p "Нужны ли специальные символы? (y/n): " special_chars
        if [[ "$special_chars" =~ [Yy] ]]; then
            allowed_symbols+="!@#$%^&*()-_=+[$${}\"';:,.<>?/~"
        fi

        # Проверка наличия хотя бы одного типа символов
        if [[ -z "$allowed_symbols" ]]; then
            echo "Ошибка: Вы не выбрали ни один тип символов."
            continue
        fi
    fi

    # Генерация пароля
    password=$(generate_password "$password_length" "$allowed_symbols")
    echo "Ваш пароль: $password"

    # Выбор дальнейших действий
    read -p "Что сделать дальше? (1 - Повторить с этими же параметрами, 2 - Изменить параметры, q - Выход): " choice
    case $choice in
        1 )
            continue;; # Продолжаем с теми же параметрами
        2 )
            unset password_length allowed_symbols # Очищаем память о прошлых параметрах
            continue;; # Начинаем заново вводить параметры
        q|Q )
            exit 0;; # Завершаем программу
        * )
            echo "Неправильная команда. Попробуйте снова.";;
    esac
done