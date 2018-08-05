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

function build_libtool() {
	cd $LFS/sources
	tar xvf libtool-2.4.6.tar.xz
	cd libtool-2.4.6

	./configure --prefix=/usr
	make -j${CPUS}
	make install
}

function build_gdbm() {
	cd $LFS/sources
	tar xvf gdbm-1.14.1.tar.gz
	cd gdbm-1.14.1

	./configure --prefix=/usr \
		--disable-static \
		--enable-libgdbm-compat
	make -j${CPUS}
	make install
}

function build_gperf() {
	cd $LFS/sources
	tar xvf gperf-3.1.tar.gz
	cd gperf-3.1

	./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
	make -j${CPUS}
	make install
}

function build_expat() {
	cd $LFS/sources
	tar xvf expat-2.2.5.tar.bz2
	cd expat-2.2.5

	sed -i 's|usr/bin/env |bin/|' run.sh.in
	./configure --prefix=/usr --disable-static
	make -j${CPUS}
	make install

	install -v -dm755 /usr/share/doc/expat-2.2.5
	install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.5
}

function build_inetutils() {
	cd $LFS/sources
	tar xvf inetutils-1.9.4.tar.xz
	cd inetutils-1.9.4

	./configure --prefix=/usr \
		--localstatedir=/var \
		--disable-logger \
		--disable-whois \
		--disable-rcp \
		--disable-rexec \
		--disable-rlogin \
		--disable-rsh \
		--disable-servers
	make -j${CPUS}
	make install

	mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin
	mv -v /usr/bin/ifconfig /sbin
}

function build_perl() {
	cd $LFS/sources
	tar xvf perl-5.26.2.tar.xz
	cd perl-5.26.2

	echo "127.0.0.1 localhost $(hostname)" >/etc/hosts
	export BUILD_ZLIB=False
	export BUILD_BZIP2=0

	sh Configure -des -Dprefix=/usr \
		-Dvendorprefix=/usr \
		-Dman1dir=/usr/share/man/man1 \
		-Dman3dir=/usr/share/man/man3 \
		-Dpager="/usr/bin/less -isR" \
		-Duseshrplib \
		-Dusethreads
	make -j${CPUS}
	make install
	unset BUILD_ZLIB BUILD_BZIP2
}

function build_perl_web() {
	cd $LFS/sources
	tar xvf libwww-perl-6.33.tar.gz
	cd libwww-perl-6.33

	perl Makefile.PL
	make -j${CPUS}
	make install
}

function build_parser() {
	cd $LFS/sources
	tar xvf XML-Parser-2.44.tar.gz
	cd XML-Parser-2.44

	perl Makefile.PL
	make -j${CPUS}
	make install
}

function build_dpkg_deps() {
	# The DPKG Perl deps. Clock issues in final build require them to be made before reboot
	cd $LFS/sources
	tar xvf ExtUtils-MakeMaker-7.34.tar.gz
	cd ExtUtils-MakeMaker-7.34

	perl Makefile.pl
	make -j${CPUS}
	make install

	cd $LFS/sources
	tar xvf Error-0.17025.tar.gz
	cd Error-0.17025

	perl Makefile.PL &&
		make &&
		make install
}

function build_intltool() {
	cd $LFS/sources
	tar xvf intltool-0.51.0.tar.gz
	cd intltool-0.51.0

	sed -i 's:\\\${:\\\$\\{:' intltool-update.in
	./configure --prefix=/usr
	make -j${CPUS}
	make install

	install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
}

function build_autoconf() {
	cd $LFS/sources
	tar xvf autoconf-2.69.tar.xz
	cd autoconf-2.69

	./configure --prefix=/usr
	make -j${CPUS}
	make install
}

function build_automake() {
	cd $LFS/sources
	tar xvf automake-1.16.1.tar.xz
	cd automake-1.16.1

	./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.1
	make -j${CPUS}
	make install
}

function build_xz() {
	cd $LFS/sources
	tar xvf xz-5.2.4.tar.xz
	cd xz-5.2.4

	./configure --prefix=/usr \
		--disable-static \
		--docdir=/usr/share/doc/xz-5.2.4
	make -j${CPUS}
	make install

	mv -v /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
	mv -v /usr/lib/liblzma.so.* /lib
	ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so
}

function build_kmod() {
	cd $LFS/sources
	tar xvf kmod-25.tar.xz
	cd kmod-25

	./configure --prefix=/usr \
		--bindir=/bin \
		--sysconfdir=/etc \
		--with-rootlibdir=/lib \
		--with-xz \
		--with-zlib
	make -j${CPUS}
	make install

	for target in depmod insmod lsmod modinfo modprobe rmmod; do
		ln -sfv ../bin/kmod /sbin/$target
	done

	ln -sfv kmod /bin/lsmod
}

function build_gettext() {
	cd $LFS/sources
	tar xvf gettext-0.19.8.1.tar.xz
	cd gettext-0.19.8.1

	sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in &&
		sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in

	./configure --prefix=/usr \
		--disable-static \
		--docdir=/usr/share/doc/gettext-0.19.8.1
	make -j${CPUS}
	make install

	chmod -v 0755 /usr/lib/preloadable_libintl.so
}

function build_libelf() {
	cd $LFS/sources
	tar xvf elfutils-0.170.tar.bz2
	cd elfutils-0.170

	patch -Np1 -i ../0001-Ensure-that-packed-structs-follow-the-gcc-memory-lay.patch
	./configure --prefix=/usr
	make -j${CPUS}
	make -C libelf install
	install -vm644 config/libelf.pc /usr/lib/pkgconfig
}

function build_libffi() {
	cd $LFS/sources
	tar xvf libffi-3.2.1.tar.gz
	cd libffi-3.2.1

	sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
		-i include/Makefile.in

	sed -e '/^includedir/ s/=.*$/=@includedir@/' \
		-e 's/^Cflags: -I${includedir}/Cflags:/' \
		-i libffi.pc.in

	./configure --prefix=/usr --disable-static
	make -j${CPUS}
	make install
}

function build_openssl() {
	cd $LFS/sources
	tar xvf openssl-1.1.0h.tar.gz
	cd openssl-1.1.0h

	./config --prefix=/usr \
		--openssldir=/etc/ssl \
		--libdir=lib \
		shared \
		enable-md2 \
		zlib-dynamic
	make -j${CPUS}
	sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
	make MANSUFFIX=ssl install

	mv -v /usr/share/doc/openssl /usr/share/doc/openssl-1.1.0h
	cp -vfr doc/* /usr/share/doc/openssl-1.1.0h
}

function build_python() {
	cd $LFS/sources
	tar xvf Python-3.6.5.tar.xz
	cd Python-3.6.5

	./configure --prefix=/usr \
		--enable-shared \
		--with-system-expat \
		--with-system-ffi \
		--with-ensurepip=yes
	make -j${CPUS}
	make install

	chmod -v 755 /usr/lib/libpython3.6m.so
	chmod -v 755 /usr/lib/libpython3.so
}

function build_ninja() {
	cd $LFS/sources
	tar xvf ninja-1.8.2.tar.gz
	cd ninja-1.8.2

	python3 configure.py --bootstrap

	python3 configure.py
	./ninja ninja_test
	./ninja_test --gtest_filter=-SubprocessTest.SetWithLots

	install -vm755 ninja /usr/bin/
	install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
	install -vDm644 misc/zsh-completion /usr/share/zsh/site-functions/_ninja
}

function build_meson() {
	cd $LFS/sources
	tar xvf meson-0.46.1.tar.gz
	cd meson-0.46.1

	python3 setup.py build
	python3 setup.py install
}

function build_procps() {
	cd $LFS/sources
	tar xvf procps-ng-3.3.15.tar.xz
	cd procps-ng-3.3.15

	./configure --prefix=/usr \
		--exec-prefix= \
		--libdir=/usr/lib \
		--docdir=/usr/share/doc/procps-ng-3.3.15 \
		--disable-static \
		--disable-kill
	make -j${CPUS}

	sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp
	sed -i '/set tty/d' testsuite/pkill.test/pkill.exp
	rm testsuite/pgrep.test/pgrep.exp

	make install

	mv -v /usr/lib/libprocps.so.* /lib
	ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so
}

function build_e2fsprogs() {
	cd $LFS/sources
	tar xvf e2fsprogs-1.44.2.tar.gz
	cd e2fsprogs-1.44.2

	mkdir -v build
	cd build

	LIBS=-L/tools/lib \
		CFLAGS=-I/tools/include \
		PKG_CONFIG_PATH=/tools/lib/pkgconfig \
		../configure --prefix=/usr \
		--bindir=/bin \
		--with-root-prefix="" \
		--enable-elf-shlibs \
		--disable-libblkid \
		--disable-libuuid \
		--disable-uuidd \
		--disable-fsck
	make -j${CPUS}
	ln -sfv /tools/lib/lib{blk,uu}id.so.1 lib
	make install
	make install-libs

	chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
	gunzip -v /usr/share/info/libext2fs.info.gz
	install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info

	makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo
	install -v -m644 doc/com_err.info /usr/share/info
	install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
}

function build_coreutils() {
	cd $LFS/sources
	tar xvf coreutils-8.29.tar.xz
	cd coreutils-8.29

	patch -Np1 -i ../coreutils-8.29-i18n-1.patch
	sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk

	autoreconf -fiv
	FORCE_UNSAFE_CONFIGURE=1 ./configure \
		--prefix=/usr \
		--enable-no-install-program=kill,uptime
	FORCE_UNSAFE_CONFIGURE=1 make -j${CPUS}
	make install

	mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
	mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
	mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
	mv -v /usr/bin/chroot /usr/sbin
	mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
	sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
	mv -v /usr/bin/{head,sleep,nice} /bin
}

function build_check() {
	cd $LFS/sources
	tar xvf check-0.12.0.tar.gz
	cd check-0.12.0

	./configure --prefix=/usr
	make -j${CPUS}
	make install
}

function build_diffutil() {
	cd $LFS/sources
	tar xvf diffutils-3.6.tar.xz
	cd diffutils-3.6

	./configure --prefix=/usr
	make -j${CPUS}
	make install
}

function build_gawk() {
	cd $LFS/sources
	tar xvf gawk-4.2.1.tar.xz
	cd gawk-4.2.1

	sed -i 's/extras//' Makefile.in
	./configure --prefix=/usr
	make -j${CPUS}
	make install

	mkdir -v /usr/share/doc/gawk-4.2.1
	cp -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-4.2.1
}

function build_findutils() {
	cd $LFS/sources
	tar xvf findutils-4.6.0.tar.gz
	cd findutils-4.6.0

	sed -i 's/test-lock..EXEEXT.//' tests/Makefile.in
	./configure --prefix=/usr --localstatedir=/var/lib/locate

	make -j${CPUS}
	make install
	mv -v /usr/bin/find /bin
	sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb
}

function build_groff() {
	cd $LFS/sources
	tar xvf groff-1.22.3.tar.gz
	cd groff-1.22.3

	PAGE=letter ./configure --prefix=/usr
	make -j1
	make install
}

function build_grub() {
	cd $LFS/sources
	tar xvf grub-2.02.tar.xz
	cd grub-2.02

	./configure --prefix=/usr \
		--sbindir=/sbin \
		--sysconfdir=/etc \
		--disable-efiemu \
		--disable-werror
	make -j${CPUS}
	make install

	# Will actually setup Grub later on in the build process, but install the tool here
}

function build_less() {
	cd $LFS/sources
	tar xvf less-530.tar.gz
	cd less-530

	./configure --prefix=/usr --sysconfdir=/etc
	make -j${CPUS}
	make install
}

function build_gzip() {
	cd $LFS/sources
	tar xvf gzip-1.9.tar.xz
	cd gzip-1.9

	./configure --prefix=/usr
	make -j${CPUS}
	make install
	mv -v /usr/bin/gzip /bin
}

function build_iproute() {
	cd $LFS/sources
	tar xvf iproute2-4.16.0.tar.xz
	cd iproute2-4.16.0

	sed -i /ARPD/d Makefile
	rm -fv man/man8/arpd.8
	sed -i 's/m_ipt.o//' tc/Makefile

	make -j${CPUS}
	make DOCDIR=/usr/share/doc/iproute2-4.16.0 install
}

function build_kbd() {
	cd $LFS/sources
	tar xvf kbd-2.0.4.tar.xz
	cd kbd-2.0.4

	patch -Np1 -i ../kbd-2.0.4-backspace-1.patch
	sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
	sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

	PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr --disable-vlock
	make -j${CPUS}
	make install

	mkdir -v /usr/share/doc/kbd-2.0.4
	cp -R -v docs/doc/* /usr/share/doc/kbd-2.0.4
}

function build_libpipeline() {
	cd $LFS/sources
	tar xvf libpipeline-1.5.0.tar.gz
	cd libpipeline-1.5.0

	./configure --prefix=/usr
	make -j${CPUS}
	make install
}

function build_make() {
	cd $LFS/sources
	tar xvf make-4.2.1.tar.bz2
	cd make-4.2.1

	sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c
	./configure --prefix=/usr
	make -j${CPUS}
	make install
}

function build_patch() {
	cd $LFS/sources
	tar xvf patch-2.7.6.tar.xz
	cd patch-2.7.6

	./configure --prefix=/usr
	make -j${CPUS}
	make install
}

function build_sysklogd() {
	cd $LFS/sources
	tar xvf sysklogd-1.5.1.tar.gz
	cd sysklogd-1.5.1

	sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
	sed -i 's/union wait/int/' syslogd.c

	make
	make BINDIR=/sbin install
}

build_libtool
build_gdbm
build_gperf
build_expat
build_inetutils
build_perl
build_parser
build_dpkg_deps
build_intltool
build_autoconf
build_automake
build_xz
build_kmod
build_gettext
build_libelf
build_libffi
build_openssl
build_python
build_ninja
build_meson
build_procps
build_e2fsprogs
build_coreutils
build_check
build_diffutil
build_gawk
build_findutils
build_groff
build_grub
build_less
build_gzip
build_iproute
build_kbd
build_libpipeline
build_make
build_patch
build_sysklogd

cat >/etc/syslog.conf <<"EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# End /etc/syslog.conf
EOF

function build_sysvinit() {
	cd $LFS/sources
	tar xvf sysvinit-2.89.tar.bz2
	cd sysvinit-2.89

	patch -Np1 -i ../sysvinit-2.89-consolidated-1.patch
	make -C src
	make -C src install
}

build_sysvinit

# Start 6.72 Eudev
cd $LFS/sources
tar xvf eudev-3.2.5.tar.gz
cd eudev-3.2.5

sed -r -i 's|/usr(/bin/test)|\1|' test/udev-test.pl
cat >config.cache <<"EOF"
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include"
EOF

./configure --prefix=/usr \
	--bindir=/sbin \
	--sbindir=/sbin \
	--libdir=/usr/lib \
	--sysconfdir=/etc \
	--libexecdir=/lib \
	--with-rootprefix= \
	--with-rootlibdir=/lib \
	--enable-manpages \
	--disable-static \
	--config-cache
LIBRARY_PATH=/tools/lib make -j${CPUS}
mkdir -pv /lib/udev/rules.d
mkdir -pv /etc/udev/rules.d

make LD_LIBRARY_PATH=/tools/lib install

tar -xvf ../udev-lfs-20171102.tar.bz2
make -f udev-lfs-20171102/Makefile.lfs install
LD_LIBRARY_PATH=/tools/lib udevadm hwdb --update
# End 6.72 Eudev

function build_util_linux() {
	cd $LFS/sources
	tar xvf util-linux-2.32.tar.xz
	cd util-linux-2.32

	mkdir -pv /var/lib/hwclock

	./configure ADJTIME_PATH=/var/lib/hwclock/adjtime \
		--docdir=/usr/share/doc/util-linux-2.32 \
		--disable-chfn-chsh \
		--disable-login \
		--disable-nologin \
		--disable-su \
		--disable-setpriv \
		--disable-runuser \
		--disable-pylibmount \
		--disable-static \
		--without-python \
		--without-systemd \
		--without-systemdsystemunitdir
	make -j${CPUS}
	make install
}

function build_man() {
	cd $LFS/sources
	tar xvf man-db-2.8.3.tar.xz
	cd man-db-2.8.3

	./configure --prefix=/usr \
		--docdir=/usr/share/doc/man-db-2.8.3 \
		--sysconfdir=/etc \
		--disable-setuid \
		--enable-cache-owner=bin \
		--with-browser=/usr/bin/lynx \
		--with-vgrind=/usr/bin/vgrind \
		--with-grap=/usr/bin/grap \
		--with-systemdtmpfilesdir=
	make -j${CPUS}
	make install
}

function build_tar() {
	cd $LFS/sources
	tar xvf tar-1.30.tar.xz
	cd tar-1.30

	FORCE_UNSAFE_CONFIGURE=1 \
		./configure --prefix=/usr \
		--bindir=/bin
	make -j${CPUS}
	make install
	make -C doc install-html docdir=/usr/share/doc/tar-1.30
}

function build_texinfo() {
	cd $LFS/sources
	tar xvf texinfo-6.5.tar.xz
	cd texinfo-6.5

	./configure --prefix=/usr --disable-static
	make -j${CPUS}
	make install
	make TEXMF=/usr/share/texmf install-tex
}

function build_vim() {
	cd $LFS/sources
	tar xvf vim-8.1.tar.bz2
	cd vim81

	echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >>src/feature.h
	sed -i '/call/{s/split/xsplit/;s/303/492/}' src/testdir/test_recover.vim

	./configure --prefix=/usr
	make -j${CPUS}
	make install

	ln -sv vim /usr/bin/vi
	for L in /usr/share/man/{,*/}man1/vim.1; do
		ln -sv vim.1 $(dirname $L)/vi.1
	done
	ln -sv ../vim/vim81/doc /usr/share/doc/vim-8.1
}

build_util_linux
build_man
build_tar
build_texinfo
build_vim

cat >/etc/vimrc <<"EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1 

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF

# Cleanup
rm -rf /tmp/*
rm -f /usr/lib/lib{bfd,opcodes}.a
rm -f /usr/lib/libbz2.a
rm -f /usr/lib/lib{com_err,e2p,ext2fs,ss}.a
rm -f /usr/lib/libltdl.a
rm -f /usr/lib/libfl.a
rm -f /usr/lib/libfl_pic.a
rm -f /usr/lib/libz.a
find /usr/lib -name \*.la -delete

function build_bootscripts() {
	cd $LFS/sources
	tar xvf lfs-bootscripts-20170626.tar.bz2
	cd lfs-bootscripts-20170626

	make install
}

build_bootscripts
bash /lib/udev/init-net-rules.sh

echo "Setting net rules"
cd /etc/sysconfig/
cat >ifconfig.enp0s3 <<"EOF"
ONBOOT="yes"
IFACE="enp0s3"
SERVICE="dhcpcd"
DHCP_START="-b -q"
DHCP_STOP="-k"
EOF
cat >/etc/resolv.conf.head <<"EOF"
# OpenDNS servers
nameserver 208.67.222.222
nameserver 208.67.220.220
EOF

# Create bootfile
cat >/etc/inittab <<"EOF"
# Begin /etc/inittab

id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc S

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S016:once:/sbin/sulogin

1:2345:respawn:/sbin/agetty --noclear tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600

# End /etc/inittab
EOF

# Config clock
cat >/etc/sysconfig/clock <<"EOF"
# Begin /etc/sysconfig/clock

UTC=1

# Set this to any options you might need to give to hwclock,
# such as machine hardware clock type for Alphas.
CLOCKPARAMS=

# End /etc/sysconfig/clock
EOF

# Keymap stuff
LC_ALL=en_US.UTF-8 locale language
LC_ALL=en_US.UTF-8 locale charmap
LC_ALL=en_US.UTF-8 locale int_curr_symbol
LC_ALL=en_US.UTF-8 locale int_prefix

cat >/etc/profile <<"EOF"
# Begin /etc/profile

export LANG=en_US.UTF-8

# End /etc/profile
EOF

echo "Making inputrc"

cat >/etc/inputrc <<"EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF

echo "Making shells file"
cat >/etc/shells <<"EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

echo "Attempting to make system bootable"

cat >/etc/fstab <<"EOF"
# Begin /etc/fstab

# file system  mount-point  type     options             dump  fsck
#                                                              order

/dev/sda4      /            ext4     defaults            1     1
/dev/sda2      /boot    		vfat     defaults,noatime    0     2
/dev/sda3      swap         swap     pri=1               0     0
proc           /proc        proc     nosuid,noexec,nodev 0     0
sysfs          /sys         sysfs    nosuid,noexec,nodev 0     0
tmpfs          /run         tmpfs    defaults            0     0
devtmpfs       /dev         devtmpfs mode=0755,nosuid    0     0

# End /etc/fstab
EOF

function build_kernel() {
	echo "Starting kernel"
	cd $LFS/sources
	tar xvf linux-4.16.10.tar.xz
	cd linux-4.16.10

	make mrproper
	# Let's see if this works
	make defconfig

	make
	make modules_install

	# Make system bootable
	cp -iv arch/x86/boot/bzImage /boot/vmlinuz-4.16.10-gt-1.0
	cp -iv System.map /boot/System.map-4.16.10
	cp -iv .config /boot/config-4.16.10
	install -d /usr/share/doc/linux-4.16.10
	cp -r Documentation/* /usr/share/doc/linux-4.16.10

	install -v -m755 -d /etc/modprobe.d
	echo "Finished kernel"
}

build_kernel
cat >/etc/modprobe.d/usb.conf <<"EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF

cd /tmp
grub-install /dev/sda

cat >/boot/grub/grub.cfg <<"EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2
set root=(hd0,2)

menuentry "GNU/Linux, Linux 4.16.10-gt-1.0" {
        linux   /vmlinuz-4.16.10-gt-1.0 root=/dev/sda4 ro
}
EOF

echo 1.0 >/etc/gt-release
cat >/etc/lsb-release <<"EOF"
DISTRIB_ID="Ginger Technology OS"
DISTRIB_RELEASE="1.0"
DISTRIB_CODENAME="GTOS"
DISTRIB_DESCRIPTION="Ginger Technology In-House Linux"
EOF

# From here are a few things that will be needed in order to successfully connect after rebooting

# wget is not strictly needed, but will be useful
cd $LFS/sources
tar xvf wget-1.19.4.tar.gz
cd wget-1.19.4
./configure --prefix=/usr \
	--sysconfdir=/etc \
	--with-ssl=openssl &&
	make
make install

# Bootscripts
cd $LFS/sources
tar xvf blfs-bootscripts-20180105.tar.xz
cd blfs-bootscripts-20180105

# DHCP
cd $LFS/sources
tar xvf dhcpcd-7.0.1.tar.xz
cd dhcpcd-7.0.1
./configure --libexecdir=/lib/dhcpcd \
	--dbdir=/var/lib/dhcpcd &&
	make
make install
cd $LFS/sources/blfs-bootscripts-20180105
make install-service-dhcpcd

# Sudo, for privilege escalation
cd $LFS/sources
tar xvf sudo-1.8.22.tar.gz
cd sudo-1.8.22
./configure --prefix=/usr \
	--libexecdir=/usr/lib \
	--with-secure-path \
	--with-all-insults \
	--with-env-editor \
	--docdir=/usr/share/doc/sudo-1.8.22 \
	--with-passprompt="[sudo] password for %p: " &&
	make
make install &&
	ln -sfv libsudo_util.so.0.0.0 /usr/lib/sudo/libsudo_util.so.0
PASSWORD=$(openssl passwd -crypt 'password')
useradd --password ${PASSWORD} --comment 'administrator User' --create-home --user-group administrator
echo 'Defaults env_keep += \"SSH_AUTH_SOCK\"' >/etc/sudoers
echo 'administrator ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers

function build_ssh() {
	# OpenSSH Server to connect post-reboot
	cd $LFS/sources
	tar xvf openssh-7.6p1.tar.gz
	cd openssh-7.6p1

	install -v -m700 -d /var/lib/sshd &&
		chown -v root:sys /var/lib/sshd &&
		groupadd -g 75 sshd
	useradd -c 'sshd PrivSep' \
		-d /var/lib/sshd \
		-g sshd \
		-s /bin/false \
		-u 75 sshd
	patch -Np1 -i ../openssh-7.6p1-openssl-1.1.0-1.patch

	./configure --prefix=/usr \
		--sysconfdir=/etc/ssh \
		--with-md5-passwords \
		--with-privsep-path=/var/lib/sshd
	make -j${CPUS}
	make install
	install -v -m755 contrib/ssh-copy-id /usr/bin
	install -v -m644 contrib/ssh-copy-id.1 \
		/usr/share/man/man1
	install -v -m755 -d /usr/share/doc/openssh-7.6p1
	install -v -m644 INSTALL LICENCE OVERVIEW README* \
		/usr/share/doc/openssh-7.6p1

	cd $LFS/sources
	tar xvf blfs-bootscripts-20180105.tar.xz
	cd $LFS/sources/blfs-bootscripts-20180105
	make install-sshd
}

build_ssh

cd $LFS/sources
rm -R -- */
