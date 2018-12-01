#!/bin/bash

set -e

if [ "$PACKER_BUILDER_TYPE" != "qemu" ]; then
    exit 0
fi

sudo apt update && apt -y full-upgrade
sudo apt -y --reinstall install qemu-guest-agent fuse
sudo reboot
