#!/bin/bash

set -e

if [ "$PACKER_BUILDER_TYPE" != "qemu" ]; then
  exit 0
fi

sudo apt update

sudo apt-get -y install qemu-guest-agent