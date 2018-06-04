#!/bin/sh
# Author: Bailey Kasin

echo "BNMP = BSD Nginx Mysql/MariaDB PHP"
echo "Such clever"

sudo pkg install -y vim ezjail

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
sudo ezjail-admin update -P
sleep 60



sudo ezjail-admin create fnginx 'lo1|10.0.0.2'
sleep 10
sudo ezjail-admin start fnginx
sleep 60
sudo ezjail-admin create fmysql 'lo1|10.0.0.3'
sleep 10
sudo ezjail-admin start fmysql
sleep 60

cd /temp
sudo chmod +x freebsd-*
sudo mv -v /temp/freebsd-fnginx.sh /usr/jails/fnginx/freebsd-fnginx.sh
sudo mv -v /temp/freebsd-fmysql.sh /usr/jails/fmysql/freebsd-fmysql.sh

sudo chroot /usr/jails/fnginx \
  ./freebsd-fnginx.sh

sudo chroot /usr/jails/fmysql \
  ./freebsd-fmysql.sh