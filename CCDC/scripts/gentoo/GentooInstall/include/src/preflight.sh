#!/bin/bash
# Author  : Bailey Kasin
# Date    : 12/14/2017
# Purpose : Find system info before starting everything

function check_root
{
    redEcho "Super user access is needed as disk partition modification and mounting will happen."

    if [ "$EUID" != 0 ]; then
      redEcho "$_MSGERROR No Super User access....now exiting..";
      exit 0;
    fi
}

function check_distro
{
    # This Variable will be output to a file.
    # Then later be used in determining package managers
    # And other distro dependent configs, services or commands.

    _ID=0
    _DISTRO=$( cat /etc/*-release | tr [:upper:] [:lower:] | grep -Poi '(debian|ubuntu|red hat|centos|gentoo|arch)' | uniq )
    echo $_DISTRO > /tmp/_DISTRO

    if [ -z $_DISTRO ]; then
      _DISTRO='$_MSGERROR Distrobution Detection Failed!'
    fi

    echo -e "\n"

    if [ "$_DISTRO" = "arch" ]; then
      _ID=6
      _NAME=Arch
      _BANNER=""
      pacman -Sy
      pacman -S --noconfirm rsync git wget links ntp dialog
    fi
}