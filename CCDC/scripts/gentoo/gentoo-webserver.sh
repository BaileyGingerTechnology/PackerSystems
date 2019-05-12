#!/bin/bash
# Author: Bailey Kasin

echo "Reboot success. In system."

echo 'dlacey.gingertech.com' >/etc/hostname

# Gonna have it be a NextCloud webserver
echo ">=dev-lang/php-7.1.16 gd postgres pdo intl zip xmlreader curl xmlwriter fpm sqlite apache2" >>/etc/portage/package.use/web-unmask
echo ">=app-eselect/eselect-php-0.9.4-r5 fpm apache2" >>/etc/portage/package.use/web-unmask
echo "www-apps/nextcloud" >>/etc/portage/package.accept_keywords/web-words
sed -i 's/\bUSE=\b/apache2\ /' /etc/portage/make.conf

emerge www-servers/apache dev-lang/php
emerge www-apps/nextcloud
mv /tmp/config.php /var/www/localhost/htdocs/nextcloud/config/config.php

sed -i 's/-D LANGUAGE/-D LANGUAGE -D PHP/g' /etc/conf.d/apache2
rc-update add apache2 default

# Since most people panic when they see Gentoo, I'm not really sure how much I should do to it,
# given that from what I've seen, they'll forget the basics of Linux, not know the package manager,
# and the way that Gentoo handles webapps is a bit odd compared to other Linux flavors

emerge dev-lang/go
mv /home/administrator/oh /bin/oh
chmod +x /bin/oh
echo /bin/oh >>/etc/shells
echo /bin/oh >>/home/administrator/.bashrc
chsh -s /bin/oh administrator

yes -- "-5" | etc-update

# Add users from CSV
cd /tmp
sudo newusers <userlist.csv

# Assign static IP
intface=$(ifconfig | grep -E '192|172|10' -B1 | grep -v -E 'bond|txq|\-\-' | head -n1 | awk '{print $1}' | cut -d":" -f1)
sudo tee /etc/conf.d/net <<EOF
config_$intface="172.16.16.7/24"
routes_$intface="default via 172.16.16.1"
dns_servers_$intface="172.16.16.50"
EOF
