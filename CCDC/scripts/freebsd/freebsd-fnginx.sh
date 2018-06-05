#!/bin/sh
# Author: Bailey Kasin

echo "Doing Nginx"

sysrc nginx_enable=”yes”
service nginx start

sed -i.bak 's/\#user\ nobody/user www/g' /usr/local/etc/nginx/nginx.conf

sh -c "echo \"<?php phpinfo(); ?>\" | tee /usr/local/www/nginx/phpinfo.php"

echo 'sshd_enable="YES"' >> /etc/rc.conf