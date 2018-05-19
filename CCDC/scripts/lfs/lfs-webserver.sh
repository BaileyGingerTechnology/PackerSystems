#!/bin/bash

echo "We made it. Now for finishing touches."

echo "lfsweb" > /etc/hostname

rm $LFS/finish-base.sh
rm $LFS/build-to-bash.sh
rm $LFS/package-manager.sh