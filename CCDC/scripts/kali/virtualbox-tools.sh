#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive

if [ "$PACKER_BUILDER_TYPE" != "virtualbox-iso" ]; then
    exit 0
fi

sudo apt update && apt -y full-upgrade
sudo apt -y --reinstall install virtualbox-guest-x11 fuse
sudo reboot
