#!/bin/bash

set -e
set -x

sudo tee -a /etc/ssh/sshd_config <<EOF

UseDNS no
EOF

sudo bash -c "echo 'blake.gingertech.com' > /etc/hostname"
sudo hostname blake.gingertech.com

CONFIG_SCRIPT='/usr/local/bin/arch-config.sh'
TARGET_DIR='/mnt/arch'
PASSWORD=$(/usr/bin/openssl passwd -crypt 'password')
KEYMAP='us'
LANGUAGE='en_US.UTF-8'
TIMEZONE='UTC'

COUNTRY=${COUNTRY:-US}
MIRRORLIST="https://www.archlinux.org/mirrorlist/?country=${COUNTRY}&protocol=http&protocol=https&ip_version=4&use_mirror_status=on"
if [[ $PACKER_BUILDER_TYPE == "qemu" ]]; then
    DISK='/dev/vda'
else
    DISK='/dev/sda'
fi

sudo apt -y install gettext autoconf automake pkg-config libtool asciidoc fakeroot \
libcurl4-openssl-dev bsdcpio bsdtar libarchive-dev alien git parted vim apt-transport-https

sudo apt -y install xfce4 xfce4-goodies task-xfce-desktop

# To make it look like an actual workstation
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update
sudo apt-get install code

sudo mkdir /temp/
sudo chown -R administrator:administrator /temp
cd /temp
mkdir debian

sudo bash -c "echo 'GRUB_BACKGROUND=\"/home/administrator/Pictures/tuna.png\"' >> /etc/default/grub"
sudo update-grub

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

echo "==> Setting local mirror"
sudo mkdir /etc/pacman.d
sudo bash -c "curl -s '$MIRRORLIST' |  sed 's/^#Server/Server/' > /etc/pacman.d/mirrorlist"
sudo cp /home/administrator/pacman.conf /etc/
sudo cp /home/administrator/pacman.conf /usr/local/etc/

sudo parted -a optimal ${DISK} print
sudo mkdir -v /mnt/arch/boot

sudo pacman -Sy
mv /home/administrator/debianPKGBUILD /temp/debian/PKGBUILD
cd /temp/debian && makepkg -si --noconfirm
rm PKGBUILD
mv /home/administrator/installScriptsPKGBUILD /temp/debian/PKGBUILD
makepkg -si --noconfirm
sudo pacstrap /mnt/arch base base-devel

sudo arch-chroot ${TARGET_DIR} pacman --version
sudo arch-chroot ${TARGET_DIR} pacman-key --init
sudo arch-chroot ${TARGET_DIR} mkdir /root/.gnupg && touch /root/.gnupg/dirmngr_ldapservers.conf
sudo arch-chroot ${TARGET_DIR} sed -i 's/Required DatabaseOptional/Never/g' /etc/pacman.conf
sudo arch-chroot ${TARGET_DIR} pacman -S --noconfirm archlinux-keyring
sudo arch-chroot ${TARGET_DIR} sed -i 's/Never/Required DatabaseOptional/g' /etc/pacman.conf
sudo bash -c "genfstab -U /mnt/arch >> /mnt/arch/etc/fstab"

echo '==> Generating the system configuration script'
sudo /usr/bin/install --mode=0755 /dev/null "${TARGET_DIR}${CONFIG_SCRIPT}"

cat <<-EOF >"/temp/arch-config.sh"
	set -e
	set -x

	echo 'blake.gingertech.com' > /etc/hostname
	/usr/bin/ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
	echo 'KEYMAP=${KEYMAP}' > /etc/vconsole.conf
	/usr/bin/sed -i 's/#${LANGUAGE}/${LANGUAGE}/' /etc/locale.gen
	/usr/bin/locale-gen
	/usr/bin/mkinitcpio -p linux
	/usr/bin/usermod --password ${PASSWORD} root
	# https://wiki.archlinux.org/index.php/Network_Configuration#Device_names
	/usr/bin/ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
	/usr/bin/ln -s '/usr/lib/systemd/system/dhcpcd@.service' '/etc/systemd/system/multi-user.target.wants/dhcpcd@eth0.service'

	# Admin user config
	/usr/bin/useradd --password ${PASSWORD} --comment 'administrator User' --create-home --user-group administrator
	echo 'administrator ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/10_administrator
	/usr/bin/chmod 0440 /etc/sudoers.d/10_administrator

	/usr/bin/sed -i 's/#\[/\[/g' /etc/pacman.conf
	/usr/bin/sed -i 's/\[custom/#\[custom/g' /etc/pacman.conf
	/usr/bin/sed -i 's/#Include = /Include = /g' /etc/pacman.conf
EOF

sudo mv /temp/arch-config.sh ${TARGET_DIR}${CONFIG_SCRIPT}
echo '==> Entering chroot and configuring system'
sudo chmod +x ${TARGET_DIR}${CONFIG_SCRIPT}
sudo bash -c "arch-chroot ${TARGET_DIR} ${CONFIG_SCRIPT}"
sudo rm "${TARGET_DIR}${CONFIG_SCRIPT}"

cat <<EOF >"/temp/finish.sh"
	set -e
	set -x

  pacman -Syu --noconfirm
  pacman -S --needed --noconfirm base-devel git wget yajl curl openssl fish
	update-ca-trust
	git config --system http.sslverify false

  mkdir /temp && chmod 777 -R /temp && chown administrator -R /temp

  cd /temp
  sudo -H -u administrator git clone https://aur.archlinux.org/package-query.git
  cd package-query/
  sudo -H -u administrator makepkg -si --noconfirm

  cd /temp
  sudo -H -u administrator git clone https://aur.archlinux.org/yaourt.git
  cd yaourt
  sudo -H -u administrator makepkg -si --noconfirm

  sudo -H -u administrator yaourt -Syu --noconfirm

	echo 'blake.gingertech.com' > /etc/hostname

	echo "/usr/bin/fish" >>/etc/shells

	yes password | passwd
	yes password | chsh -s /usr/bin/fish
	yes password | sudo -H -u administrator chsh -s /usr/bin/fish

  rm -rf /temp
	rm /finish.sh
EOF

sudo mv /temp/finish.sh /mnt/arch/finish.sh
sudo chmod -v +x /mnt/arch/finish.sh

sudo bash -c "arch-chroot ${TARGET_DIR} ./finish.sh"
echo "sudo arch-chroot ${TARGET_DIR} && exit" >>~/.bashrc
sudo bash -c "echo \"arch-chroot ${TARGET_DIR} && exit\" >> /root/.bashrc"

echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/2/Debian_8.0/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:2.list
sudo apt-get update
sudo apt-get install -y fish

echo "sudo arch-chroot ${TARGET_DIR} && exit" >>~/.config/fish/config.fish
sudo bash -c "echo \"arch-chroot ${TARGET_DIR} && exit\" >>/root/.config/fish/config.fish
