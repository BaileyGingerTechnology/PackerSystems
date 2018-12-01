#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive

if [ "$PACKER_BUILDER_TYPE" != "vmware-iso" ]; then
    exit 0
fi

sudo apt update && sudo apt -y full-upgrade
sudo apt -y --reinstall install open-vm-tools fuse
sudo reboot
