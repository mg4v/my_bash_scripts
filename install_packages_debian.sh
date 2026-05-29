#!/bin/bash

# List of required packages
PACKAGES="gcc make perl terminator vim tmux mc htop xorg icewm xrdp eog evince mplayer firefox-esr lynx pavucontrol"

# Update the package index before installing new packages
echo "Updating package list..."
apt update || { echo "Failed to update package list."; exit 1; }

# Install selected packages with automatic dependency resolution
echo "Installing packages: ${PACKAGES}"
apt install -y ${PACKAGES} || { echo "Installation failed."; exit 1; }

# Check if installation was successful
if [ "$?" -eq 0 ]; then
      echo "Packages installed successfully."
else
      echo "Error occurred during installation."
fi