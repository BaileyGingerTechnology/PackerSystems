#!/bin/sh
# Author: Bailey Kasin

echo "BNMP = BSD Nginx Mysql/MariaDB PHP"
echo "Such clever"

sudo bash -c "echo 'beddor.gingertech.com' > /etc/hostname"

sudo pkg install -y python36 git-lite libgit2 py36-cython py36-pip vim py36-iocage

sudo iocage activate zroot
echo 6 | sudo iocage fetch

sudo tee -a /etc/rc.conf <<EOF
iocage_enable="YES"
sshd_enable="YES"

# set up two bridge interfaces for iocage
cloned_interfaces="bridge0 bridge1"

# plumb interface em0 into bridge0
ifconfig_bridge0="addm em0 up"
ifconfig_em0="up"
EOF

sudo tee -a /etc/sysctl.conf <<EOF
net.inet.ip.forwarding=1       # Enable IP forwarding between interfaces
net.link.bridge.pfil_onlyip=0  # Only pass IP packets when pfil is enabled
net.link.bridge.pfil_bridge=0  # Packet filter on the bridge interface
net.link.bridge.pfil_member=0  # Packet filter on the member interface
EOF
echo "FIND ME"
## Restart netif ##
sudo service netif cloneup
## Verify it ##
sudo ifconfig
sleep 10

sudo iocage create -n fnginx ip4_addr="em0|10.0.20.31/8" -r 11.1-RELEASE
sleep 10
sudo iocage start rowling
sleep 30

cd /temp
sudo chmod +x freebsd-*
sudo mv -v /temp/freebsd-fnginx.sh /iocage/jails/rowling/root/freebsd-fnginx.sh

sudo chroot /iocage/jails/rowling/root \
	./freebsd-fnginx.sh

sudo rm -f /iocage/jails/rowling/root/freebsd-fnginx.sh

sudo iocage set boot=on rowling

# Install MySQL on Beddor rather than in Rowling
sudo pkg install -y mariadb102-server mariadb102-client

sudo sysrc mysql_enable="YES"
sudo service mysql-server start
