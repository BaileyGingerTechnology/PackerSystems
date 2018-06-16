#!/bin/sh
# Author: Bailey Kasin

echo "BNMP = BSD Nginx Mysql/MariaDB PHP"
echo "Such clever"

sudo pkg install -y python36 git-lite libgit2 py36-cython py36-pip vim py36-iocage

sudo iocage activate zroot
echo 6 |sudo iocage fetch

sudo tee -a /etc/rc.conf << EOF
iocage_enable="YES"
cloned_interfaces="lo1"
EOF
echo "FIND ME"
## Restart netif ##
sudo service netif cloneup
## Verify it ##
sudo ifconfig
sleep 10

sudo iocage create -n fnginx ip4_addr="lo1|10.0.0.2/24" -r 11.1-RELEASE
sleep 10
sudo iocage start fnginx
sleep 30
sudo iocage create -n fmysql ip4_addr="lo1|10.0.0.3/24" -r 11.1-RELEASE
sleep 10
sudo iocage start fmysql
sleep 30

cd /temp
sudo chmod +x freebsd-*
sudo mv -v /temp/freebsd-fnginx.sh /iocage/jails/fnginx/root/freebsd-fnginx.sh
sudo mv -v /temp/freebsd-fmysql.sh /iocage/jails/fmysql/root/freebsd-fmysql.sh

sudo chroot /iocage/jails/fnginx/root \
  ./freebsd-fnginx.sh

sudo chroot /iocage/jails/fmysql/root \
  ./freebsd-fmysql.sh

sudo iocage set boot=on fnginx
sudo iocage set boot=on fmysql