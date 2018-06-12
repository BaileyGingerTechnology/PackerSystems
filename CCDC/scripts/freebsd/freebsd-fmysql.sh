#!/bin/sh
# Author: Bailey Kasin

echo "Doing MySQL"

ASSUME_ALWAYS_YES=yes pkg install mariadb102-server mariadb102-client

sysrc mysql_enable="YES"
service mysql-server start

echo 'sshd_enable="YES"' >> /etc/rc.conf