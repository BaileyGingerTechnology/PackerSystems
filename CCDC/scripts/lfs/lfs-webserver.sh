#!/bin/bash

umask 022
LFS=/
echo $LFS
LC_ALL=POSIX
echo $LC_ALL
LFS_TGT=$(uname -m)-gt-linux-gnu
echo "On $LFS_TGT"
CPUS=4

echo "We made it. Now for finishing touches."

bash -c 'echo "gingertechweb" > /etc/hostname'

cd /