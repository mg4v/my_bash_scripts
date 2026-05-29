#!/bin/bash

# Функция для броска любого кубика
roll_dice() {
    local sides=$1   # Количество граней кубика
    echo "$(($RANDOM % sides + 1))"
}

while true; do
    read -p "
Выберите кубик для броска:
1. d4
2. d6
3. d8
4. d10
5. d12
6. d20
7. Закончить игру
Ваш выбор: " choice

    # Проверяем выбранный вариант
    case $choice in
        1|2|3|4|5|6)
            dice=$choice      # Запоминаем выбранный кубик
            while true; do
                # Бросаем кубик
                case $dice in
                    1) result=$(roll_dice 4); echo "Результат броска d4: $result";;
                    2) result=$(roll_dice 6); echo "Результат броска d6: $result";;
                    3) result=$(roll_dice 8); echo "Результат броска d8: $result";;
                    4) result=$(roll_dice 10); echo "Результат броска d10: $result";;
                    5) result=$(roll_dice 12); echo "Результат броска d12: $result";;
                    6) result=$(roll_dice 20); echo "Результат броска d20: $result";;
                esac

                # Предлагают пользователю повторение броска, смену кубика или завершение программы
                read -p "Что хотите сделать дальше?
1. Бросить ещё раз тот же кубик
2. Выбрать другой кубик
3. Завершить игру
Ваш выбор: " next_choice

                case $next_choice in
                    1) continue;;           # Продолжаем цикл бросков текущего кубика
                    2) break;;              # Возвращаемся к выбору нового кубика
                    *) echo "Игра завершена."; exit 0;;
                esac
            done
            ;;
        7)
            echo "Игра завершена."
            exit 0
            ;;
        *)
            echo "Некорректный ввод. Повторите попытку."
            continue
            ;;
    esac
done