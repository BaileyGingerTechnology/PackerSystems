#!/bin/bash

set -e
set -x

sudo bash -c "echo 'APT::Get::AllowUnauthenticated "true";' >> /etc/apt/apt.conf"

sudo bash -c "echo 'http://mirrors.kernel.org/debian jessie main contrib non-free' >> /etc/apt/sources.list"

sudo apt -y update

if [ "$PACKER_BUILDER_TYPE" != "vmware-iso" ]; then
	exit 0
fi

sudo ln -s /dev/null /etc/udev/rules.d/65-vyatta-net.rules

sudo apt-get -y install perl make linux-headers-$(uname -r)

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
