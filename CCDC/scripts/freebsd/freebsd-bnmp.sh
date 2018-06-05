#!/bin/sh
# Author: Bailey Kasin

echo "BNMP = BSD Nginx Mysql/MariaDB PHP"
echo "Such clever"

sudo pkg install -y python36 git-lite libgit2 py36-cython py36-pip vim py36-iocage

sudo tee -a /etc/rc.conf << EOF
ezjail_enable=YES
cloned_interfaces="lo1"
EOF
echo "FIND ME"
## Restart netif ##
sudo service netif cloneup
## Verify it ##
sudo ifconfig
sleep 10

sudo ezjail-admin install -p
sudo ezjail-admin update -u
sleep 60

sudo ezjail-admin create fnginx 'lo1|10.0.0.2'
sleep 10
sudo ezjail-admin start fnginx
sleep 60
sudo ezjail-admin create fmysql 'lo1|10.0.0.3'
sleep 10
sudo ezjail-admin start fmysql
sleep 60

sudo cp /etc/pkg/FreeBSD.conf /usr/jails/fgninx/etc/pkg/FreeBSD.conf
sudo cp /etc/pkg/FreeBSD.conf /usr/jails/fmysql/etc/pkg/FreeBSD.conf
sudo cp /etc/resolv.conf /usr/jails/fnginx/etc/resolv.conf
sudo cp /etc/resolv.conf /usr/jails/fmysql/etc/resolv.conf

cd /temp
sudo chmod +x freebsd-*
sudo mv -v /temp/freebsd-fnginx.sh /usr/jails/fnginx/freebsd-fnginx.sh
sudo mv -v /temp/freebsd-fmysql.sh /usr/jails/fmysql/freebsd-fmysql.sh

sudo pkg -j fnginx install -y nginx mod_php71 php71-mysqli php71-xml php71-hash php71-gd php71-curl php71-tokenizer php71-zlib php71-zip
sudo pkg -j fmysql install -y mariadb102-server mariadb102-client

sudo chroot /usr/jails/fnginx \
  ./freebsd-fnginx.sh

sudo chroot /usr/jails/fmysql \
  ./freebsd-fmysql.sh