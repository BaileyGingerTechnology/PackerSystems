#!/bin/bash
# Author  : Bailey Kasin
# Date    : 12/25/2017
# Purpose : Functiona used to get the stage3 tarball

function emerge_update
{
	# Finish the chroot
	source /etc/profile
	export PS1="(chroot) ${PS1}"

	# Finish mounting now that we are chrooted
	echo "Mounting boot partition."
	mkdir /boot
	mount /dev/sda2 /boot

	# Get the latest metadata
	emerge-webrsync
	# Check for new versions. Also output the output to a file
	emerge --sync |tee emergeOutput.txt

	# Set a variable equal to the sync output, then get rid of every
	# line that doesn't contain --oneshot portage, which will only
	# be there if portage needs an update.
	portageUpdate=$(cat emergeOutput.txt |grep 'oneshot portage')

	# Update portage if needed
	if [[ $portageUpdate = *"oneshot"* ]]; then
		emerge --oneshot portage
	fi
}

function resolv_mount
{
	# Make the repos.conf directory for portage
	mkdir --parents /mnt/gentoo/etc/portage/repos.conf
	# And then put the default config there
	rsync -ah --progress /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
	echo "Copying over resolv.conf"
	cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
	echo "Copying over the fstab file made earlier"
	rsync -ah --progress /tmp/fstab /mnt/gentoo/etc/

	echo "Mount filesystem and chroot."
	mount --types proc /proc /mnt/gentoo/proc
	mount --rbind /sys /mnt/gentoo/sys
	mount --make-rslave /mnt/gentoo/sys
	mount --rbind /dev /mnt/gentoo/dev
	mount --make-rslave /mnt/gentoo/dev

	# OSes other than Gentoo need an extra step when mounting
	if [ "$_DISTRO" != "gentoo" ]; then
		test -L /dev/shm && rm /dev/shm && mkdir /dev/shm
		mount --types tmpfs --options nosuid,nodev,noexec shm /dev/shm
		chmod 1777 /dev/shm
	fi

	greenEcho "About to chroot. This will begin step two, which will cause a second run of the preflight steps, and then everything will pick up where it left off. Press enter to continue."
	read enter
	chroot /mnt/gentoo /bin/bash GentooInstall/step_two.sh
}

function make_make
{
	# Get how many cores/threads the CPU has, and then add 1
	core_count=$(lscpu |grep CPU |(sed -n 2p) |awk '{print $2}')
	let core_count+=1

	# Use the mirrorselect script to autoselect the best mirror to sync from
	greenEcho "Now autopicking the closest mirror to you by downloading 100kb from each option and going with the fastest one."
	greenEcho "To limit how long this will take..."

    mirrorselect -s4 -b10 -o -c ${COUNTRY:-USA} -D >> /mnt/gentoo/etc/portage/make.conf

	# If setting the core count kept the plus, set it to 2 instead
	# Otherwise, echo the core count into make.conf
	if [[ $core_count = *"+"* ]]; then
		echo "MAKEOPTS=-j2" >> /mnt/gentoo/etc/portage/make.conf
	else
		echo "MAKEOPTS=-j$core_count" >> /mnt/gentoo/etc/portage/make.conf
	fi

	echo "Portage configured. Preparing for chroot."
	resolv_mount
}

function download_tarball
{
	cd /mnt/gentoo

	greenEcho "This is where we get the tarball that will be used to make the base filesystem. Eventually I may be able to automate this part, but for now I am going to open links to Gentoo's mirror page.
	Pick a server close to you, and then the stage 3 .tar.bz2 that best matches your system."
	
	wget ${TARBALL}

	# Expand it and keep file attributes and permissions the same
	echo "Unpacking the tarball."
	tar xvpf stage3-*.tar.xz --xattrs --numeric-owner

	echo "Tarball unpacked. Configuring make.conf for Portage."
	make_make
}