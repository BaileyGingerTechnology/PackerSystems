#!/bin/bash

set -e
set -x

sudo tee -a /etc/ssh/sshd_config <<EOF

UseDNS no
EOF

sudo cp /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

CONFIG_SCRIPT='/usr/local/bin/arch-config.sh'
TARGET_DIR='/mnt/arch'
PASSWORD=$(/usr/bin/openssl passwd -crypt 'password')

COUNTRY=${COUNTRY:-US}
MIRRORLIST="https://www.archlinux.org/mirrorlist/?country=${COUNTRY}&protocol=http&protocol=https&ip_version=4&use_mirror_status=on"
if [[ $PACKER_BUILDER_TYPE == "qemu" ]]; then
	DISK='/dev/vda'
else
	DISK='/dev/sda'
fi

sudo apt -y install gettext autoconf automake pkg-config libtool asciidoc fakeroot libcurl4-openssl-dev bsdcpio bsdtar libarchive-dev alien git parted

sudo apt -y install xfce4 xfce4-goodies task-xfce-desktop

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
./configure --prefix=/   \
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
sudo pacman -S --noconfirm arch-install-scripts
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

cat <<-EOF > "/temp/arch-config.sh"
	echo 'tuna.gingertech.com' > /etc/hostname
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
EOF

sudo mv /temp/arch-config.sh ${TARGET_DIR}${CONFIG_SCRIPT}
echo '==> Entering chroot and configuring system'
sudo chmod +x ${TARGET_DIR}${CONFIG_SCRIPT}
sudo bash -c "arch-chroot ${TARGET_DIR} ${CONFIG_SCRIPT}"
sudo rm "${TARGET_DIR}${CONFIG_SCRIPT}"

cat << EOF > "/temp/finish.sh"
  pacman -Syu --noconfirm
  pacman -S --needed --noconfirm base-devel git wget yajl curl openssl
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

  rm -rf /temp
	rm /finish.sh 
EOF

sudo mv /temp/finish.sh /mnt/arch/finish.sh
sudo chmod -v +x /mnt/arch/finish.sh

sudo bash -c "arch-chroot ${TARGET_DIR} ./finish.sh"
sudo bash -c "echo \"\narch-chroot ${TARGET_DIR}\" >> /etc/profile"