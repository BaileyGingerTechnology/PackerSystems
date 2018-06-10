#!/bin/bash
# Author: Bailey Kasin

apt install -y zsh golang-go nginx python
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

systemctl enable nginx

# Install NPM and Node
ARCH=$(uname -m)
sleep 5
echo "[+] Changing to /tmp"
cd /tmp

# libv8 package
echo "[+] Downloading libv8 package..."
wget http://ftp.us.debian.org/debian/pool/main/libv/libv8-3.14/libv8-3.14.5_3.14.5.8-8~bpo70+1_${architecture}.deb

sleep 3

# nodejs package
echo "[+] Downloading nodejs package..."
wget http://ftp.tku.edu.tw/Linux/Kali/kali/pool/main/n/nodejs/nodejs_0.10.29~dfsg-1~bpo70+1_${architecture}.deb

sleep 3

# install nodejs / dependency
echo "[+] Installing NodeJS"
dpkg -i libv8*
dpkg -i nodejs_0.10.29~dfsg-1~bpo70+1_${architecture}.deb
ln /usr/bin/nodejs /usr/bin/node

echo "[+] Testing NodeJS version"
node -v

sleep 3

# install npm (you will get error but it works okay)
echo "[+] Installing NPM"
curl https://www.npmjs.org/install.sh | sudo sh

# clean up
echo "[+] Removing temporary files"
rm -rf /tmp/*