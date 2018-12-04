#!/bin/bash

set -e

if [ "$PACKER_BUILDER_TYPE" != "virtualbox-iso" ]; then
	exit 0
fi

# VirtualBox Guest Additions
# https://wiki.archlinux.org/index.php/VirtualBox
/usr/bin/pacman -S --needed --noconfirm linux-headers virtualbox-guest-utils virtualbox-guest-modules-arch nfs-utils
echo -e 'vboxguest\nvboxsf\nvboxvideo' >/etc/modules-load.d/virtualbox.conf

/usr/bin/systemctl enable vboxservice.service
/usr/bin/systemctl enable rpcbind.service

# Add groups for VirtualBox folder sharing
/usr/bin/usermod --append --groups administrator,vboxsf administrator
