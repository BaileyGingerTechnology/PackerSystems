#!/bin/sh
# Author: Bailey Kasin

echo "Doing MySQL"

sysrc mysql_enable=”YES”
service mysql-server start

echo 'sshd_enable="YES"' >> /etc/rc.conf