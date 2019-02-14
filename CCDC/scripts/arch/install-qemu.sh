#!/bin/bash

set -e

if [ "$PACKER_BUILDER_TYPE" != "qemu" ]; then
	exit 0
fi

# Build sometimes forgets DNS is a thing
resolv=$(cat /etc/resolv.conf)
if [ "$resolv" != *"nameserver"* ]; then
	echo "nameserver 1.1.1.1" >> /etc/resolv.conf
fi

pacman -S --needed --noconfirm qemu-guest-agent

systemctl enable qemu-guest-agent

systemctl reboot
