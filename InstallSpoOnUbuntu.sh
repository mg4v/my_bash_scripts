#!/bin/bash
## Installs the minimum set of system software in ubuntu that I need.

apt update && \
apt install \
git mc htop bashtop neofetch tmux lynx vim nano wget \
openssh-server net-tools ubuntu-restricted-extras dconf-tools \
flameshot p7zip-rar rar unrar unace arj cabextract \
gnome-shell-extension-manager-y
