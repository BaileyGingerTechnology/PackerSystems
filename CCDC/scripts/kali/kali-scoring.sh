#!/bin/bash
# Author: Bailey Kasin

echo 'ward.gingertech.com' >/etc/hostname

apt install -y zsh golang-go nginx python
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

systemctl enable nginx

cd /tmp || exit 1
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.asc.gpg
mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
wget -q https://packages.microsoft.com/config/debian/9/prod.list
mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
chown root:root /etc/apt/sources.list.d/microsoft-prod.list

apt update && apt install -y dotnet-sdk-2.1 aspnetcore-runtime-2.1

echo "[+] Removing temporary files"
rm -rf /tmp/*
