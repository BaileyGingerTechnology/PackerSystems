#!/bin/bash

set -e
set -x

sudo tee -a /etc/ssh/sshd_config <<EOF

UseDNS no
EOF

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

sudo mkdir /temp/
sudo chown -R administrator:administrator /temp
cd /temp
mkdir debian
#sudo apt-get -y install netselect-apt
#sudo netselect-apt -n jessie && sudo mv sources.list /etc/apt/sources.list

sudo apt update
sudo apt -y install gettext autoconf automake pkg-config libtool asciidoc fakeroot libcurl4-openssl-dev bsdcpio bsdtar libarchive-dev alien git parted

sudo apt -y install xfce4 xfce4-goodies task-xfce-desktop
#echo "exec ck-launch-session startxfce4" >> ~/.xinitrc

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
#wget http://dl.fedoraproject.org/pub/fedora/linux/releases/27/Everything/x86_64/os/Packages/l/libalpm-5.0.2-3.fc27.x86_64.rpm
#sudo alien -i libalpm-5.0.2-3.fc27.x86_64.rpm
sudo pacman-db-upgrade

echo "==> Setting local mirror"
sudo mkdir /etc/pacman.d
sudo bash -c "curl -s '$MIRRORLIST' |  sed 's/^#Server/Server/' > /etc/pacman.d/mirrorlist"
sudo cp /home/administrator/pacman.conf /etc/
sudo cp /home/administrator/pacman.conf /usr/local/etc/

#sudo umount /dev/sda3
sudo parted -a optimal ${DISK} print
#sudo mkdir -pv /mnt/arch
sudo mkdir -pv /mnt/arch/boot
#sudo mount -v -t ext4 ${DISK}3 /mnt/arch

sudo pacman -Sy
mv /home/administrator/debianPKGBUILD /temp/debian/PKGBUILD
cd /temp/debian && makepkg -si --noconfirm
sudo pacman -S --noconfirm arch-install-scripts
sudo pacstrap /mnt/arch base base-devel
#sudo mv /home/administrator/pacman.conf /mnt/arch/etc/
sudo arch-chroot ${TARGET_DIR} pacman-db-upgrade
sudo arch-chroot ${TARGET_DIR} pacman -Sy
#sudo arch-chroot ${TARGET_DIR} pacman -S --noconfirm gptfdisk openssh syslinux
#sudo arch-chroot ${TARGET_DIR} syslinux-install_update -i -a -m
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
	/usr/bin/sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
	/usr/bin/systemctl enable sshd.service

	# Admin user config
	/usr/bin/useradd --password ${PASSWORD} --comment 'administrator User' --create-home --user-group administrator
	echo 'Defaults env_keep += "SSH_AUTH_SOCK"' > /etc/sudoers.d/10_administrator
	echo 'administrator ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/10_administrator
	/usr/bin/chmod 0440 /etc/sudoers.d/10_administrator
	/usr/bin/install --directory --owner=administrator --group=administrator --mode=0700 /home/administrator/.ssh
	/usr/bin/chown administrator:administrator /home/administrator/.ssh/authorized_keys
	/usr/bin/chmod 0600 /home/administrator/.ssh/authorized_keys

	# clean up
	#/usr/bin/pacman -Rcns --noconfirm gptfdisk
EOF

sudo mv /temp/arch-config.sh ${TARGET_DIR}${CONFIG_SCRIPT}
echo '==> Entering chroot and configuring system'
sudo chmod +x ${TARGET_DIR}${CONFIG_SCRIPT}
sudo bash -c "arch-chroot ${TARGET_DIR} ${CONFIG_SCRIPT}"
sudo rm "${TARGET_DIR}${CONFIG_SCRIPT}"

cat << EOF > "/temp/finish.sh"
  sudo pacman -Sy --force
  makepkg -si --noconfirm
  sudo pacman -S --needed --noconfirm --force base-devel git wget yajl

  sudo mkdir /temp && sudo chown administrator -R /temp

  cd /temp
  git clone https://aur.archlinux.org/package-query.git
  cd package-query/
  makepkg -si --noconfirm

  cd /temp
  git clone https://aur.archlinux.org/yaourt.git
  cd yaourt
  makepkg -si --noconfirm

  yaourt -Syu --noconfirm

  sudo rm -rf /temp
EOF

sudo mv /temp/finish.sh /mnt/arch/finish.sh

sudo chroot "/mnt/arch" /mnt/arch/bin/env -i \
    HOME=/home/administrator            \
    PS1='(arch chroot) \u:\w\$ '        \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin  \
    /bin/bash --login +h          \
    ./finish.sh