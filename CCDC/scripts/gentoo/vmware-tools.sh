#!/bin/bash

echo "=app-emulation/open-vm-tools-10.1.15 ~amd64" > /etc/portage/package.accept_keywords/virtualization

emerge app-emulation/open-vm-tools
rc-update add vmware-tools default

echo 'modules="vsock vmw_vsock_virtio_transport vmw_vsock_virtio_transport_common vmw_vsock_vmci_transport"' >> /etc/conf.d/modules

reboot