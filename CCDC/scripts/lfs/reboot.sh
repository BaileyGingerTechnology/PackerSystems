#!/bin/bash
# Author: Bailey Kasin

LFS=/mnt/lfs

umount -v $LFS/dev/pts
umount -v $LFS/dev
umount -v $LFS/run
umount -v $LFS/proc
umount -v $LFS/sys
umount -Rv $LFS

reboot