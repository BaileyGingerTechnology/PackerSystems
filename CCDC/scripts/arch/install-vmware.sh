#!/bin/bash
# Author: Bailey Kasin

set -e

if [ "$PACKER_BUILDER_TYPE" != "vmware-iso" ]; then
	exit 0
fi

pacman -S --needed --noconfirm base-devel net-tools linux-headers git go

cd /tmp
sudo -u administrator bash -c 'git clone https://aur.archlinux.org/yay.git'
cd yay
sudo -u administrator bash -c 'makepkg -si --noconfirm'

sudo -u administrator bash -c 'yay -S open-vm-tools-dkms --noconfirm'
