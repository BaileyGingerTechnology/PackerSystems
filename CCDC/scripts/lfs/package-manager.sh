#!/bin/bash
# Author: Bailey Kasin

set -eu
set -x
set +h

umask 022
LFS=/
echo $LFS
LC_ALL=POSIX
echo $LC_ALL
LFS_TGT=$(uname -m)-gt-linux-gnu
echo "On $LFS_TGT"
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin:/usr/bin/core_perl
echo $PATH

echo "Building RPM"

function build_ssh
{
  # OpenSSH Server to connect post-reboot
  cd $LFS/sources
  tar xvf openssh-7.6p1.tar.gz
  cd openssh-7.6p1

  install  -v -m700 -d /var/lib/sshd &&
  chown    -v root:sys /var/lib/sshd &&

  groupadd -g 75 sshd
  useradd  -c 'sshd PrivSep' \
           -d /var/lib/sshd  \
           -g sshd           \
           -s /bin/false     \
           -u 75 sshd
  patch -Np1 -i ../openssh-7.6p1-openssl-1.1.0-1.patch

  ./configure --prefix=/usr                     \
              --sysconfdir=/etc/ssh             \
              --with-md5-passwords              \
              --with-privsep-path=/var/lib/sshd
  make -j${CPUS}
  make install
  install -v -m755    contrib/ssh-copy-id /usr/bin
  install -v -m644    contrib/ssh-copy-id.1 \
                      /usr/share/man/man1
  install -v -m755 -d /usr/share/doc/openssh-7.6p1
  install -v -m644    INSTALL LICENCE OVERVIEW README* \
                      /usr/share/doc/openssh-7.6p1

  cd $LFS/sources
  tar xvf blfs-bootscripts-20180105.tar.xz
  cd $LFS/sources/blfs-bootscripts-20180105
  make install-sshd
}

function build_berkeley
{
  cd $LFS/sources
  tar xvf db-6.2.32.tar.gz
  cd db-6.2.32

  cd build_unix                         &&
  ../dist/configure --prefix=/usr       \
                    --enable-compat185  \
                    --enable-dbm        \
                    --disable-static    \
                    --enable-cxx        &&
  make -j${CPUS}
  make docdir=/usr/share/doc/db-6.2.32 install &&

  chown -v -R root:root                 \
        /usr/bin/db_*                   \
        /usr/include/db{,_185,_cxx}.h   \
        /usr/lib/libdb*.{so,la}         \
        /usr/share/doc/db-6.2.32
}

function build_nettools
{
  cd $LFS/sources
  tar xvf net-tools-CVS_20101030.tar.gz
  cd net-tools-CVS_20101030

  patch -Np1 -i ../net-tools-CVS_20101030-remove_dups-1.patch &&
  sed -i '/#include <netinet\/ip.h>/d' iptunnel.c &&

  yes "" | make config &&
  make -j${CPUS}
  make update
}

function build_gnupg
{
  cd $LFS/sources
  tar xvf libgpg-error-1.27.tar.bz2
  cd libgpg-error-1.27
  ./configure --prefix=/usr &&
  make -j${CPUS}
  make install &&
  install -v -m644 -D README /usr/share/doc/libgpg-error-1.27/README

  cd $LFS/sources
  tar xvf libassuan-2.5.1.tar.bz2
  cd libassuan-2.5.1
  ./configure --prefix=/usr &&
  make -j${CPUS}
  make install

  cd $LFS/sources
  tar xvf libgcrypt-1.8.2.tar.bz2
  cd libgcrypt-1.8.2
  ./configure --prefix=/usr &&
  make -j${CPUS}
  make install &&
  install -v -dm755 /usr/share/doc/libgcrypt-1.8.2 &&
  install -v -m644 README doc/{README.apichanges,fips*,libgcrypt*} \
                  /usr/share/doc/libgcrypt-1.8.2
  
  cd $LFS/sources
  tar xvf libksba-1.3.5.tar.bz2
  cd libksba-1.3.5
  ./configure --prefix=/usr &&
  make -j${CPUS}
  make install

  cd $LFS/sources
  tar xvf npth-1.5.tar.bz2
  cd npth-1.5
  ./configure --prefix=/usr &&
  make -j${CPUS}
  make install

  cd $LFS/sources
  tar xvf gnupg-2.2.4.tar.bz2
  cd gnupg-2.2.4
  sed -e '/noinst_SCRIPTS = gpg-zip/c sbin_SCRIPTS += gpg-zip' \
      -i tools/Makefile.in
  ./configure --prefix=/usr             \
              --enable-symcryptrun      \
              --enable-maintainer-mode  \
              --docdir=/usr/share/doc/gnupg-2.2.4 &&
  make -j${CPUS} &&
  makeinfo --html --no-split \
            -o doc/gnupg_nochunks.html  doc/gnupg.texi &&
  makeinfo --plaintext       \
            -o doc/gnupg.txt            doc/gnupg.texi
  make install &&
  install -v -m755 -d /usr/share/doc/gnupg-2.2.4/html             &&
  install -v -m644    doc/gnupg_nochunks.html \
                      /usr/share/doc/gnupg-2.2.4/html/gnupg.html  &&
  install -v -m644    doc/*.texi doc/gnupg.txt \
                      /usr/share/doc/gnupg-2.2.4
}

function build_pinentry
{
  cd $LFS/sources
  tar xvf pinentry-1.1.0.tar.bz2
  cd pinentry-1.1.0
  
  ./configure --prefix=/usr --enable-pinentry-tty &&
  make -j${CPUS}
  make install
}

function build_libxml2
{
  cd $LFS/sources
  tar xvf libxml2-2.9.7.tar.gz
  cd libxml2-2.9.7

  patch -Np1 -i ../libxml2-2.9.7-python3_hack-1.patch
  sed -i '/_PyVerify_fd/,+1d' python/types.c

  ./configure --prefix=/usr       \
              --disable-static    \
              --with-history      \
              --with-python=/usr/bin/python3 &&
  make -j${CPUS}
  make install
}

build_berkeley
build_nettools
build_gnupg
build_pinentry
build_libxml2

function build_popt
{
  cd $LFS/sources
  tar xvf popt-1.16.tar.gz
  cd popt-1.16

  ./configure --prefix=/usr --disable-static &&
  make -j${CPUS}
  make install
}

function build_libarchive
{
  cd $LFS/sources
  tar xvf libarchive-3.3.2.tar.gz
  cd libarchive-3.3.2

  ./configure --prefix=/usr --disable-static &&
  make -j${CPUS}
  make install
}

function build_neon
{
  cd $LFS/sources
  tar xvf neon-0.25.5.tar.gz
  cd neon-0.25.5

  ./configure --prefix=/usr --enable-shared &&
  make -j${CPUS} &&
  make install
}

build_popt
build_libarchive
build_neon

function build_rpm
{
  cd $LFS/sources
  tar xvf rpm-4.14.1.tar.bz2
  cd rpm-4.14.1
  
  ./configure --prefix=/usr           \
              --enable-posixmutexes   \
              --with-crypto=openssl   \
			        --without-selinux       \
        	    --without-python        \
              --without-lua           \
      	      --without-javaglue &&
  make -j${CPUS} &&
  make install
  
  rpm --initdb --root=/usr/var/lib/rpm
  cd $LFS
  mkdir /root/rpmbuild
  mkdir /root/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
  $LFS/vpkg-provides.sh --spec_header $LFS/system.spec >> /root/rpmbuild/SPECS/system.spec
  sleep 30
  rpm --version

  cd /root/rpmbuild/SPECS
  sed -i '/Provides:\ 0/d' system.spec
  sed -i '/Provides:\ 1/d' system.spec
  sed -i '/Provides:\ 2/d' system.spec
  sed -i '/Provides:\ 3/d' system.spec
  sed -i '/Provides:\ 4/d' system.spec
  sed -i '/Provides:\ 5/d' system.spec
  sed -i '/Provides:\ 6/d' system.spec
  sed -i '/Provides:\ 7/d' system.spec
  sed -i '/Provides:\ 8/d' system.spec
  sed -i '/Provides:\ 9/d' system.spec
  sed -i '/Provides:\ =/d' system.spec
  rpmbuild -bb system.spec
  cd ../RPMS/x86_64
  rpm -ivh *.rpm
}

build_ssh
build_rpm
#cd $LFS/sources
#rpm -i -vv openssh-5.3p1-122.el6.x86_64.rpm
#cd $LFS/sources/blfs-bootscripts-20180105
#make install-sshd
