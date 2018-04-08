#!/bin/bash

function workstation
{
  cd $LFS/sources
  mv /temp/wget-1.19.4.tar.gz .
  tar xvf wget-1.19.4.tar.gz
  cd wget-1.19.4

  ./configure --prefix=/usr      \
              --sysconfdir=/etc  \
              --with-ssl=openssl &&
  make
  make install

  cd $LFS/sources
  wget http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.6p1.tar.gz
  tar xvf openssh-7.6p1.tar.gz
  cd openssh-7.6p1

  install  -v -m700 -d /var/lib/sshd &&
  chown    -v root:sys /var/lib/sshd &&

  groupadd -g 50 sshd        &&
  useradd  -c 'sshd PrivSep' \
           -d /var/lib/sshd  \
           -g sshd           \
           -s /bin/false     \
           -u 50 sshd
  patch -Np1 -i ../openssh-7.6p1-openssl-1.1.0-1.patch &&

  ./configure --prefix=/usr                     \
              --sysconfdir=/etc/ssh             \
              --with-md5-passwords              \
              --with-privsep-path=/var/lib/sshd &&
  make
  make install &&
  install -v -m755    contrib/ssh-copy-id /usr/bin     &&
  install -v -m644    contrib/ssh-copy-id.1 \
                      /usr/share/man/man1              &&
  install -v -m755 -d /usr/share/doc/openssh-7.6p1     &&
  install -v -m644    INSTALL LICENCE OVERVIEW README* \
                      /usr/share/doc/openssh-7.6p1

  cd $LFS/sources
  wget http://anduin.linuxfromscratch.org/BLFS/blfs-bootscripts/blfs-bootscripts-20180105.tar.xz
  tar xvf blfs-bootscripts-20180105.tar.xz
  cd blfs-bootscripts-20180105
  make install-sshd

  cd $LFS/sources
  wget http://roy.marples.name/downloads/dhcpcd/dhcpcd-7.0.1.tar.xz
  tar xvf dhcpcd-7.0.1.tar.xz
  cd dhcpcd-7.0.1
  ./configure --libexecdir=/lib/dhcpcd \
              --dbdir=/var/lib/dhcpcd  &&
  make
  make install
  cd $LFS/sources/blfs-bootscripts-20180105
  make install-service-dhcpcd

  cd $LFS/sources
  wget http://www.sudo.ws/dist/sudo-1.8.22.tar.gz
  tar xvf sudo-1.8.22.tar.gz
  cd sudo-1.8.22
  ./configure --prefix=/usr              \
              --libexecdir=/usr/lib      \
              --with-secure-path         \
              --with-all-insults         \
              --with-env-editor          \
              --docdir=/usr/share/doc/sudo-1.8.22 \
              --with-passprompt="[sudo] password for %p: " &&
  make
  make install &&
  ln -sfv libsudo_util.so.0.0.0 /usr/lib/sudo/libsudo_util.so.0
  PASSWORD=$(openssl passwd -crypt 'password')
  useradd --password ${PASSWORD} --comment 'administrator User' --create-home --user-group administrator
  echo 'Defaults env_keep += \"SSH_AUTH_SOCK\"' > /etc/sudoers.d/10_administrator
  echo 'administrator ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/10_administrator
  chmod 0440 /etc/sudoers.d/10_administrator
}

workstation