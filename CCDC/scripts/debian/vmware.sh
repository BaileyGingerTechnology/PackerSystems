#!/bin/bash

set -e
set -x

if [ "$PACKER_BUILDER_TYPE" != "vmware-iso" ]; then
  exit 0
fi

sudo mkdir /temp/
sudo chown -R administrator:administrator /temp
cd /temp
mkdir debian

sudo mv /home/administrator/sources.list /etc/apt/sources.list
sudo apt update

sudo apt-get -y install perl
sudo apt-get -y install make
sudo apt-get -y install linux-headers-$(uname -r)
sudo apt-get -y install xserver-xorg

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