#!/bin/bash

set -e
set -x

sudo tee -a /etc/ssh/sshd_config <<EOF

UseDNS no
EOF


sudo apt -y install gettext autoconf automake pkg-config libtool asciidoc fakeroot libcurl4-openssl-dev bsdcpio bsdtar libarchive-dev alien git

sudo mkdir /temp/
sudo chown -R administrator:administrator /temp
cd /temp
git clone https://github.com/BaileyGingerTechnology/pacman.git
cd pacman
./autogen.sh

export LIBARCHIVE_LIBS="-larchive"
export LIBCURL_CFLAGS="-I/usr/include/curl"
export LIBCURL_LIBS="-lcurl"
./configure --prefix=/ \
            --enable-doc \
            --with-curl

make
make -C contrib
sudo make install
sudo make -C contrib install

cd /temp
wget http://dl.fedoraproject.org/pub/fedora/linux/releases/27/Everything/x86_64/os/Packages/l/libalpm-5.0.2-3.fc27.x86_64.rpm
sudo alien -i libalpm-5.0.2-3.fc27.x86_64.rpm

COUNTRY=${COUNTRY:-US}
MIRRORLIST="https://www.archlinux.org/mirrorlist/?country=${COUNTRY}&protocol=http&protocol=https&ip_version=4&use_mirror_status=on"

echo "==> Setting local mirror"
sudo mkdir /etc/pacman.d
sudo bash -c "curl -s '$MIRRORLIST' |  sed 's/^#Server/Server/' > /etc/pacman.d/mirrorlist"
sudo mv /home/administrator/pacman.conf /etc/

sudo apt purge --yes --force-yes apt
sudo pacman -Syu --force
sudo pacman -S --needed --noconfirm --force base-devel git wget yajl

cd /temp
git clone https://aur.archlinux.org/package-query.git
cd package-query/
makepkg -si --noconfirm

cd /temp
git clone https://aur.archlinux.org/yaourt.git
cd yaourt
makepkg -si --noconfirm

cd /temp
sudo rm -dR yaourt/ package-query/

sudo yaourt -Syu