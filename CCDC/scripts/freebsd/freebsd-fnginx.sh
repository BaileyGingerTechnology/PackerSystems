#!/bin/sh
# Author: Bailey Kasin

echo "Doing Nginx"
echo 'rowling.gingertech.com' >/etc/hostname

sysrc nginx_enable="yes"
service nginx start

sed -i.bak 's/\#user\ nobody/user www/g' /usr/local/etc/nginx/nginx.conf
rm /usr/local/etc/nginx/nginx.conf.bak

sh -c "echo \"<?php phpinfo(); ?>\" | tee /usr/local/www/phpinfo.php"

pw user add -n scoringengine -s /bin/tcsh -d /home/scoringengine -m -w yes

cd /root || exit 1
tar xvf wordpress.tar.gz
mv wordpress/* /usr/local/www/
