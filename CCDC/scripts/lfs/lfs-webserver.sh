#!/bin/bash

umask 022
LFS=/
echo $LFS
LC_ALL=POSIX
echo $LC_ALL
LFS_TGT=$(uname -m)-gt-linux-gnu
echo "On $LFS_TGT"

echo "We made it. Now for finishing touches."

echo "white" >/etc/hostname

echo "Install Apache webserver and it's dependencies"

# Start Berkeley DB

cd $LFS/sources || exit 1
tar xvf db-6.2.32.tar.gz
cd db-6.2.32 || exit 1

cd build_unix || exit 1
../dist/configure --prefix=/usr \
	--enable-compat185 \
	--enable-dbm \
	--disable-static \
	--enable-cxx
make -j${CPUS}
make docdir=/usr/share/doc/db-6.2.32 install
chown -v -R root:root \
	/usr/bin/db_* \
	/usr/include/db{,_185,_cxx}.h \
	/usr/lib/libdb*.{so,la} \
	/usr/share/doc/db-6.2.32

# End Berkeley

# Start Net Tools

cd $LFS/sources || exit 1
tar xvf net-tools-CVS_20101030.tar.gz
cd net-tools-CVS_20101030 || exit 1

patch -Np1 -i ../net-tools-CVS_20101030-remove_dups-1.patch
sed -i '/#include <netinet\/ip.h>/d' iptunnel.c
yes "" | make config
make -j${CPUS}
make update

# End Net Tools

# Start GNUPG and Deps

cd $LFS/sources || exit 1
tar xvf libgpg-error-1.27.tar.bz2
cd libgpg-error-1.27 || exit 1
./configure --prefix=/usr
make -j${CPUS}
make install
install -v -m644 -D README /usr/share/doc/libgpg-error-1.27/README

cd $LFS/sources || exit 1
tar xvf libassuan-2.5.1.tar.bz2
cd libassuan-2.5.1 || exit 1
./configure --prefix=/usr
make -j${CPUS}
make install

cd $LFS/sources || exit 1
tar xvf libgcrypt-1.8.2.tar.bz2
cd libgcrypt-1.8.2 || exit 1
./configure --prefix=/usr
make -j${CPUS}
make install
install -v -dm755 /usr/share/doc/libgcrypt-1.8.2
install -v -m644 README doc/{README.apichanges,fips*,libgcrypt*} \
	/usr/share/doc/libgcrypt-1.8.2

cd $LFS/sources || exit 1
tar xvf libksba-1.3.5.tar.bz2
cd libksba-1.3.5 || exit 1
./configure --prefix=/usr
make -j${CPUS}
make install

cd $LFS/sources || exit 1
tar xvf npth-1.5.tar.bz2
cd npth-1.5 || exit 1
./configure --prefix=/usr
make -j${CPUS}
make install

cd $LFS/sources || exit 1
tar xvf gnupg-2.2.4.tar.bz2
cd gnupg-2.2.4 || exit 1
sed -e '/noinst_SCRIPTS = gpg-zip/c sbin_SCRIPTS += gpg-zip' \
	-i tools/Makefile.in
./configure --prefix=/usr \
	--enable-symcryptrun \
	--enable-maintainer-mode \
	--docdir=/usr/share/doc/gnupg-2.2.4
make -j${CPUS}
makeinfo --html --no-split \
	-o doc/gnupg_nochunks.html doc/gnupg.texi
makeinfo --plaintext \
	-o doc/gnupg.txt doc/gnupg.texi
make install
install -v -m755 -d /usr/share/doc/gnupg-2.2.4/html
install -v -m644 doc/gnupg_nochunks.html \
	/usr/share/doc/gnupg-2.2.4/html/gnupg.html
install -v -m644 doc/*.texi doc/gnupg.txt \
	/usr/share/doc/gnupg-2.2.4

# End GNUPG

# Start Pinentry

cd $LFS/sources || exit 1
tar xvf pinentry-1.1.0.tar.bz2
cd pinentry-1.1.0 || exit 1

./configure --prefix=/usr --enable-pinentry-tty
make -j${CPUS}
make install

# End Pinentry

# Start LibXML

cd $LFS/sources || exit 1
tar xvf libxml2-2.9.7.tar.gz
cd libxml2-2.9.7 || exit 1

patch -Np1 -i ../libxml2-2.9.7-python3_hack-1.patch
sed -i '/_PyVerify_fd/,+1d' python/types.c

./configure --prefix=/usr \
	--disable-static \
	--with-history \
	--with-python=/usr/bin/python3
make -j${CPUS}
make install

# End LibXML

# Start Popt

cd $LFS/sources || exit 1
tar xvf popt-1.16.tar.gz
cd popt-1.16 || exit 1

./configure --prefix=/usr --disable-static
make -j${CPUS}
make install

# End Popt

# Start libarchive

cd $LFS/sources || exit 1
tar xvf libarchive-3.3.2.tar.gz
cd libarchive-3.3.2 || exit 1

./configure --prefix=/usr --disable-static
make -j${CPUS}
make install

# End libarchive

# Start Neon

cd $LFS/sources || exit 1
tar xvf neon-0.25.5.tar.gz
cd neon-0.25.5 || exit 1

./configure --prefix=/usr --enable-shared
make -j${CPUS}
make install

# End Neon

# Start APR

cd $LFS/sources || exit 1
tar xvf apr-1.6.3.tar.bz2
cd apr-1.6.3 || exit 1

./configure --prefix=/usr \
	--disable-static \
	--with-installbuilddir=/usr/share/apr-1/build
make -j${CPUS}
make install

# End APR

# Start APR-Util

cd $LFS/sources || exit 1
tar xvf apr-util-1.6.1.tar.bz2
cd apr-util-1.6.1 || exit 1

./configure --prefix=/usr \
	--with-apr=/usr \
	--with-gdbm=/usr \
	--with-openssl=/usr \
	--with-crypto
make -j${CPUS}
make install

# End APR-Util

# Start PCRE

cd $LFS/sources || exit 1
tar xvf pcre-8.42.tar.bz2
cd pcre-8.42 || exit 1

./configure --prefix=/usr \
	--docdir=/usr/share/doc/pcre-8.41 \
	--enable-unicode-properties \
	--enable-jit \
	--enable-pcre16 \
	--enable-pcre32 \
	--enable-pcregrep-libz \
	--enable-pcregrep-libbz2 \
	--enable-pcretest-libreadline \
	--disable-stat
make -j${CPUS}
make install
mv -v /usr/lib/libpcre.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libpcre.so) /usr/lib/libpcre.so

# End PCRE

# Start make-ca

cd $LFS/sources || exit 1
tar xvf make-ca-0.7.tar.gz
sleep 2
cd make-ca-0.7 || exit 1

install -vdm755 /etc/ssl/local

openssl x509 -in root.crt -text -fingerprint -setalias "CAcert Class 1 root" \
	-addtrust serverAuth -addtrust emailProtection -addtrust codeSigning \
	>/etc/ssl/local/CAcert_Class_1_root.pem
openssl x509 -in class3.crt -text -fingerprint -setalias "CAcert Class 3 root" \
	-addtrust serverAuth -addtrust emailProtection -addtrust codeSigning \
	>/etc/ssl/local/CAcert_Class_3_root.pem
make install
/usr/sbin/make-ca -g

# End make-ca

# Start Curl

cd $LFS/sources || exit 1
tar xvf curl-7.58.0.tar.xz
cd curl-7.58.0 || exit 1

./configure --prefix=/usr \
	--disable-static \
	--enable-threaded-resolver \
	--with-ca-path=/etc/ssl/certs
make -j${CPUS}
make install
rm -rf docs/examples/.deps
find docs \( -name Makefile\* -o -name \*.1 -o -name \*.3 \) -exec rm {} \;
install -v -d -m755 /usr/share/doc/curl-7.58.0
cp -v -R docs/* /usr/share/doc/curl-7.58.0

# End Curl

# Start Python27

cd $LFS/sources || exit 1
tar xvf Python-2.7.15.tar.xz
cd Python-2.7.15 || exit 1

sed -i '/#SSL/,+3 s/^#//' Modules/Setup.dist
./configure --prefix=/usr \
	--enable-shared \
	--with-system-expat \
	--with-system-ffi \
	--with-ensurepip=yes \
	--enable-unicode=ucs4
make -j${CPUS}
make install
chmod -v 755 /usr/lib/libpython2.7.so.1.0

# End Python27

# Start SQLite

cd $LFS/sources || exit 1
tar xvf sqlite-autoconf-3240000.tar.gz
cd sqlite-autoconf-3240000 || exit 1

./configure --prefix=/usr \
	--disable-static \
	--enable-fts5 \
	CFLAGS="-g -O2                    \
            -DSQLITE_ENABLE_FTS4=1            \
            -DSQLITE_ENABLE_COLUMN_METADATA=1 \
            -DSQLITE_ENABLE_UNLOCK_NOTIFY=1   \
            -DSQLITE_ENABLE_DBSTAT_VTAB=1     \
            -DSQLITE_SECURE_DELETE=1          \
            -DSQLITE_ENABLE_FTS3_TOKENIZER=1"
make
make install

# End SQLite

# Start Subversion

cd $LFS/sources || exit 1
tar xvf subversion-1.10.2.tar.bz2
cd subversion-1.10.2 || exit 1

./configure --prefix=/usr \
	--disable-static \
	--with-apache-libexecdir \
	--with-lz4=internal \
	--with-utf8proc=internal
make
make install

# End Subversion

# Start Valgrind

cd $LFS/sources || exit 1
tar xvf valgrind-3.13.0.tar.bz2
cd valgrind-3.13.0 || exit 1

sed -i '1904s/4/5/' coregrind/m_syswrap/syswrap-linux.c
sed -i 's|/doc/valgrind||' docs/Makefile.in

./configure --prefix=/usr \
	--datadir=/usr/share/doc/valgrind-3.13.0
make
make install

# End Valgrind

# Start Git

cd $LFS/sources || exit 1
tar xvf git-2.16.2.tar.xz
cd git-2.16.2 || exit 1

find . -exec touch {} +
touch /usr/lib/perl5/5.26.2/x86_64-linux-thread-multi/Config.pm
touch /usr/lib/perl5/5.26.2/x86_64-linux-thread-multi/CORE/config.h

./configure --prefix=/usr \
	--with-gitconfig=/etc/gitconfig \
	--with-libpcre \
	–-without-tcltk
make -j${CPUS}
make -j${CPUS}
make install

# End Git

# Start libmd

cd $LFS/sources || exit 1
tar xvf libmd-1.0.0.tar.xz
cd libmd-1.0.0 || exit 1

find . -exec touch {} +
./autogen
./configure --prefix=/usr
make -j${CPUS}
make install

# End libmd

# Start dpkg

cd $LFS/sources || exit 1
tar xvf dpkg.tar.gz
cd dpkg || exit 1

./autogen
./configure --prefix=/usr
make -j${CPUS}
make install

touch /usr/var/lib/dpkg/status

# End dpkg

# Install the debs for apt

cd $LFS/sources || exit 1

export PERL5LIB=/usr/share/perl5

dpkg -i gpgv_2.1.18-8_deb9u2_amd64.deb
dpkg -i debian-archive-keyring_2017.5_all.deb
dpkg -i init-system-helpers_1.48_all.deb
dpkg -i debconf_1.5.61_all.deb
dpkg -i adduser_3.115_all.deb
dpkg -i liblz4-1_0.0_amd64.deb
dpkg -i libapt-pkg5.0_1.4.8_amd64.deb
dpkg -i apt_1.4.8_amd64.deb

# Give apt it's own dpkg/status
mkdir /var/lib/dpkg
ln -s /usr/var/lib/dpkg/status /var/lib/dpkg/status

# Debian does this weird, so fix
cp /usr/lib/x86_64-linux-gnu/libapt-* /usr/lib/
cp /usr/lib/x86_64-linux-gnu/liblz4.so.1 /usr/lib/
ldconfig -n -v /usr/lib

# Start Apache

cd $LFS/sources || exit 1
tar xvf httpd-2.4.34.tar.bz2
cd httpd-2.4.34 || exit 1

groupadd -g 25 apache &&
	useradd -c "Apache Server" -d /srv/www -g apache \
		-s /bin/false -u 25 apache
patch -Np1 -i ../httpd-2.4.34-blfs_layout-1.patch

sed '/dir.*CFG_PREFIX/s@^@#@' -i support/apxs.in

./configure --enable-authnz-fcgi \
	--enable-layout=BLFS \
	--enable-mods-shared="all cgi" \
	--enable-mpms-shared=all \
	--enable-suexec=shared \
	--with-apr=/usr/bin/apr-1-config \
	--with-apr-util=/usr/bin/apu-1-config \
	--with-suexec-bin=/usr/lib/httpd/suexec \
	--with-suexec-caller=apache \
	--with-suexec-docroot=/srv/www \
	--with-suexec-logfile=/var/log/httpd/suexec.log \
	--with-suexec-uidmin=100 \
	--with-suexec-userdir=public_html

make -j${CPUS}
make install
mv -v /usr/sbin/suexec /usr/lib/httpd/suexec
chgrp apache /usr/lib/httpd/suexec
chmod 4754 /usr/lib/httpd/suexec

chown -v -R apache:apache /srv/www

cd $LFS/sources || exit 1
tar xvf blfs-bootscripts-20180105.tar.xz
cd blfs-bootscripts-20180105 || exit 1

make install-httpd

# End Apache

# Start Tcsh

cd $LFS/sources || exit 1
tar xvf tcsh-6.20.00.tar.gz
cd tcsh-6.20.00 || exit 1

sed -i 's|SVID_SOURCE|DEFAULT_SOURCE|g' config/linux
sed -i 's|BSD_SOURCE|DEFAULT_SOURCE|g' config/linux

./configure --prefix=/usr
--bindir=/bin
make -j${CPUS}
sh ./tcsh.man2html

make install install.man
ln -v -sf tcsh /bin/csh
ln -v -sf tcsh.1 /usr/share/man/man1/csh.1

install -v -m755 -d /usr/share/doc/tcsh-6.20.00/html
install -v -m644 tcsh.html/* /usr/share/doc/tcsh-6.20.00/html
install -v -m644 FAQ /usr/share/doc/tcsh-6.20.00

cat >>/etc/shells <<"EOF"
/usr/bin/tcsh
EOF

cat >~/.cshrc <<"EOF"
# Colors!
set     red="%{\033[1;31m%}"
set   green="%{\033[0;32m%}"
set  yellow="%{\033[1;33m%}"
set    blue="%{\033[1;34m%}"
set magenta="%{\033[1;35m%}"
set    cyan="%{\033[1;36m%}"
set   white="%{\033[0;37m%}"
set     end="%{\033[0m%}" # This is needed at the end...

# Setting the actual prompt

set prompt="[${green}%n${blue}@%m ${white}%~ ]${end} "

# Provides coloured ls
alias ls ls --color=always
alias l ls --almost-all -l

# Make sure that Perl knows about debconf
set PERL5LIB=/usr/share/perl5

# Clean up after ourselves...
unset red green yellow blue magenta cyan yellow white end
EOF

su - administrator -c "chsh -s /usr/bin/tcsh"

rm -rf /sources /tools /finish-base.sh /build-to-bash.sh /user-group-setup.sh /wget-list
