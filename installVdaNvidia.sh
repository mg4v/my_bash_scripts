#!/bin/bash

# Получаем информацию о рекомендованном драйвере NVIDIA
nvidia_vers=$(ubuntu-drivers devices | grep -i recommended)

# Проверяем, есть ли в системе видеокарта NVIDIA
if lspci | grep -i nvidia ; then
  # Выводим сообщение о наличии видеокарты и показываем текущую версию драйвера
  echo -e "The system has an NVIDIA graphics card \nCurrent driver version:\n"
  cat /proc/driver/nvidia/version

  # Печатаем разделитель и предлагаем установить новую версию драйвера
  echo -e "<------>\nDo you want to install the video\n$nvidia_vers version?"

  # Считываем ввод пользователя (одну букву Y/y означает согласие)
  read -p ": " -n 1 -r

  # Если пользователь согласился, устанавливаем новый драйвер
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    ubuntu-drivers autoinstall
  else
    # Если пользователь отказался, сообщаем об этом
    echo -e "\nThe driver installation was interrupted by the user\n"
  fi
fi