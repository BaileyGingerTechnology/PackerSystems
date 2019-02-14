#!/bin/bash
# Author: Bailey Kasin

set -e

if [ "$PACKER_BUILDER_TYPE" != "vmware-iso" ]; then
	exit 0
fi

# Build sometimes forgets DNS is a thing
resolv=$(cat /etc/resolv.conf)
if [ "$resolv" != *"nameserver"* ]; then
	echo "nameserver 1.1.1.1" >> /etc/resolv.conf
fi

pacman -S --needed --noconfirm base-devel net-tools linux-headers linux-api-headers git go

cd /tmp
sudo -u administrator bash -c 'git clone https://aur.archlinux.org/yay.git'
cd yay
sudo -u administrator bash -c 'makepkg -si --noconfirm'

# This package is sadly broken now. RIP. Hopefully it gets fixed soon
#sudo -u administrator bash -c 'yay -S open-vm-tools-dkms --noconfirm'

# Until the DKMS package is fixed, falling back to this one
pacman -S open-vm-tools
systemctl enable vmtoolsd

systemctl reboot
