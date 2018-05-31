#!/bin/bash

umask 022
LFS=/
echo $LFS
LC_ALL=POSIX
echo $LC_ALL
LFS_TGT=$(uname -m)-gt-linux-gnu
echo "On $LFS_TGT"
PATH=/tools/bin:/bin:/usr/bin
CPUS=8

echo "We made it. Now for finishing touches."

sudo bash -c 'echo "gingertechweb" > /etc/hostname'

cd /

sudo rm finish-base.sh
sudo rm build-to-bash.sh
sudo rm package-manager.sh
sudo rm vpkg-provides.sh
sudo rm user-group-setup.sh