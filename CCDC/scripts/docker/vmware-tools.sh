#!/bin/bash

if [ "$PACKER_BUILDER_TYPE" != "vmware-iso" ]; then
	exit 0
fi

# Install dependencies
sudo yum install -y perl net-tools

# Mount VMware Tools ISO file
sudo mount -t iso9660 -o loop /root/linux.iso /mnt

# Execute the installer
cd /tmp || exit 1
cp /mnt/VMwareTools-*.gz .
tar zxvf VMwareTools-*.gz
sudo ./vmware-tools-distrib/vmware-install.pl -d

# Unmount ISO file
sudo umount /mnt

# Delete ISO file
sudo rm -f /root/linux.iso

# Delete copied files from ISO
sudo rm -rf VMwareTools-.gz vmware-tools-distrib