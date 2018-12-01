#!/bin/sh

if [ "$PACKER_BUILDER_TYPE" != "vmware-iso" ]; then
    exit 0
fi

sudo pkg install -y open-vm-tools-nox11

sudo tee -a /etc/rc.conf <<EOF
vmware_guest_vmblock_enable="YES"
vmware_guest_vmhgfs_enable="NO"
vmware_guest_vmmemctl_enable="YES"
vmware_guest_vmxnet_enable="YES"
vmware_guestd_enable="YES"
EOF
