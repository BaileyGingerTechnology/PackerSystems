#!/bin/bash

echo 'maas.gingertech.com' >/etc/hostname

# Updating to most recent packages. Will probably have at least one thing out of date by the time it's used
echo "Updating"
/usr/bin/sed -i 's/#\[/\[/g' /etc/pacman.conf
/usr/bin/sed -i 's/\[custom/#\[custom/g' /etc/pacman.conf
/usr/bin/sed -i 's/#Include = /Include = /g' /etc/pacman.conf
pacman -Syu --noconfirm

# Install but don't configure the packages that I want
pacman -S --needed --noconfirm mariadb postgresql vim cronie
# I plan to give the player a SQL file or two, probably one per database, and force them to figure out how to make it work
# PSQL isn't too bad, but MySQL/MariaDB can be painful on Arch, since the documentation is mostly but not completely correct

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
cd ~/
sudo mv dhcpcd.conf /etc/dhcpcd.conf
