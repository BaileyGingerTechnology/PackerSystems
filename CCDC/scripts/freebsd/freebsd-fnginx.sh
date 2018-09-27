#!/bin/sh
# Author: Bailey Kasin

echo "Doing Nginx"
echo 'rowling.gingertech.com' >/etc/hostname

ASSUME_ALWAYS_YES=yes pkg install nginx mod_php71 php71-mysqli php71-xml php71-hash php71-gd php71-curl php71-tokenizer php71-zlib php71-zip

sysrc nginx_enable="yes"
service nginx start

sed -i.bak 's/\#user\ nobody/user www/g' /usr/local/etc/nginx/nginx.conf
rm /usr/local/etc/nginx/nginx.conf.bak

sh -c "echo \"<?php phpinfo(); ?>\" | tee /usr/local/www/nginx/phpinfo.php"

cd /root || exit 1
tar xvf wordpress.tar.gz
mv wordpress/* /usr/local/www/nginx/
