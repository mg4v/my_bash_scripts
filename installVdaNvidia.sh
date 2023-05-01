#!/bin/bash

nvidia_vers=`ubuntu-drivers devices | grep -i recommended`

if lspci | grep -i nvidia ; then
  echo "The system has an NVIDIA graphics card"
  echo "<------>"
  read -p "Do you want to install the video $nvidia_vers version?" -n 1 -r
  echo    # (optional) move to a new line
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
   ubuntu-drivers autoinstall -y
  else
    breack 
  fi
fi