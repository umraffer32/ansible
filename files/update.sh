#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean
#./reboot.sh | grep [Rr]eboot

# Check if reboot is required
echo "Checking if a reboot is required..."

if [ -f /var/run/reboot-required ]; then
    echo "Reboot is required."

    read -p "Do you want to reboot now? (y/N): " answer
    case "$answer" in
        [Yy]* )
            echo "Rebooting now..."
            reboot
            ;;
        * )
            echo "Reboot skipped. Please reboot later."
            ;;
    esac
else
    echo "No reboot required."
fi














# Check if reboot is required
#echo "Checking if a reboot is required..."
#if [ -f /var/run/reboot-required ]; then
#    echo "Reboot is required"
#else
#    echo "No reboot required"
#fi
