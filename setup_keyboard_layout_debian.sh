#!/bin/bash

# Update package list
echo "Updating package lists..."
apt-get update > /dev/null

# Install the locales package
echo "Installing locales package..."
apt-get install -y locales > /dev/null

# Reconfigure locales
echo "Reconfiguring locales..."
dpkg-reconfigure locales << EOF
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
EOF

# Modify keyboard configuration files to add Russian layout
echo "Configuring keyboard layouts..."
sed -i 's/XKBLAYOUT=".*"/XKBLAYOUT="us,ru"/g' /etc/default/keyboard
sed -i 's/XKBVARIANT=".*"/XKBVARIANT=","/g' /etc/default/keyboard
sed -i 's/XKBOPTIONS=".*"/XKBOPTIONS="grp:alt_shift_toggle,compose:rwin"/g' /etc/default/keyboard

# Reload keyboard settings
echo "Reloading keyboard settings..."
setupcon || systemctl restart keyboard-setup.service

# Inform user that script has completed successfully
echo "Done! Now you can switch between English and Russian keyboard layouts using Alt+Shift."