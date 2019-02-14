#!/bin/bash

echo 'arditi.gingertech.com' >/etc/hostname

# Build sometimes forgets DNS is a thing
resolv=$(cat /etc/resolv.conf)
if [ "$resolv" != *"nameserver"* ]; then
	echo "nameserver 1.1.1.1" >> /etc/resolv.conf
fi

# Updating to most recent packages
echo "Updating"
/usr/bin/sed -i 's/#\[/\[/g' /etc/pacman.conf
/usr/bin/sed -i 's/\[custom/#\[custom/g' /etc/pacman.conf
/usr/bin/sed -i 's/#Include = /Include = /g' /etc/pacman.conf
pacman -Syu --noconfirm

# Install packages that will be needed
pacman -S --needed --noconfirm dotnet-host dotnet-runtime dotnet-sdk libarchive go nginx python git xorg-server

# Enable NGINX for the reverse proxy
systemctl enable nginx

# And then have zsh be the default shell
yes password | chsh -s /usr/bin/zsh

# Install scoring engine
cd /tmp || exit 1
pacman -U --noconfirm ScoringEngine.pkg.tar.xz
systemctl enable scoring
systemctl enable score_web

# Setup NGINX reverse proxy
mv /tmp/nginx.conf /etc/nginx/nginx.conf

# Setup BlackArch repos
cd /tmp
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh ; ./strap.sh

pacman -S --needed --noconfirm blackarch-webapp blackarch-scanner blackarch-windows blackarch-networking blackarch-exploitation blackarch-database blackarch-scan

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
