#!/usr/bin/env bash

# stop on errors
set -eu

#
# This section is from an Arch setup script, since I am using Arch's live CD for the creation of the LFS partitions
#
if [[ $PACKER_BUILDER_TYPE == "qemu" ]]; then
	DISK='/dev/vda'
else
	DISK='/dev/sda'
fi

FQDN='workstation.gingertech.com'
KEYMAP='us'
LANGUAGE='en_US.UTF-8'
PASSWORD=$(/usr/bin/openssl passwd -crypt 'password')
TIMEZONE='UTC'

TARGET_DIR='/mnt'
COUNTRY=${COUNTRY:-US}
MIRRORLIST="https://www.archlinux.org/mirrorlist/?country=${COUNTRY}&protocol=http&protocol=https&ip_version=4&use_mirror_status=on"

echo "==> Setting local mirror"
curl -s "$MIRRORLIST" |  sed 's/^#Server/Server/' > /etc/pacman.d/mirrorlist

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

function set_filesystems
{
	# Make the boot partition ext2
	mkfs.vfat -F32 $12
	# Make the file partition ext4
	mkfs.ext4 $14
	# Make the third partition swap
	mkswap $13
	swapon $13

	echo "Filesystems set. Mounting partition where system will be built."
}

function make_directories
{
  mkdir -pv $LFS/boot
  mkdir -pv $LFS/sources
  mkdir -pv $LFS/tools

  chmod -v a+wt $LFS/sources
  ln -sv $LFS/tools /

  chown -v administrator $LFS/tools
  chown -v administrator $LFS/sources
  chown -v administrator $LFS/boot
}

function partition_disk
{
	# Save the disk used to a file for later use
	echo ${DISK} > /tmp/diskUsed.txt

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
make_directories

mount -v -t vfat ${DISK}2 $LFS/boot

pacman -Sy
pacman -Sc --noconfirm

# Move into the main disk and download all the packages that will be needed
cd $LFS
wget https://files.gingertechnology.net/packersystems/lfs/wget-list
wget --input-file=wget-list --continue --directory-prefix=$LFS/sources

#exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
umask 022
LFS=/mnt/lfs
echo $LFS
LC_ALL=POSIX
echo $LC_ALL
LFS_TGT=$(uname -m)-lfs-linux-gnu
echo "On $LFS_TGT"
PATH=/tools/bin:/bin:/usr/bin

function build_binutils
{
  cd $LFS/sources
  tar xvf binutils-2.30.tar.xz
  cd binutils-2.30

  mkdir -v build
  cd build

  ../configure --prefix=/tools            \
               --with-sysroot=$LFS        \
               --with-lib-path=/tools/lib \
               --target=$LFS_TGT          \
               --disable-nls              \
               --disable-werror

  make -j${CPUS}

  case $(uname -m) in
    x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
  esac

  make install

  cd $LFS/sources
  rm -rf binutils-2.30
}

function build_gcc
{
  cd $LFS/sources

  tar xvf gcc-7.3.0.tar.xz
  cd gcc-7.3.0

  tar xvf ../mpfr-4.0.1.tar.xz
  mv -v mpfr-4.0.1 mpfr
  tar xvf ../gmp-6.1.2.tar.xz
  mv -v gmp-6.1.2 gmp
  tar xvf ../mpc-1.1.0.tar.gz
  mv -v mpc-1.1.0 mpc

  for file in gcc/config/{linux,i386/linux{,64}}.h
do
  cp -uv $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
      -e 's@/usr@/tools@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done

  case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac

  mkdir -v build
  cd build

  ../configure                                       \
    --target=$LFS_TGT                              \
    --prefix=/tools                                \
    --with-glibc-version=2.11                      \
    --with-sysroot=$LFS                            \
    --with-newlib                                  \
    --without-headers                              \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --disable-nls                                  \
    --disable-shared                               \
    --disable-multilib                             \
    --disable-decimal-float                        \
    --disable-threads                              \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libmpx                               \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++

  make -j${CPUS}
  make install

  cd $LFS/sources
  rm -rf gcc-7.3.0
}

function build_linux_headers
{
  cd $LFS/sources
  tar xvf linux-4.15.3.tar.gz
  cd linux-4.15.3

  make mrproper

  make INSTALL_HDR_PATH=dest headers_install -j${CPUS}
  cp -rv dest/include/* /tools/include
}

function build_glibc
{
  cd $LFS/sources
  tar xvf glibc-2.27.tar.xz

  cd glibc-2.27
  mkdir -v build
  cd build

  ../configure                            \
      --prefix=/tools                     \
      --host=$LFS_TGT                     \
      --build=$(../scripts/config.guess)  \
      --enable-kernel=3.2                 \
      --with-headers=/tools/include       \
      libc_cv_forced_unwind=yes           \
      libc_cv_c_cleanup=yes

  make -j${CPUS}
  make install
}

function build_libstdc
{
  cd $LFS/sources
  tar xvf gcc-7.3.0.tar.xz
  cd gcc-7.3.0

  mkdir -v build
  cd build

  ../libstdc++-v3/configure         \
    --host=$LFS_TGT                 \
    --prefix=/tools                 \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-threads     \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/7.3.0
  
  make -j${CPUS}
  make install

  cd $LFS/sources
  rm -rf gcc-7.3.0
}

function build_binutils_again
{
  cd $LFS/sources
  tar xvf binutils-2.30.tar.xz
  cd binutils-2.30

  mkdir -v build
  cd build

  CC=$LFS_TGT-gcc               \
  AR=$LFS_TGT-ar                \
  RANLIB=$LFS_TGT-ranlib        \
  ../configure                  \
    --prefix=/tools             \
    --disable-nls               \
    --disable-werror            \
    --with-lib-path=/tools/lib  \
    --with-sysroot
  
  make -j${CPUS}
  make install

  make -C ld clean
  make -C ld LIB_PATH=/usr/lib:/lib
  cp -v ld/ld-new /tools/bin
}

function build_gcc_again
{
  cd $LFS/sources
  tar xvf gcc-7.3.0.tar.xz
  cd gcc-7.3.0

  cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
    `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h

  for file in gcc/config/{linux,i386/linux{,64}}.h
  do
    cp -uv $file{,.orig}
    sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
        -e 's@/usr@/tools@g' $file.orig > $file
    echo '
  #undef STANDARD_STARTFILE_PREFIX_1
  #undef STANDARD_STARTFILE_PREFIX_2
  #define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
  #define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
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
  cd build

  CC=$LFS_TGT-gcc                                  \
  CXX=$LFS_TGT-g++                                 \
  AR=$LFS_TGT-ar                                   \
  RANLIB=$LFS_TGT-ranlib                           \
  ../configure                                     \
    --prefix=/tools                                \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --enable-languages=c,c++                       \
    --disable-libstdcxx-pch                        \
    --disable-multilib                             \
    --disable-bootstrap                            \
    --disable-libgomp

  make -j${CPUS}
  make install

  ln -sv gcc /tools/bin/cc
}

function build_tcl
{
  cd $LFS/sources
  tar xvf tcl8.6.8-src.tar.gz
  cd tcl8.6.8

  cd unix
  ./configure --prefix=/tools

  make -j${CPUS}

  make install
  chmod -v u+w /tools/lib/libtcl8.6.so

  make install-private-headers

  ln -sv tclsh8.6 /tools/bin/tclsh
}

function build_expect
{
  cd $LFS/sources
  tar xvf expect5.45.4.tar.gz
  cd expect5.45.4

  cp -v configure{,.orig}
  sed 's:/usr/local/bin:/bin:' configure.orig > configure

  ./configure --prefix=/tools       \
              --with-tcl=/tools/lib \
              --with-tclinclude=/tools/include

  make -j${CPUS}
  make SCRIPTS="" install
}

function build_dejagnu
{
  cd $LFS/sources
  tar xvf dejagnu-1.6.1.tar.gz
  cd dejagnu-1.6.1

  ./configure --prefix=/tools

  make install
}

function build_m4
{
  cd $LFS/sources
  tar xvf m4-1.4.18.tar.xz
  cd m4-1.4.18

  ./configure --prefix=/tools
  make -j${CPUS}
  make install
}

function build_ncurses
{
  cd $LFS/sources
  tar xvf ncurses-6.1.tar.gz
  cd ncurses-6.1

  sed -i s/mawk// configure
  ./configure --prefix=/tools \
              --with-shared   \
              --without-debug \
              --without-ada   \
              --enable-widec  \
              --enable-overwrite
  
  make -j${CPUS}
  make install
}

function build_bash
{
  cd $LFS/sources
  tar xvf bash-4.4.18.tar.gz
  cd bash-4.4.18

  ./configure --prefix=/tools \
              --without-bash-malloc
  
  make -j${CPUS}
  make install

  ln -sv bash /tools/bin/sh
}

function build_bison
{
  cd $LFS/sources
  tar xvf bison-3.0.4.tar.xz
  cd bison-3.0.4

  ./configure --prefix=/tools

  make -j${CPUS}
  make install
}

function build_bzip
{
  cd $LFS/sources
  tar xvf bzip2-1.0.6.tar.gz
  cd bzip2-1.0.6
  
  make -j${CPUS}
  make PREFIX=/tools install
}

function build_coreutils
{
  cd $LFS/sources
  tar xvf coreutils-8.29.tar.xz
  cd coreutils-8.29

  FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/tools --enable-install-program=hostname

  make -j${CPUS}
  make install
}

function build_diffutils
{
  cd $LFS/sources
  tar xvf diffutils-3.6.tar.xz
  cd diffutils-3.6

  ./configure --prefix=/tools
  make -j${CPUS}
  make install
}

function build_file
{
  cd $LFS/sources
  tar xvf file-5.32.tar.gz
  cd file-5.32

  ./configure --prefix=/tools
  make -j${CPUS}
  make install
}

function build_findutils
{
  cd $LFS/sources
  tar xvf findutils-4.6.0.tar.gz
  cd findutils-4.6.0

  ./configure --prefix=/tools
  make -j${CPUS}
  make install
}

function build_gawk
{
  cd $LFS/sources
  tar xvf gawk-4.2.0.tar.xz
  cd gawk-4.2.0

  ./configure --prefix=/tools
  make -j${CPUS}
  make install
}

function build_gettext
{
  cd $LFS/sources
  tar xvf gettext-0.19.8.1.tar.xz
  cd gettext-0.19.8.1

  cd gettext-tools
  EMACS="no" ./configure --prefix=/tools --disable-shared

  make -C gnulib-lib
  make -C intl pluralx.c
  make -C src msgfmt
  make -C src msgmerge
  make -C src xgettext

  cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin
}

function build_grep
{
  cd $LFS/sources
  tar xvf grep-3.1.tar.xz
  cd grep-3.1

  ./configure --prefix=/tools
  make -j${CPUS}
  make install
}

function build_gzip
{
  cd $LFS/sources
  tar xvf gzip-1.9.tar.xz
  cd gzip-1.9

  ./configure --prefix=/tools
  make -j${CPUS}
  make install
}

function build_make
{
  cd $LFS/sources
  tar xvf make-4.2.1.tar.bz2
  cd make-4.2.1

  sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c
  ./configure --prefix=/tools \
              --without-guile

  make -j${CPUS}
  make install
}

function build_patch
{
  cd $LFS/sources
  tar xvf patch-2.7.6.tar.xz
  cd patch-2.7.6

  ./configure --prefix=/tools
  make -j${CPUS}
  make install
}

function build_perl
{
  cd $LFS/sources
  tar xvf perl-5.26.1.tar.xz
  cd perl-5.26.1

  sh Configure -des -Dprefix=/tools -Dlibs=-lm
  make -j${CPUS}

  cp -v perl cpan/podlators/scripts/pod2man /tools/bin
  mkdir -pv /tools/lib/perl5/5.26.1
  cp -Rv lib/* /tools/lib/perl5/5.26.1
}

function build_sed
{
  cd $LFS/sources
  tar xvf sed-4.4.tar.xz
  cd sed-4.4

  ./configure --prefix=/tools
  make -j${CPUS}
  make install
}

function build_tar
{
  cd $LFS/sources
  tar xvf tar-1.30.tar.xz
  cd tar-1.30

  FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/tools
  make -j${CPUS}
  make install
}

function build_texinfo
{
  cd $LFS/sources
  tar xvf texinfo-6.5.tar.xz
  cd texinfo-6.5

  ./configure --prefix=/tools
  make -j${CPUS}
  make install
}

function build_util_linux
{
  cd $LFS/sources
  tar xvf util-linux-2.31.1.tar.xz
  cd util-linux-2.31.1

  ./configure --prefix=/tools                \
              --without-python               \
              --disable-makeinstall-chown    \
              --without-systemdsystemunitdir \
              --without-ncurses              \
              PKG_CONFIG=""
  
  make -j${CPUS}
  make install
}

function build_xz
{
  cd $LFS/sources
  tar xvf xz-5.2.3.tar.xz
  cd xz-5.2.3

  ./configure --prefix=/tools
  make -j${CPUS}
  make install
}

build_binutils
build_gcc
build_linux_headers
build_glibc

build_libstdc
build_binutils_again
build_gcc_again

build_tcl
build_expect
build_dejagnu
build_m4
build_ncurses
build_bash
build_bison
build_bzip
build_coreutils
build_diffutils
build_file
build_findutils
build_gawk
build_gettext
build_grep
build_gzip
build_make
build_patch
build_perl
build_sed
build_tar
build_texinfo
build_util_linux
build_xz

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

mv /temp/build_to_bash.sh $LFS/build_to_bash.sh
mv /temp/finish-base.sh $LFS/finish-base.sh
mv /temp/lfs-workstation.sh $LFS/lfs-workstation.sh
cd $LFS
chmod +x build_to_bash.sh
chmod +x finish-base.sh
chmod +X lfs-workstation.sh

chroot "$LFS" /tools/bin/env -i \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h \
    ./build_to_bash.sh