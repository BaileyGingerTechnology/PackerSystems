#!/bin/bash

if [ "$PACKER_BUILDER_TYPE" != "virtualbox-iso" ]; then
	exit 0
fi

# Install dependencies
sudo yum install -y gcc make perl bzip2 kernel-devel-$(uname -r)

# Mount Guest Additions ISO file
sudo mount -t iso9660 -o loop /root/VBoxGuestAdditions.iso /mnt

# Execute the installer
sudo /mnt/VBoxLinuxAdditions.run

sudo rm -f /var/log/vboxadd-install*.log
sudo rm -f /var/log/VBoxGuestAdditions.log

# Unmount ISO file
sudo umount /mnt

# Delete ISO file
sudo rm -f /root/VBoxGuestAdditions.iso