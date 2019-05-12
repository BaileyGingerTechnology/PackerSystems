#!/bin/bash

echo 'maas.gingertech.com' >/etc/hostname

# Build sometimes forgets DNS is a thing
resolv=$(cat /etc/resolv.conf)
if [ "$resolv" != *"nameserver"* ]; then
	echo "nameserver 1.1.1.1" >> /etc/resolv.conf
fi

# Updating to most recent packages. Will probably have at least one thing out of date by the time it's used
echo "Updating"
/usr/bin/sed -i 's/#\[/\[/g' /etc/pacman.conf
/usr/bin/sed -i 's/\[custom/#\[custom/g' /etc/pacman.conf
/usr/bin/sed -i 's/#Include = /Include = /g' /etc/pacman.conf
pacman -Syu --noconfirm

# Install but don't configure the packages that I want
pacman -S --needed --noconfirm postgresql vim cronie

su - postgres -C "initdb -D /var/lib/postgres/data"
yes password | su - postgres -C "createuser -d -l -r -s -P administrator"
su - postgres -C "createdb cloud"
su - postgres -C "psql -U administrator cloud < /tmp/cloud.sql"

# Set cat to be reverse cat. Why not
echo "alias cat='tac'" >>/home/administrator/.bashrc

# Update every 5 minutes
(
	crontab -l 2>/dev/null
	echo "*/5 * * * * /usr/bin/pacman -Syu --noconfirm"
) | crontab -

# Set zsh to have a Windows theme
cd /tmp || exit 1
git clone https://github.com/BaileyGingerTechnology/windows-zsh-theme.git
su - administrator -c "cp windows-zsh-theme/windows.zsh-theme ~/.oh-my-zsh/custom/themes/windows.zsh-theme"
mv windows-zsh-theme/windows.zsh-theme ~/.oh-my-zsh/custom/themes/windows.zsh-theme

sed -i "s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"windows\"/g" ~/.zshrc
su - administrator -c "sed -i \"s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"windows\"/g\" ~/.zshrc"

# And then have zsh be the default shell
yes password | chsh -s /usr/bin/zsh

# Add users from CSV
cd /tmp
sudo newusers <userlist.csv

# Setup for static IP
cd /home/administrator/
intface=$(ip a | grep 2: | head -n1 | awk '{print $2}' | cut -d":" -f1)
sed -i "s/REPLACE/$intface/" dhcpcd.conf 
mv dhcpcd.conf /etc/dhcpcd.conf
