#!/bin/bash

#echo "app-emulation/virtualbox-guest-additions ~amd64" >> /etc/portage/package.accept_keywords

emerge app-emulation/virtualbox-guest-additions

gpasswd -a administrator vboxguest
gpasswd -a root vboxguest

echo 'modules="vboxdrv vboxnetadp vboxnetflt vboxpci"' >> /etc/conf.d/modules

reboot