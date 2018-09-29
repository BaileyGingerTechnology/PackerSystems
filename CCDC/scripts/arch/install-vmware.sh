#!/bin/bash
# Author: Bailey Kasin

set -e

if [ "$PACKER_BUILDER_TYPE" != "vmware-iso" ]; then
	exit 0
fi

pacman -S --needed --noconfirm base-devel net-tools linux-headers open-vm-tools
