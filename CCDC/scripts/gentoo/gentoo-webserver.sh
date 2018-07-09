#!/bin/bash
# Author: Bailey Kasin

echo "Reboot success. In system."

echo 'dlacey.gingertech.com' > /etc/hostname

# Gonna have it be a OwnCloud webserver
echo ">=dev-lang/php-7.1.16 gd mysql mysqli pdo intl zip xmlreader curl xmlwriter fpm sqlite" >> /etc/portage/package.use/web-unmask
echo ">=app-eselect/eselect-php-0.9.4-r5 fpm" >> /etc/portage/package.use/web-unmask
echo "www-apps/owncloud" >> /etc/portage/package.accept_keywords/web-words
#sed -i 's/\bUSE=\b/apache2\ /' /etc/portage/make.conf

emerge www-servers/apache dev-lang/php
emerge www-apps/owncloud
emerge app-admin/webapp-config

webapp-config -h dlacey.gingertech.com -d gingercloud -I owncloud 10.0.8

sed -i 's/-D\ LANGUAGE/-D\ LANGUAGE\ -D\ PHP/g' /etc/conf.d/apache2
rc-update add apache2 default

# Since most people panic when they see Gentoo, I'm not really sure how much I should do to it,
# given that from what I've seen, they'll forget the basics of Linux, not know the package manager,
# and the way that Gentoo handles webapps is a bit odd compared to other Linux flavors

emerge dev-lang/go
mv /home/administrator/oh /bin/oh
chmod +x /bin/oh
echo /bin/oh >> /etc/shells
echo /bin/oh >> /home/administrator/.bashrc
chsh -s /bin/oh administrator

yes -- "-5" | etc-update

# Now for fun stuff

sed -i 's/\/var\/www\/localhost\/htdocs/\/var\/www\/dlacey.gingertech.com\/htdocs/g' /etc/apache2/vhosts.d/default_vhost.include
echo '<?php phpinfo(); ?>' > /var/www/dlacey.gingertech.com/htdocs/info.php