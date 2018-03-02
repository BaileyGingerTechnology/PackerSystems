#!/bin/bash
# Author  : Bailey Kasin
# Date    : 12/14/2017
# Purpose : Functions used for disk setup

function set_filesystems
{
	# Make the boot partition FAT32
	mkfs.vfat -F 32 $12
	# Make the file partition ext4
	mkfs.ext4 $14
	# Make the third partition swap
	mkswap $13
	swapon $13

	echo "Filesystems set. Mounting partition where system will be built."

	orangeEcho "Making an fstab file now, which will be used later."
	# This file is used by both the system and genkernel. Easier to make it now than later
	touch /tmp/fstab
	echo "/dev/$12		/boot		ext2	defaults,noatime	0 2" >> /tmp/fstab
	echo "/dev/$13		none		swap	sw					0 0" >> /tmp/fstab
	echo "/dev/$14		/			ext4	noatime				0 1" >> /tmp/fstab
	echo "/dev/cdrom	/mnt/cdrom	auto	noauto,user			0 0" >> /tmp/fstab
}

function partition_disk
{
	# Save the disk used to a file for later use
	echo $1 > /tmp/diskUsed.txt

	# Make the disk GPT to make life easy later
	echo "Using parted to label disk GPT."
	parted -a optimal $1 mklabel gpt
	# Partition sizes will be given in megabytes
	parted -a optimal $1 unit mib
	echo "Setting partition format as recommended in Gentoo Handbook."
	# Refer to the disk setup chapter for specifics
	# But basically
	# Four partitions. grub, boot, swap, files
	parted -a optimal $1 mkpart primary 1 3
	parted -a optimal $1 name 1 grub
	parted -a optimal $1 set 1 bios_grub on
	parted -a optimal $1 mkpart primary 3 131
	parted -a optimal $1 name 2 boot
	parted -a optimal $1 mkpart primary 131 643
	parted -a optimal $1 name 3 swap
	parted -a optimal $1 mkpart primary 643 -- -1
	parted -a optimal $1 name 4 rootfs
	parted -a optimal $1 set 2 boot on
	parted -a optimal $1 print

	echo "Formatting disks complete. Now setting file system types."
	set_filesystems $1
}