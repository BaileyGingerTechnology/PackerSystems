#!/bin/sh
# Author: Bailey Kasin

echo "BNMP = BSD Nginx Mysql/MariaDB PHP"
echo "Such clever"

sudo sh -c "echo 'beddor.gingertech.com' > /etc/hostname"

sudo pkg install -y python36 git-lite libgit2 py36-cython py36-pip vim py36-iocage

# Because this version of FreeBSD is old, stuff is broken a bit
# Workaround for that
ioput=$(sudo iocage 2>&1)
if [ $ioput == *"Shared object"* ]; then
	ln -sf /lib/libc.so.7 /usr/lib/libdl.so.1
fi

sudo iocage activate zroot
echo 6 | sudo iocage fetch

sudo tee -a /etc/sysctl.conf <<EOF
net.inet.ip.forwarding=1       # Enable IP forwarding between interfaces
net.link.bridge.pfil_onlyip=0  # Only pass IP packets when pfil is enabled
net.link.bridge.pfil_bridge=0  # Packet filter on the bridge interface
net.link.bridge.pfil_member=0  # Packet filter on the member interface
EOF
echo "FIND ME"

sudo iocage create -n rowling ip4_addr="em0|172.16.16.31/24" -r 11.1-RELEASE
sleep 10
sudo iocage start rowling
sleep 30

cd /temp || exit 1
sudo chmod +x freebsd-*
sudo mv -v /temp/wordpress.tar.gz /iocage/jails/rowling/root/wordpress.tar.gz
sudo mv -v /temp/freebsd-fnginx.sh /iocage/jails/rowling/root/freebsd-fnginx.sh

ASSUME_ALWAYS_YES=yes sudo iocage pkg rowling install nginx mod_php71 php71-mysqli php71-xml php71-hash php71-gd php71-curl php71-tokenizer php71-zlib php71-zip
sudo iocage set host_hostname="rowling" rowling

sudo chroot /iocage/jails/rowling/root \
	./freebsd-fnginx.sh

sudo rm -f /iocage/jails/rowling/root/freebsd-fnginx.sh
sudo rm -f /iocage/jails/rowling/root/wordpress*

sudo iocage set boot=on rowling

# Install MySQL on Beddor rather than in Rowling
sudo pkg install -y mariadb102-server mariadb102-client

sudo service mysql-server start
sudo mysql -e 'create database rowlpress;'
sudo mysql rowlpress </temp/rowlpress.sql
sudo mysql -e "grant all privileges on rowlpress.* to 'administrator'@'%' identified by 'password';"

sudo pw user add -n scoringengine -s /bin/tcsh -d /home/scoringengine -m -w yes

sudo -i '' '/8.8.8.8/d' /etc/rc.conf
cat <<EOF > /etc/resolv.conf
nameserver 172.16.16.50
EOF

sudo tee /etc/rc.conf <<EOF
zfs_enable="YES"
sshd_enable="YES"
sendmail_enable="NO"
sendmail_submit_enable="NO"
sendmail_outbound_enable="NO"
sendmail_msp_queue_enable="NO"

hostname="beddor.gingertech.com"

ifconfig em0 inet 172.16.16.30 netmask 255.255.255.0
route add default 172.16.16.1

# set up two bridge interfaces for iocage
cloned_interfaces="bridge0"

# plumb interface em0 into bridge0
ifconfig_bridge0="addm em0 up"
ifconfig_em0="up"
iocage_enable="YES"
EOF

sudo sysrc mysql_enable="YES"
