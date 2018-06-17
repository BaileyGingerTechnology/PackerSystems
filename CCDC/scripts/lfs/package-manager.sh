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

echo "Building DPKG"

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

# RPM deps that I'm not sure are needed by DPKG
build_popt
build_libarchive
build_neon

function dpkg_deps
{
  cd $LFS/sources
  tar xvf make-ca-0.7.tar.gz
  cd make-ca-0.7

  install -vdm755 /etc/ssl/local &&
  wget http://www.cacert.org/certs/root.crt &&
  wget http://www.cacert.org/certs/class3.crt &&
  openssl x509 -in root.crt -text -fingerprint -setalias "CAcert Class 1 root" \
          -addtrust serverAuth -addtrust emailProtection -addtrust codeSigning \
          > /etc/ssl/local/CAcert_Class_1_root.pem &&
  openssl x509 -in class3.crt -text -fingerprint -setalias "CAcert Class 3 root" \
          -addtrust serverAuth -addtrust emailProtection -addtrust codeSigning \
          > /etc/ssl/local/CAcert_Class_3_root.pem
  make install
  /usr/sbin/make-ca -g

  cd $LFS/sources
  tar xvf curl-7.58.0.tar.xz
  cd curl-7.58.0

  ./configure --prefix=/usr                           \
              --disable-static                        \
              --enable-threaded-resolver              \
              --with-ca-path=/etc/ssl/certs &&
  make -j${CPUS}
  make install &&
  rm -rf docs/examples/.deps &&
  find docs \( -name Makefile\* -o -name \*.1 -o -name \*.3 \) -exec rm {} \; &&
  install -v -d -m755 /usr/share/doc/curl-7.58.0 &&
  cp -v -R docs/*     /usr/share/doc/curl-7.58.0

  cd $LFS/sources
  tar xvf  Error-0.17025.tar.gz
  cd Error-0.17025

  perl Makefile.PL &&
  make &&
  make install

  cd $LFS/sources
  tar xvf Python-2.7.14.tar.xz
  cd Python-2.7.14

  sed -i '/#SSL/,+3 s/^#//' Modules/Setup.dist
  ./configure --prefix=/usr       \
              --enable-shared     \
              --with-system-expat \
              --with-system-ffi   \
              --with-ensurepip=yes \
              --enable-unicode=ucs4 &&
  make -j${CPUS}
  make install &&
  chmod -v 755 /usr/lib/libpython2.7.so.1.0

  cd $LFS/sources
  tar xvf git-2.16.2.tar.xz
  cd git-2.16.2

  ./configure --prefix=/usr --with-gitconfig=/etc/gitconfig &&
  make -j${CPUS}
  make install
}

function build_libmd
{
  cd $LFS/sources
  tar xvf libmd-1.0.0.tar.xz
  cd libmd-1.0.0

  ./autogen
  ./configure --prefix=/usr
  make -j${CPUS}
  make install
}

function build_dpkg
{
  cd $LFS/sources
  tar xvf dpkg.tar.gz
  cd dpkg

  ./autogen
  ./configure --prefix=/usr
  make -j${CPUS}
  make install
}

dpkg_deps
build_libmd
build_dpkg
cd $LFS/sources

dpkg -i gpgv_2.1.18-8~deb9u2_amd64.deb
dpkg -i debian-archive-keyring_2017.5_all.deb
dpkg -i init-system-helpers_1.48_all.deb
dpkg -i libapt-pkg5.0_1.4.8_amd64.deb
dpkg -i apt_1.4.8_amd64.deb
