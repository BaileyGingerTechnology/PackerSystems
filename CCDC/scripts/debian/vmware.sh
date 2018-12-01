#!/bin/bash

set -e

if [ "$PACKER_BUILDER_TYPE" != "vmware-iso" ]; then
  exit 0
fi

sudo apt update

sudo apt-get -y install perl make linux-headers-$(uname -r) xserver-xorg

sudo mkdir /mnt/vmware
sudo mount -o loop,ro ~/linux.iso /mnt/vmware

mkdir /tmp/vmware
tar zxf /mnt/vmware/VMwareTools-*.tar.gz -C /tmp/vmware
sudo /tmp/vmware/vmware-tools-distrib/vmware-install.pl --default --force-install
rm -r /tmp/vmware

sudo umount /mnt/vmware
sudo rm -r /mnt/vmware
rm -f ~/linux.iso

sudo tee -a /etc/vmware-tools/locations <<EOF
remove_answer ENABLE_VGAUTH
answer ENABLE_VGAUTH no
remove_answer ENABLE_VMBLOCK
answer ENABLE_VMBLOCK no
EOF
sudo /usr/bin/vmware-config-tools.pl --default --skip-stop-start

mkdir /home/administrator/Pictures
