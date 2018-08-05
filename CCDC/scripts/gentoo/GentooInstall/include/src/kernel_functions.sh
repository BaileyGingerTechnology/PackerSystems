#!/bin/bash
# Author  : Bailey Kasin
# Date    : 2/19/2018
# Purpose : Download and install the kernel

function download_install_kernel() {
	core_count=$(lscpu | grep CPU | (sed -n 2p) | awk '{print $2}')
	echo ">=sys-apps/util-linux-2.30.2-r1 static-libs" >>/etc/portage/package.use/kernel-unmask
	eix-update
	echo ">=gentoo-sources-4.9.96" >>/etc/portage/package.mask/build

	# Download kernel sources
	emerge -1 =sys-kernel/gentoo-sources-4.9.95

	# Install pciutils and genkernel. One because it is super useful in general
	# the other because it's easier than making a kernel .config file without
	# knowing the system
	emerge sys-apps/pciutils sys-kernel/genkernel

	# Copy the pre-made config and compile the kernel
	cd /usr/src/linux || exit 1
	cp /GentooInstall/config .config
	make -j${core_count} && make -j${core_count} modules_install
	make install

	# initramfs, just in case
	genkernel --install initramfs

	emerge sys-kernel/linux-firmware
}
