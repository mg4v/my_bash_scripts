#!/bin/bash

# Настройки
DIR1="/path/to/directory1"
DIR2="/path/to/directory2"
EXCLUDED_FILES="file1.txt file2.txt"
LOG_FILE="sync.log"

# Функция для записи сообщений в лог-файл
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$LOG_FILE"
}

# Проверка наличия директорий
if [ ! -d "$DIR1" ] || [ ! -d "$DIR2" ]; then
    log "Ошибка: Одна из указанных директорий не существует."
    exit 1
fi

# Инициализация лог-файла
echo "Начало синхронизации: $(date)" > "$LOG_FILE"

# Проходим по всем файлам в первой директории
for file in "$DIR1"/*; do
    filename=$(basename -- "$file")
    
    # Пропускаем файлы из списка исключений
    if [[ " ${EXCLUDED_FILES[@]} " =~ " ${filename} " ]]; then
        continue
    fi
    
    # Проверяем наличие файла во второй директории
    if [ -f "$DIR2/$filename" ]; then
        # Сравнение содержимого файлов
        if ! diff -q "$file" "$DIR2/$filename" &> /dev/null; then
            # Заменяем файл в первой директории на файл из второй
            cp -f "$DIR2/$filename" "$file"
            log "Файл '$filename' обновлён (контент отличается)"
        else
            log "Файлы '$filename' идентичны, замена не требуется"
        fi
    else
        # Удаляем файл из первой директории, если его нет во второй
        rm "$file"
        log "Файл '$filename' удалён (нет в директории 2)"
    fi
done

# Проходим по всем файлам во второй директории
for file in "$DIR2"/*; do
    filename=$(basename -- "$file")
    
    # Пропускаем файлы из списка исключений
    if [[ " ${EXCLUDED_FILES[@]} " =~ " ${filename} " ]]; then
        continue
    fi
    
    # Проверяем наличие файла в первой директории
    if [ ! -f "$DIR1/$filename" ]; then
        # Копируем файл из второй директории в первую
        cp "$file" "$DIR1/"
        log "Файл '$filename' скопирован (нет в директории 1)"
    fi
done

echo "Конец синхронизации: $(date)" >> "$LOG_FILE"