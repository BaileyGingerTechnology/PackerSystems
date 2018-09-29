#!/bin/bash

set -e

if [ "$PACKER_BUILDER_TYPE" != "qemu" ]; then
	exit 0
fi

pacman -S --needed --noconfirm qemu-guest-agent