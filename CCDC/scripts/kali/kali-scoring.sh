#!/bin/bash
# Author: Bailey Kasin

echo 'arditi.gingertech.com' >/etc/hostname

# Apt updates can cause builds to hang when requesting input
export DEBIAN_FRONTEND=noninteractive

# Packages that will be needed throughout the build and after
apt install -y zsh golang-go nginx python git

# This part is just for me really, I like ohmyzsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Enable NGINX for the reverse proxy, and diable Apache2 to avoid port 80 conflicts
systemctl disable apache2
systemctl enable nginx

# Install dotnet, since it is a dependency of ScoringEngine
cd /tmp || exit 1
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
wget -q https://packages.microsoft.com/config/debian/9/prod.list
mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
chown root:root /etc/apt/sources.list.d/microsoft-prod.list

# This libicu versin is the one required by dotnet 2.1
wget http://ftp.us.debian.org/debian/pool/main/i/icu/libicu57_57.1-6+deb9u2_amd64.deb
dpkg -i libicu57_57.1-6+deb9u2_amd64.deb

# The actual dotnet install part
apt update
yes | apt autoremove
apt install -y dotnet-sdk-2.1

# And now install ScoringEngine and enable it's services
cd /tmp || exit 1
dpkg -i ScoringEngine.deb
systemctl enable scoring
systemctl enable score_web

# Setup NGINX reverse proxy
unlink /etc/nginx/sites-enabled/default

echo "Setting static IP file"
mv /tmp/interfaces /etc/network/interfaces

echo "[+] Removing temporary files"
rm -rf /tmp/*
