#!/bin/bash
# Author  : Bailey Kasin
# Date    : 12/14/2017
# Purpose : Find system info before starting everything

function check_root() {
	echo "Super user access is needed as disk partition modification and mounting will happen."

	if [ "$EUID" != 0 ]; then
		echo "$_MSGERROR No Super User access....now exiting.."
		exit 0
	fi
}

function not_gentoo() {
	echo "Since you are not using Gentoo, going to install mirrorselect from source."
	chmod +x /tmp/install_mirrorselect.sh
	/tmp/install_mirrorselect.sh
}

function check_distro() {
	# This Variable will be output to a file.
	# Then later be used in determining package managers
	# And other distro dependent configs, services or commands.

	_DISTRO=$(cat /etc/*-release | tr [:upper:] [:lower:] | grep -Poi '(debian|ubuntu|red hat|centos|gentoo|arch)' | uniq)
	echo "$_DISTRO" >/tmp/_DISTRO

	if [ -z "$_DISTRO" ]; then
		_DISTRO="$_MSGERROR Distrobution Detection Failed!"
	fi

	echo -e "\n"

	if [ "$_DISTRO" = "arch" ]; then
		echo "Since you are not on Gentoo, some extra steps will need to be taken
    during portions of this install, but it should still all go fine."
		pacman -Sy
		pacman -S --needed --noconfirm rsync git wget links ntp dialog python2 python2-pip
		not_gentoo
	fi
}
