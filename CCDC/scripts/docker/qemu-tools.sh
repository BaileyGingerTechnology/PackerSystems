#!/bin/bash

if [ "$PACKER_BUILDER_TYPE" != "qemu" ]; then
	exit 0
fi

# Install dependencies
sudo yum install -y qemu-guest-agent