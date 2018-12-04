#!/bin/bash
# Author: Bailey Kasin

echo 'arditi.gingertech.com' >/etc/hostname

export DEBIAN_FRONTEND=noninteractive

apt install -y zsh golang-go nginx python
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

systemctl enable nginx
systemctl enable open-vm-tools

cd /tmp || exit 1
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
wget -q https://packages.microsoft.com/config/debian/9/prod.list
mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
chown root:root /etc/apt/sources.list.d/microsoft-prod.list

wget http://ftp.us.debian.org/debian/pool/main/i/icu/libicu57_57.1-6+deb9u2_amd64.deb
dpkg -i libicu57_57.1-6+deb9u2_amd64.deb

apt update
yes | apt autoremove
apt install -y dotnet-sdk-2.1

cd /tmp || exit 1
dpkg -i ScoringEngine.deb

echo "Setting static IP file"
mv /tmp/interfaces /etc/network/interfaces

echo "[+] Removing temporary files"
rm -rf /tmp/*
