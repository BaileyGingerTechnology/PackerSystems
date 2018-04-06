#!/tools/bin/bash
# Author: Bailey Kasin

echo "In chroot"

mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}
install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -v /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -v /usr/libexec
mkdir -pv /usr/{,local/}share/man/man{1..8}

case $(uname -m) in
  x86_64) mkdir -v /lib64 ;;
esac

mkdir -v /var/{log,mail,spool}
ln -sv /run /var/run
ln -sv /run/lock /var/lock
mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local}

ln -sv /tools/bin/{bash,cat,dd,echo,ln,pwd,rm,stty} /bin
ln -sv /tools/bin/{install,perl} /usr/bin
ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib
ln -sv /tools/lib/libstdc++.{a,so{,.6}} /usr/lib
ln -sv bash /bin/sh
ln -sv /proc/self/mounts /etc/mtab

cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF

cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
systemd-journal:x:23:
input:x:24:
mail:x:34:
nogroup:x:99:
users:x:999:
EOF

touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp

function build_linux_headers
{
  cd $LFS/sources
  cd linux-4.15.3

  make mrproper

  make INSTALL_HDR_PATH=dest headers_install -j${CPUS}
  find dest/include \( -name .install -o -name ..install.cmd \) -delete
  cp -rv dest/include/* /usr/include
}

function build_man_pages
{
  cd $LFS/sources
  tar xvf man-pages-4.15.tar.xz
  cd man-pages-4.15

  make install
}

function build_glibc
{
  cd $LFS/sources
  rm -rf glibc-2.27
  tar xvf glibc-2.27.tar.xz

  cd glibc-2.27
  patch -Np1 -i ../glibc-2.27-fhs-1.patch
  ln -sfv /tools/lib/gcc /usr/lib

  case $(uname -m) in
    i?86)   GCC_INCDIR=/usr/lib/gcc/$(uname -m)-pc-linux-gnu/7.3.0/include
            ln -sfv ld-linux.so.2 /lib/ld-lsb.so.3
    ;;
    x86_64) GCC_INCDIR=/usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/include
            ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3
    ;;
  esac
  rm -f /usr/include/limits.h

  mkdir -v build
  cd build

  CC="gcc -isystem $GCC_INCDIR -isystem /usr/include" \
  ../configure --prefix=/usr                          \
              --disable-werror                       \
              --enable-kernel=3.2                    \
              --enable-stack-protector=strong        \
              libc_cv_slibdir=/lib
  unset GCC_INCDIR

  make -j${CPUS}
  touch /etc/ld.so.conf
  sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile

  make install

  cp -v ../nscd/nscd.conf /etc/nscd.conf
  mkdir -pv /var/cache/nscd

  mkdir -pv /usr/lib/locale
  localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
  localedef -i de_DE -f ISO-8859-1 de_DE
  localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
  localedef -i de_DE -f UTF-8 de_DE.UTF-8
  localedef -i en_GB -f UTF-8 en_GB.UTF-8
  localedef -i en_HK -f ISO-8859-1 en_HK
  localedef -i en_PH -f ISO-8859-1 en_PH
  localedef -i en_US -f ISO-8859-1 en_US
  localedef -i en_US -f UTF-8 en_US.UTF-8
  localedef -i es_MX -f ISO-8859-1 es_MX
  localedef -i fa_IR -f UTF-8 fa_IR
  localedef -i fr_FR -f ISO-8859-1 fr_FR
  localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
  localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
  localedef -i it_IT -f ISO-8859-1 it_IT
  localedef -i it_IT -f UTF-8 it_IT.UTF-8
  localedef -i ja_JP -f EUC-JP ja_JP
  localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
  localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
  localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
  localedef -i zh_CN -f GB18030 zh_CN.GB18030
}

build_linux_headers
build_man_pages
build_glibc

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

tar -xf ../../tzdata2018c.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward pacificnew systemv; do
    zic -L /dev/null   -d $ZONEINFO       -y "sh yearistype.sh" ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}
    zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/Los_Angeles
unset ZONEINFO

cp -v /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF

cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF
mkdir -pv /etc/ld.so.conf.d

mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld

gcc -dumpspecs | sed -e 's@/tools@@g'                   \
    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
    `dirname $(gcc --print-libgcc-file-name)`/specs

echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
grep -B1 '^ /usr/include' dummy.log
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
grep "/lib.*/libc.so.6 " dummy.log
grep found dummy.log
rm -v dummy.c a.out dummy.log

function build_zlib
{
  cd $LFS/sources
  tar xvf zlib-1.2.11.tar.xz
  cd zlib-1.2.11

  ./configure --prefix=/usr

  make -j${CPUS}
  make install

  mv -v /usr/lib/libz.so.* /lib
  ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so
}

function build_file
{
  cd $LFS/sources
  tar xvf file-5.32.tar.gz
  cd file-5.32

  ./configure --prefix=/usr

  make -j${CPUS}
  make install 
}

function build_readline
{
  sed -i '/MV.*old/d' Makefile.in
  sed -i '/{OLDSUFF}/c:' support/shlib-install

  ./configure --prefix=/usr    \
              --disable-static \
              --docdir=/usr/share/doc/readline-7.0

  make -j${CPUS} SHLIB_LIBS="-L/tools/lib -lncursesw"
  make SHLIB_LIBS="-L/tools/lib -lncurses" install

  mv -v /usr/lib/lib{readline,history}.so.* /lib
  ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so
  ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so
}

function build_m4
{
  cd $LFS/sources
  tar xvf m4-1.4.18.tar.xz
  cd m4-1.4.18

  ./configure --prefix=/usr
  make -j${CPUS}
  make install
}

function build_bc
{
  ln -sv /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
  ln -sfv libncurses.so.6 /usr/lib/libncurses.so
  sed -i -e '/flex/s/as_fn_error/: ;; # &/' configure

  ./configure --prefix=/usr           \
              --with-readline         \
              --mandir=/usr/share/man \
              --infodir=/usr/share/info
  
  make -j${CPUS}
  make install
}

function build_binutils
{
  expect -c "spawn ls"

  cd $LFS/sources
  tar xvf binutils-2.30.tar.xz
  cd binutils-2.30

  mkdir -v build
  cd build

  ../configure --prefix=/usr       \
              --enable-gold       \
              --enable-ld=default \
              --enable-plugins    \
              --enable-shared     \
              --disable-werror    \
              --enable-64-bit-bfd \
              --with-system-zlib
  
  make -j${CPUS} tooldir=/usr
  make tooldir=/usr install
}

function build_gmp
{
  cd $LFS/sources
  tar xvf gmp-6.1.2.tar.xz
  cd gmp-6.1.2

  cp -v configfsf.guess config.guess
  cp -v configfsf.sub   config.sub

  ./configure --prefix=/usr    \
              --enable-cxx     \
              --disable-static \
              --docdir=/usr/share/doc/gmp-6.1.2

  make -j${CPUS}
  make html

  make install
  make install-html
}

function build_mpfr
{
  cd $LFS/sources
  tar xvf mpfr-4.0.1.tar.xz
  cd mpfr-4.0.1

  ./configure --prefix=/usr        \
              --disable-static     \
              --enable-thread-safe \
              --docdir=/usr/share/doc/mpfr-4.0.1
  
  make -j${CPUS}
  make html

  make install
  make install-html
}

function build_mpc
{
  cd $LFS/sources
  tar xvf mpc-1.1.0.tar.gz
  cd mpc-1.1.0

  ./configure --prefix=/usr    \
              --disable-static \
              --docdir=/usr/share/doc/mpc-1.1.0

  make -j${CPUS}
  make html

  make install
  make install-html
}

function build_gcc
{
  cd $LFS/sources
  tar xvf gcc-7.3.0.tar.xz
  cd gcc-7.3.0
  mkdir -v build
  cd build

  case $(uname -m) in
    x86_64)
      sed -e '/m64=/s/lib64/lib/' \
          -i.orig gcc/config/i386/t-linux64
    ;;
  esac
  rm -f /usr/lib/gcc

  SED=sed                               \
  ../configure --prefix=/usr            \
               --enable-languages=c,c++ \
               --disable-multilib       \
               --disable-bootstrap      \
               --with-system-zlib
  
  make -j${CPUS}
  ulimit -s 32768
  make -k check

  make install
  ln -sv ../usr/bin/cpp /lib
  ln -sv gcc /usr/bin/cc
  install -v -dm755 /usr/lib/bfd-plugins
  ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/7.3.0/liblto_plugin.so \
          /usr/lib/bfd-plugins/

  mkdir -pv /usr/share/gdb/auto-load/usr/lib
  mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
}

cat > bc/fix-libmath_h << "EOF"
#! /bin/bash
sed -e '1   s/^/{"/' \
    -e     's/$/",/' \
    -e '2,$ s/^/"/'  \
    -e   '$ d'       \
    -i libmath.h

sed -e '$ s/$/0}/' \
    -i libmath.h
EOF

build_zlib
build_file
build_readline
build_m4
build_bc
build_binutils
build_gmp
build_mpfr
build_mpc
build_gcc

function build_bzip2
{
  cd $LFS/sources
  tar xvf bzip2-1.0.6.tar.gz
  cd bzip2-1.0.6

  patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch
  sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
  sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

  make -f Makefile-libbz2_so
  make clean

  make -j${CPUS}
  make PREFIX=/usr install

  cp -v bzip2-shared /bin/bzip2
  cp -av libbz2.so* /lib
  ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
  rm -v /usr/bin/{bunzip2,bzcat,bzip2}
  ln -sv bzip2 /bin/bunzip2
  ln -sv bzip2 /bin/bzcat
}

function build_pkgconfig
{
  cd $LFS/sources
  tar xvf pkg-config-0.29.2.tar.gz
  cd pkg-config-0.29.2

  ./configure --prefix=/usr              \
              --with-internal-glib       \
              --disable-host-tool        \
              --docdir=/usr/share/doc/pkg-config-0.29.2
  
  make -j${CPUS}
  make install
}

function build_ncurses
{
  cd $LFS/sources
  tar xvf ncurses-6.1.tar.gz
  cd ncurses-6.1

  sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
  ./configure --prefix=/usr           \
              --mandir=/usr/share/man \
              --with-shared           \
              --without-debug         \
              --without-normal        \
              --enable-pc-files       \
              --enable-widec
  
  make -j${CPUS}
  make install

  mv -v /usr/lib/libncursesw.so.6* /lib
  ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so

  for lib in ncurses form panel menu ; do
    rm -vf                    /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
  done

  rm -vf                     /usr/lib/libcursesw.so
  echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
  ln -sfv libncurses.so      /usr/lib/libcurses.so
  mkdir -v       /usr/share/doc/ncurses-6.1
  cp -v -R doc/* /usr/share/doc/ncurses-6.1
}