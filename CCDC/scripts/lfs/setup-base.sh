#!/usr/bin/env bash

# stop on errors
set -eu
set -x
set +h

#
# This section is from an Arch setup script, since I am using Arch's live CD for the creation of the LFS partitions
#
if [[ $PACKER_BUILDER_TYPE == "qemu" ]]; then
	DISK='/dev/vda'
else
	DISK='/dev/sda'
fi

FQDN='gingertechweb.gingertech.com'
KEYMAP='us'
LANGUAGE='en_US.UTF-8'
PASSWORD=$(/usr/bin/openssl passwd -crypt 'password')
TIMEZONE='UTC'

TARGET_DIR='/mnt'
COUNTRY=${COUNTRY:-US}

echo "==> Clearing partition table on ${DISK}"
/usr/bin/sgdisk --zap ${DISK}

echo "==> Destroying magic strings and signatures on ${DISK}"
/usr/bin/dd if=/dev/zero of=${DISK} bs=512 count=2048
/usr/bin/wipefs --all ${DISK}
#
# End Arch setup stuff
#

#
# Start LFS setup functions
#

umask 022
LFS=/mnt/lfs
echo $LFS
LC_ALL=POSIX
echo $LC_ALL
LFS_TGT=$(uname -m)-gt-linux-gnu
echo "On $LFS_TGT"
PATH=/tools/bin:/bin:/usr/bin:/usr/bin/core_perl

function set_filesystems() {
	# Make the boot partition ext2
	mkfs.vfat -F32 $12
	# Make the file partition ext4
	mkfs.ext4 $14
	# Make the third partition swap
	mkswap $13
	swapon $13

	echo "Filesystems set. Mounting partition where system will be built."
}

function make_directories() {
	mkdir -pv $LFS/boot
	mkdir -pv $LFS/sources
	mkdir -pv $LFS/tools

	chmod -v a+wt $LFS/sources
	ln -sv $LFS/tools /

	chown -v administrator $LFS/tools
	chown -v administrator $LFS/sources
	chown -v administrator $LFS/boot
}

function partition_disk() {
	# Save the disk used to a file for later use
	echo ${DISK} >/tmp/diskUsed.txt

	# Make the disk GPT to make life easy later
	echo "Using parted to label disk GPT."
	parted -a optimal ${DISK} mklabel gpt
	# Partition sizes will be given in megabytes
	parted -a optimal ${DISK} unit mib
	echo "Setting partition format as recommended in Gentoo Handbook."
	# Refer to the disk setup chapter for specifics
	# But basically
	# Four partitions. grub, boot, swap, files
	parted -a optimal ${DISK} mkpart primary 1 3
	parted -a optimal ${DISK} name 1 grub
	parted -a optimal ${DISK} set 1 bios_grub on
	parted -a optimal ${DISK} mkpart primary 3 131
	parted -a optimal ${DISK} name 2 boot
	parted -a optimal ${DISK} mkpart primary 131 643
	parted -a optimal ${DISK} name 3 swap
	parted -a optimal ${DISK} mkpart primary 643 -- -1
	parted -a optimal ${DISK} name 4 rootfs
	parted -a optimal ${DISK} set 2 boot on
	parted -a optimal ${DISK} print

	echo "Formatting disks complete. Now setting file system types."
	set_filesystems ${DISK}
}

partition_disk
mkdir -pv $LFS
mount -v -t ext4 ${DISK}4 $LFS
chown -v administrator $LFS
make_directories

mount -v -t vfat ${DISK}2 $LFS/boot

# Move into the main disk and download all the packages that will be needed
cd $LFS || exit 1
wget https://files.gingertechnology.net/packersystems/lfs/wget-list
wget --input-file=wget-list --continue --directory-prefix=$LFS/sources
mv -v /temp/0001-Ensure-that-packed-structs-follow-the-gcc-memory-lay.patch $LFS/sources/0001-Ensure-that-packed-structs-follow-the-gcc-memory-lay.patch

# Start 5.4 Binutils
cd $LFS/sources || exit 1
tar xvf binutils-2.30.tar.xz
cd binutils-2.30 || exit 1

mkdir -v build
cd build || exit 1

../configure --prefix=/tools \
	--with-sysroot=$LFS \
	--with-lib-path=/tools/lib \
	--target=$LFS_TGT \
	--disable-nls \
	--disable-werror

make -j${CPUS}

case $(uname -m) in
x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
esac

make install
cd $LFS/sources || exit 1
rm -rf binutils-2.30
sleep 5
# End 5.4 Binutils

# Start 5.5 GCC Pass 1
cd $LFS/sources || exit 1

tar xvf gcc-8.1.0.tar.xz
cd gcc-8.1.0 || exit 1

tar xvf ../mpfr-4.0.1.tar.xz
mv -v mpfr-4.0.1 mpfr
tar xvf ../gmp-6.1.2.tar.xz
mv -v gmp-6.1.2 gmp
tar xvf ../mpc-1.1.0.tar.gz
mv -v mpc-1.1.0 mpc

for file in gcc/config/{linux,i386/linux{,64}}.h; do
	cp -uv $file{,.orig}
	sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
		-e 's@/usr@/tools@g' $file.orig >$file
	echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >>$file
	touch $file.orig
done

case $(uname -m) in
x86_64)
	sed -e '/m64=/s/lib64/lib/' \
		-i.orig gcc/config/i386/t-linux64
	;;
esac

mkdir -v build
cd build || exit 1

../configure \
	--target=$LFS_TGT \
	--prefix=/tools \
	--with-glibc-version=2.11 \
	--with-sysroot=$LFS \
	--with-newlib \
	--without-headers \
	--with-local-prefix=/tools \
	--with-native-system-header-dir=/tools/include \
	--disable-nls \
	--disable-shared \
	--disable-multilib \
	--disable-decimal-float \
	--disable-threads \
	--disable-libatomic \
	--disable-libgomp \
	--disable-libmpx \
	--disable-libquadmath \
	--disable-libssp \
	--disable-libvtv \
	--disable-libstdcxx \
	--enable-languages=c,c++

make -j${CPUS}
make install

cd $LFS/sources || exit 1
sleep 5
# End 5.5 GCC

# Start 5.6 Linux API Headers
cd $LFS/sources || exit 1
tar xvf linux-4.16.10.tar.xz
cd linux-4.16.10 || exit 1

make mrproper
make INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* /tools/include

cd $LFS/sources || exit 1
rm -rf linux-4.16.10
sleep 5
# End 5.6 Linux API Headers

# Start 5.7 Glibc
cd $LFS/sources || exit 1
tar xvf glibc-2.27.tar.xz
cd glibc-2.27 || exit 1

mkdir -v build
cd build || exit 1

../configure \
	--prefix=/tools \
	--host=$LFS_TGT \
	--build=$(../scripts/config.guess) \
	--enable-kernel=3.2 \
	--with-headers=/tools/include \
	libc_cv_forced_unwind=yes \
	libc_cv_c_cleanup=yes

make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf glibc-2.27
sleep 5
# End 5.7 Glibc

# Start 5.8 Libstdc++
cd gcc-8.1.0 || exit 1

cd build || exit 1

../libstdc++-v3/configure \
	--host=$LFS_TGT \
	--prefix=/tools \
	--disable-multilib \
	--disable-nls \
	--disable-libstdcxx-threads \
	--disable-libstdcxx-pch \
	--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/8.1.0

make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf gcc-8.1.0
sleep 5
# End 5.8 Libstdc++

# Start 5.9 Binutils Pass 2
cd $LFS/sources || exit 1
tar xvf binutils-2.30.tar.xz
cd binutils-2.30 || exit 1

mkdir -v build
cd build || exit 1

CC=$LFS_TGT-gcc \
	AR=$LFS_TGT-ar \
	RANLIB=$LFS_TGT-ranlib \
	../configure \
	--prefix=/tools \
	--disable-nls \
	--disable-werror \
	--with-lib-path=/tools/lib \
	--with-sysroot

make -j${CPUS}
make install

make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib
cp -v ld/ld-new /tools/bin

cd $LFS/sources || exit 1
rm -rf binutils-2.30
sleep 5
# End 5.9 Binutils Pass 2

# Start 5.10 GCC Pass 2
cd $LFS/sources || exit 1
tar xvf gcc-8.1.0.tar.xz
cd gcc-8.1.0 || exit 1

cat gcc/limitx.h gcc/glimits.h gcc/limity.h >$(dirname $($LFS_TGT-gcc -print-libgcc-file-name))/include-fixed/limits.h

for file in gcc/config/{linux,i386/linux{,64}}.h; do
	cp -uv $file{,.orig}
	sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
		-e 's@/usr@/tools@g' $file.orig >$file
	echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >>$file
	touch $file.orig
done

case $(uname -m) in
x86_64)
	sed -e '/m64=/s/lib64/lib/' \
		-i.orig gcc/config/i386/t-linux64
	;;
esac

tar xvf ../mpfr-4.0.1.tar.xz
mv -v mpfr-4.0.1 mpfr
tar xvf ../gmp-6.1.2.tar.xz
mv -v gmp-6.1.2 gmp
tar xvf ../mpc-1.1.0.tar.gz
mv -v mpc-1.1.0 mpc

mkdir -v build
cd build || exit 1

CC=$LFS_TGT-gcc \
	CXX=$LFS_TGT-g++ \
	AR=$LFS_TGT-ar \
	RANLIB=$LFS_TGT-ranlib \
	../configure \
	--prefix=/tools \
	--with-local-prefix=/tools \
	--with-native-system-header-dir=/tools/include \
	--enable-languages=c,c++ \
	--disable-libstdcxx-pch \
	--disable-multilib \
	--disable-bootstrap \
	--disable-libgomp

make -j${CPUS}
make install
ln -sv gcc /tools/bin/cc
sleep 5
# End 5.10 GCC Pass 2

# Start 5.11 Tcl-Core
cd $LFS/sources || exit 1
tar xvf tcl8.6.8-src.tar.gz
cd tcl8.6.8 || exit 1

cd unix || exit 1
./configure --prefix=/tools
make -j${CPUS}
make install

chmod -v u+w /tools/lib/libtcl8.6.so
make install-private-headers
ln -sv tclsh8.6 /tools/bin/tclsh

cd $LFS/sources || exit 1
rm -rf tcl8.6.8
sleep 5
# End 5.11 Tcl-Core

# Start 5.12 Expect
cd $LFS/sources || exit 1
tar xvf expect5.45.4.tar.gz
cd expect5.45.4 || exit 1

cp -v configure{,.orig}
sed 's:/usr/local/bin:/bin:' configure.orig >configure

./configure --prefix=/tools \
	--with-tcl=/tools/lib \
	--with-tclinclude=/tools/include

make -j${CPUS}
make SCRIPTS="" install

cd $LFS/sources || exit 1
rm -rf expect5.45.4
sleep 5
# End 5.12 Expect

# Start 5.13 DejaGNU
cd $LFS/sources || exit 1
tar xvf dejagnu-1.6.1.tar.gz
cd dejagnu-1.6.1 || exit 1

./configure --prefix=/tools
make install

cd $LFS/sources || exit 1
rm -rf dejagnu-1.6.1
sleep 5
# End 5.13 DejaGNU

# Start 5.14 M4
cd $LFS/sources || exit 1
tar xvf m4-1.4.18.tar.xz
cd m4-1.4.18 || exit 1

./configure --prefix=/tools
make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf m4-1.4.18
sleep 5
# End 5.14 M4

# Start 5.15 Ncurses
cd $LFS/sources || exit 1
tar xvf ncurses-6.1.tar.gz
cd ncurses-6.1 || exit 1

sed -i s/mawk// configure
./configure --prefix=/tools \
	--with-shared \
	--without-debug \
	--without-ada \
	--enable-widec \
	--enable-overwrite
make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf ncurses-6.1
sleep 5
# End 5.15 Ncurses

# Start 5.16 Bash
cd $LFS/sources || exit 1
tar xvf bash-4.4.18.tar.gz
cd bash-4.4.18 || exit 1

./configure --prefix=/tools --without-bash-malloc

make -j${CPUS}
make install
ln -sv bash /tools/bin/sh

cd $LFS/sources || exit 1
rm -rf bash-4.4.18
sleep 5
# End 5.16 Bash

# Start 5.17 Bison
cd $LFS/sources || exit 1
tar xvf bison-3.0.4.tar.xz
cd bison-3.0.4 || exit 1

./configure --prefix=/tools
make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf bison-3.0.4
sleep 5
# End 5.17 Bison

# Start 5.18 Bzip2
cd $LFS/sources || exit 1
tar xvf bzip2-1.0.6.tar.gz
cd bzip2-1.0.6 || exit 1

make
make PREFIX=/tools install

cd $LFS/sources || exit 1
rm -rf bzip2-1.0.6
sleep 5
# End 5.18 Bzip2

# Start 5.19 Coreutils
cd $LFS/sources || exit 1
tar xvf coreutils-8.29.tar.xz
cd coreutils-8.29 || exit 1

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/tools --enable-install-program=hostname
make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf coreutils-8.29
sleep 5
# End 5.19 Coreutils

# Start 5.20 Diffutils
cd $LFS/sources || exit 1
tar xvf diffutils-3.6.tar.xz
cd diffutils-3.6 || exit 1

./configure --prefix=/tools
make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf diffutils-3.6
sleep 5
# End 5.10 Diffutils

# Start 5.21 File
cd $LFS/sources || exit 1
tar xvf file-5.33.tar.gz
cd file-5.33 || exit 1

./configure --prefix=/tools
make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf file-5.33
sleep 5
# End 5.21 File

# Start 5.22 Findutils
cd $LFS/sources || exit 1
tar xvf findutils-4.6.0.tar.gz
cd findutils-4.6.0 || exit 1

./configure --prefix=/tools
make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf findutils-4.6.0
sleep 5
# End 5.22 Findutils

# Start 5.23 Gawk
cd $LFS/sources || exit 1
tar xvf gawk-4.2.1.tar.xz
cd gawk-4.2.1 || exit 1

./configure --prefix=/tools
make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf gawk-4.2.1
sleep 5
# End 5.23 Gawk

# Start 5.24 Gettext
cd $LFS/sources || exit 1
tar xvf gettext-0.19.8.1.tar.xz
cd gettext-0.19.8.1 || exit 1

cd gettext-tools || exit 1
EMACS="no" ./configure --prefix=/tools --disable-shared

make -C gnulib-lib
make -C intl pluralx.c
make -C src msgfmt
make -C src msgmerge
make -C src xgettext

cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin

cd $LFS/sources || exit 1
rm -rf gettext-0.19.8.1
sleep 5
# End 5.24 Gettext

# Start 5.25 Grep
cd $LFS/sources || exit 1
tar xvf grep-3.1.tar.xz
cd grep-3.1 || exit 1

./configure --prefix=/tools
make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf grep-3.1
sleep 5
# End 5.25 Grep

# Start 5.26 Gzip
cd $LFS/sources || exit 1
tar xvf gzip-1.9.tar.xz
cd gzip-1.9 || exit 1

./configure --prefix=/tools
make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf gzip-1.9
sleep 5
# End 5.26 Gzip

# Start 5.27 Make
cd $LFS/sources || exit 1
tar xvf make-4.2.1.tar.bz2
cd make-4.2.1 || exit 1

sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c
./configure --prefix=/tools \
	--without-guile

make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf make-4.2.1
sleep 5
# End 5.27 Make

# Start 5.28 Patch
cd $LFS/sources || exit 1
tar xvf patch-2.7.6.tar.xz
cd patch-2.7.6 || exit 1

./configure --prefix=/tools
make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf patch-2.7.6
sleep 5
# End 5.28 Patch

# Start 5.29 Perl
cd $LFS/sources || exit 1
tar xvf perl-5.26.2.tar.xz
cd perl-5.26.2 || exit 1

sh Configure -des -Dprefix=/tools -Dlibs=-lm
make -j${CPUS}

cp -v perl cpan/podlators/scripts/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/5.26.2
cp -Rv lib/* /tools/lib/perl5/5.26.2

cd $LFS/sources || exit 1
rm -rf perl-5.26.2
sleep 5
# End 5.29 Perl

# Start 5.30 Sed
cd $LFS/sources || exit 1
tar xvf sed-4.5.tar.xz
cd sed-4.5 || exit 1

./configure --prefix=/tools
make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf sed-4.5
sleep 5
# End 5.30 Sed

# Start 5.31 Tar
cd $LFS/sources || exit 1
tar xvf tar-1.30.tar.xz
cd tar-1.30 || exit 1

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/tools
make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf tar-1.30
sleep 5
# End 5.31 Tar

# Start 5.32 Texinfo
cd $LFS/sources || exit 1
tar xvf texinfo-6.5.tar.xz
cd texinfo-6.5 || exit 1

./configure --prefix=/tools
make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf texinfo-6.5
sleep 5
# End 5.32 Texinfo

# Start 5.33 Util-linux
cd $LFS/sources || exit 1
tar xvf util-linux-2.32.tar.xz
cd util-linux-2.32 || exit 1

./configure --prefix=/tools \
	--without-python \
	--disable-makeinstall-chown \
	--without-systemdsystemunitdir \
	--without-ncurses \
	PKG_CONFIG=""

make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf util-linux-2.32
sleep 5
# End 5.33 Util-linux

# Start 5.34 Xz
cd $LFS/sources || exit 1
tar xvf xz-5.2.4.tar.xz
cd xz-5.2.4 || exit 1

./configure --prefix=/tools
make -j${CPUS}
make install

cd $LFS/sources || exit 1
rm -rf xz-5.2.4
sleep 5
# End 5.34 Xz

chown -R root:root $LFS/tools

mkdir -pv $LFS/{dev,proc,sys,run}

mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3

mount -v --bind /dev $LFS/dev
#mount -vt devpts devpts $LFS/dev/pts -o gid=5,mods=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
	mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

mv -v /temp/build-to-bash.sh $LFS/build-to-bash.sh
mv -v /temp/finish-base.sh $LFS/finish-base.sh
mv -v /temp/user-group-setup.sh $LFS/user-group-setup.sh
cd $LFS || exit 1
chmod -v +x build-to-bash.sh
chmod -v +x finish-base.sh
chmod -v +x user-group-setup.sh

cd $LFS/sources || exit 1
rm -R -- */

chroot "$LFS" /tools/bin/env -i \
	HOME=/root \
	TERM="$TERM" \
	CPUS="$CPUS" \
	PS1='(lfs chroot) \u:\w\$ ' \
	PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin:/usr/bin/core_perl \
	/tools/bin/bash --login +h \
	./user-group-setup.sh
