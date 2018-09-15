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

# Start APR

cd $LFS/sources
tar xvf apr-1.6.3.tar.bz2
cd apr-1.6.3

./configure --prefix=/usr \
	--disable-static \
	--with-installbuilddir=/usr/share/apr-1/build
make -j${CPUS}
make install

# End APR

# Start APR-Util

cd $LFS/sources
tar xvf apr-util-1.6.1.tar.bz2
cd apr-util-1.6.1

./configure --prefix=/usr \
	--with-apr=/usr \
	--with-gdbm=/usr \
	--with-openssl=/usr \
	--with-crypto
make -j${CPUS}
make install

# End APR-Util

# Start PCRE

cd $LFS/sources
tar xvf pcre-8.41.tar.bz2
cd pcre-8.41

./configure --prefix=/usr \
	--docdir=/usr/share/doc/pcre-8.41 \
	--enable-unicode-properties \
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

# Start Apache

cd $LFS/sources
tar xvf httpd-2.4.29.tar.bz2
cd httpd-2.4.29

groupadd -g 25 apache
useradd -c "Apache Server" -d /srv/www -g apache \
	-s /bin/false -u 25 apache
patch -Np1 -i ../httpd-2.4.29-blfs_layout-1.patch

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

cd $LFS/sources
tar xvf blfs-bootscripts-20180105.tar.xz
cd blfs-bootscripts-20180105

make install-httpd

# End Apache

# Start Tcsh

cd $LFS/sources
tar xvf tcsh-6.20.00.tar.gz
cd tcsh-6.20.00

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
# Original at:
# https://www.cs.umd.edu/~srhuang/teaching/code_snippets/prompt_color.tcsh.html

# Modified by the BLFS Development Team.

# Add these lines to your ~/.cshrc (or to /etc/csh.cshrc).

# Colors!
set     red="%{\033[1;31m%}"
set   green="%{\033[0;32m%}"
set  yellow="%{\033[1;33m%}"
set    blue="%{\033[1;34m%}"
set magenta="%{\033[1;35m%}"
set    cyan="%{\033[1;36m%}"
set   white="%{\033[0;37m%}"
set     end="%{\033[0m%}" # This is needed at the end...

# Setting the actual prompt.  Two separate versions for you to try, pick
# whichever one you like better, and change the colors as you want.
# Just don't mess with the ${end} guy in either line...  Comment out or
# delete the prompt you don't use.

set prompt="${green}%n${blue}@%m ${white}%~ ${green}%%${end} "
set prompt="[${green}%n${blue}@%m ${white}%~ ]${end} "

# This was not in the original URL above
# Provides coloured ls
alias ls ls --color=always

# Clean up after ourselves...
unset red green yellow blue magenta cyan yellow white end
EOF

su - administrator -c "chsh -s /usr/bin/tcsh"

rm -rf /sources /tools /finish-base.sh /build-to-bash.sh /user-group-setup.sh /wget-list