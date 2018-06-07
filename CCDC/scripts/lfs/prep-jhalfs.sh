#!/bin/bash
# Author: Bailey Kasin

# stop on errors
set -eu
set -x
set +h

#
# This section is from an Arch setup script, since I am using Arch's live CD for the creation of the LFS partitions
#
if [[ $PACKER_BUILDER_TYPE == "qemu" ]]; then
	DISK='/dev/vda'
else
	DISK='/dev/sda'
fi

FQDN='gingertechweb.gingertech.com'
KEYMAP='us'
LANGUAGE='en_US.UTF-8'
PASSWORD=$(/usr/bin/openssl passwd -crypt 'password')
TIMEZONE='UTC'

TARGET_DIR='/mnt'
COUNTRY=${COUNTRY:-US}
export MAKEOPTS=-j${CPUS:-2}
echo $MAKEOPTS

echo "==> Clearing partition table on ${DISK}"
sudo /usr/bin/sgdisk --zap ${DISK}

echo "==> Destroying magic strings and signatures on ${DISK}"
sudo /usr/bin/dd if=/dev/zero of=${DISK} bs=512 count=2048
sudo /usr/bin/wipefs --all ${DISK}
#
# End Arch setup stuff
#

#
# Start LFS setup functions
#

umask 022
LFS=/mnt/lfs
echo $LFS
LC_ALL=POSIX
echo $LC_ALL
LFS_TGT=$(uname -m)-gt-linux-gnu
echo "On $LFS_TGT"
PATH=/tools/bin:/bin:/usr/bin

function set_filesystems
{
	# Make the boot partition ext2
	sudo mkfs.vfat -F32 $12
	# Make the file partition ext4
	sudo mkfs.ext4 $14
	# Make the third partition swap
	sudo mkswap $13
	sudo swapon $13

	echo "Filesystems set. Mounting partition where system will be built."
}

function make_directories
{
  sudo mkdir -pv $LFS/boot

  sudo chown -v administrator $LFS/boot
}

function partition_disk
{
	# Save the disk used to a file for later use
	echo ${DISK} > /tmp/diskUsed.txt

	# Make the disk GPT to make life easy later
	echo "Using parted to label disk GPT."
	sudo parted -a optimal ${DISK} mklabel gpt
	# Partition sizes will be given in megabytes
	sudo parted -a optimal ${DISK} unit mib
	echo "Setting partition format as recommended in Gentoo Handbook."
	# Refer to the disk setup chapter for specifics
	# But basically
	# Four partitions. grub, boot, swap, files
	sudo parted -a optimal ${DISK} mkpart primary 1 3
	sudo parted -a optimal ${DISK} name 1 grub
	sudo parted -a optimal ${DISK} set 1 bios_grub on
	sudo parted -a optimal ${DISK} mkpart primary 3 131
	sudo parted -a optimal ${DISK} name 2 boot
	sudo parted -a optimal ${DISK} mkpart primary 131 643
	sudo parted -a optimal ${DISK} name 3 swap
	sudo parted -a optimal ${DISK} mkpart primary 643 -- -1
	sudo parted -a optimal ${DISK} name 4 rootfs
	sudo parted -a optimal ${DISK} set 2 boot on
	sudo parted -a optimal ${DISK} print

	echo "Formatting disks complete. Now setting file system types."
	set_filesystems ${DISK}
}

partition_disk
sudo mkdir -pv $LFS
sudo mount -v -t ext4 ${DISK}4 $LFS
sudo chown -v administrator $LFS
make_directories

sudo mount -v -t vfat ${DISK}2 $LFS/boot

sudo pacman -Sy
sudo pacman -S --noconfirm libxslt subversion

sudo mkdir /mnt/lfs/sources && sudo chown administrator:administrator -R /mnt/lfs/sources
sudo chmod -v a+wt $LFS/sources
cd $LFS
wget https://files.gingertechnology.net/packersystems/lfs/wget-list
wget --input-file=wget-list --continue --directory-prefix=$LFS/sources

cd /temp
tar xvf jhalfs-2.4.tar.gz && rm jhalfs-2.4.tar.gz
cd jhalfs-2.4
yes "yes" | ./jhalfs run