#!/bin/bash

nvidia_vers=`ubuntu-drivers devices | grep -i recommended`

if lspci | grep -i nvidia ; then
  echo -e "The system has an NVIDIA graphics card \nCurrent driver version:\n"
  cat /proc/driver/nvidia/version
  echo -e "<------>\nDo you want to install the video\n$nvidia_vers version?"
  read -p ": " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    ubuntu-drivers autoinstall
  else
    echo -e "\nThe driver installation was interrupted by the user\n" 
  fi
fi