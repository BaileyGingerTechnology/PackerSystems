#!/bin/bash

echo 'arditi.gingertech.com' >/etc/hostname

# Build sometimes forgets DNS is a thing
resolv=$(cat /etc/resolv.conf)
if [ "$resolv" != *"nameserver"* ]; then
	echo "nameserver 9.9.9.9" >> /etc/resolv.conf
fi

# Updating to most recent packages
echo "Updating"
pacman -Syu --noconfirm

# Install packages that will be needed
pacman -S --needed --noconfirm libarchive go nginx python git xorg-server

# Enable NGINX for the reverse proxy
systemctl enable nginx

# And then have zsh be the default shell
yes password | chsh -s /usr/bin/zsh

# Install scoring engine
cd /tmp || exit 1
pacman -U --noconfirm ScoringEngine.pkg.tar.xz
systemctl enable gogios

# Setup NGINX reverse proxy
mv /tmp/nginx.conf /etc/nginx/nginx.conf

# Setup BlackArch repos
cd /tmp
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh ; ./strap.sh

pacman -S --needed --noconfirm blackarch-webapp blackarch-scanner blackarch-windows blackarch-networking blackarch-exploitation

# Openbox desktop environment
sudo pacman -S --needed --noconfirm openbox blackarch-config-openbox obmenu obconf oblogout python2-xdg xorg-xinit firefox
cp /usr/share/blackarch/config/openbox/etc/xdg/openbox/* /etc/xdg/openbox/
mkdir -p /usr/share/themes/blackarch
cp /usr/share/blackarch/config/openbox/usr/share/themes/blackarch/openbox-3/themerc /usr/share/themes/blackarch/openbox-3
echo 'exec openbox-session' > /root/.xinitrc
echo 'exec openbox-session' > /home/administrator/.xinitrc
chown administrator /home/administrator/.xinitrc

echo "Run startx for an openbox session" > /etc/motd
echo "Otherwise, have fun! You're running the scoring engine and have BlackArch repos enabled." >> /etc/motd

# Setup for static IP
cd ~/
intface=$(ip a | grep 2: | head -n1 | awk '{print $2}' | cut -d":" -f1)
sed -i "s/REPLACE/$intface/" dhcpcd.conf 
sudo mv dhcpcd.conf /etc/dhcpcd.conf
