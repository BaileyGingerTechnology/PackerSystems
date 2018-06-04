#!/bin/bash
# Author: Bailey Kasin

echo "Reboot success. In system."

# Gonna have it be a OwnCloud webserver
echo ">=dev-lang/php-7.1.16 gd mysql mysqli pdo intl zip xmlreader curl xmlwriter fpm sqlite" >> /etc/portage/package.use/web-unmask
echo ">=app-eselect/eselect-php-0.9.4-r5 fpm" >> /etc/portage/package.use/web-unmask
echo "www-apps/owncloud" >> /etc/portage/package.accept_keywords
#sed -i 's/\bUSE=\b/apache2\ /' /etc/portage/make.conf

emerge www-servers/apache dev-lang/php
emerge www-apps/owncloud
emerge app-admin/webapp-config

webapp-config -h gentweb.gingertech.com -d gingercloud -I owncloud 10.0.8

rc-update add apache2 default

# Since most people panic when they see Gentoo, I'm not really sure how much I should do to it,
# given that from what I've seen, they'll forget the basics of Linux, not know the package manager,
# and the way that Gentoo handles webapps is a bit odd compared to other Linux flavors

emerge dev-lang/go
mv /home/administrator/oh /bin/oh
chmod +x /bin/oh
echo /bin/oh >> /etc/shells
chsh -s /bin/oh administrator

yes -- "-5" | etc-update