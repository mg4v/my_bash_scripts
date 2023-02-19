#!/bin/bash
## Installs the minimum set of system software in ubuntu that I need.

apt update && \
apt install \
mc htop bashtop neofetch tmux lynx vim nano -y
