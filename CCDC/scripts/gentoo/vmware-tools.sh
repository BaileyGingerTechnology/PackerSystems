#!/bin/bash

echo "=app-emulation/open-vm-tools" > /etc/portage/package.accept_keywords/virtualization

emerge app-emulation/open-vm-tools

reboot