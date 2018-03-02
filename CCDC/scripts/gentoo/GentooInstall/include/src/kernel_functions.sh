#!/bin/bash
# Author  : Bailey Kasin
# Date    : 2/19/2018
# Purpose : Download and install the kernel

function download_install_kernel
{
    # Download kernel sources
    emerge sys-kernel/gentoo-sources

    # Install pciutils and genkernel. One because it is super useful in general
    # the other because it's easier than making a kernel .config file without
    # knowing the system
    emerge sys-apps/pciutils sys-kernel/genkernel

    # Compile the kernel
    genkernel all

    emerge sys-kernel/linux-firmware
}