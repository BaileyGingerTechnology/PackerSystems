#!/bin/bash

set -e
set -x

sudo bash -c "echo 'APT::Get::AllowUnauthenticated "true";' >> /etc/apt/apt.conf"

WRAPPER=/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper

$WRAPPER begin
# The package repository for helium has been moved to dev.packages.vyos.net/legacy/repos/vyos
$WRAPPER set system package repository community components 'main'
$WRAPPER set system package repository community distribution 'helium'
$WRAPPER set system package repository community url 'http://dev.packages.vyos.net/legacy/repos/vyos'
$WRAPPER set system package repository squeeze components 'main contrib non-free'
$WRAPPER set system package repository squeeze distribution 'squeeze'
$WRAPPER set system package repository squeeze url 'http://archive.debian.org/debian'
$WRAPPER commit
$WRAPPER save
$WRAPPER end

sudo aptitude -y update

if [ "$PACKER_BUILDER_TYPE" != "vmware-iso" ]; then
  exit 0
fi

sudo ln -s /dev/null /etc/udev/rules.d/65-vyatta-net.rules

sudo apt-get -y install make
sudo apt-get -y install gcc
sudo apt-get -y install linux-vyatta-kbuild

sudo ln -s /usr/src/linux-image/debian/build/build-amd64-none-amd64-vyos "/lib/modules/$(uname -r)/build"

sudo mkdir /mnt/vmware
sudo mount -o loop,ro ~/linux.iso /mnt/vmware

mkdir /tmp/vmware
tar zxf /mnt/vmware/VMwareTools-*.tar.gz -C /tmp/vmware
sudo /tmp/vmware/vmware-tools-distrib/vmware-install.pl --default --force-install
rm -r /tmp/vmware

sudo umount /mnt/vmware
sudo rm -r /mnt/vmware
rm -f ~/linux.iso