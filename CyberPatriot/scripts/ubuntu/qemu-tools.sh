#!/bin/bash

if [ "$PACKER_BUILDER_TYPE" != "qemu" ]; then
	exit 0
fi

apt install -y qemu-guest-agent
