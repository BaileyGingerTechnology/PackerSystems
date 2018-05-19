#!/tools/bin/bash
# Author: Bailey Kasin

echo "root user and groups setup"

touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp

function build_linux_headers
{
  cd $LFS/sources
  rm -rf linux-5.15.3
  tar xvf linux-4.15.3.tar.gz
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
  rm -rf zlib-1.2.11
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
  rm -rf file-5.32
  tar xvf file-5.32.tar.gz
  cd file-5.32

  ./configure --prefix=/usr

  make -j${CPUS}
  make install 
}

function build_readline
{
  cd $LFS/sources
  rm -rf readline-7.0
  tar xvf readline-7.0.tar.gz
  cd readline-7.0

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
  rm -rf m4-1.4.18
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
  cd $LFS/sources
  rm -rf binutils-2.30
  tar xvf binutils-2.30.tar.xz
  cd binutils-2.30
  
  expect -c "spawn ls"
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
  rm -rf gmp-6.1.2
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
  rm -rf mpfr-4.0.1
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
  rm -rf mpc-1.1.0
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
  cd gcc-7.3.0
  #rm -rf mpfr gmp mpc

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
  
  cd build
  make -j${CPUS}
  ulimit -s 32768

  make install
  ln -sv ../usr/bin/cpp /lib
  ln -sv gcc /usr/bin/cc
  install -v -dm755 /usr/lib/bfd-plugins
  ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/7.3.0/liblto_plugin.so \
          /usr/lib/bfd-plugins/

  mkdir -pv /usr/share/gdb/auto-load/usr/lib
  mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

  cd $LFS/sources
  rm -R -- */
}

build_zlib
build_file
build_readline
build_m4

cd $LFS/sources
tar xvf bc-1.07.1.tar.gz
cd bc-1.07.1
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
  make install PREFIX=/usr

  if [ -f /bin/bunzip2 ] ; then
    /bin/bunzip2
    /bin/bzcat
  fi

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

function build_attr
{
  cd $LFS/sources
  tar xvf attr-2.4.47.src.tar.gz
  cd attr-2.4.47

  sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
  sed -i -e "/SUBDIRS/s|man[25]||g" man/Makefile
  sed -i 's:{(:\\{(:' test/run

  ./configure --prefix=/usr \
              --bindir=/bin \
              --disable-static
  make -j${CPUS}
  make -j1 tests root-tests

  make install install-dev install-lib
  chmod -v 755 /usr/lib/libattr.so

  mv -v /usr/lib/libattr.so.* /lib
  ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so
}

function build_acl
{
  cd $LFS/sources
  tar xvf acl-2.2.52.src.tar.gz
  cd acl-2.2.52

  sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
  sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test
  sed -i 's/{(/\\{(/' test/run
  sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" \
    libacl/__acl_to_any_text.c

  ./configure --prefix=/usr    \
              --bindir=/bin    \
              --disable-static \
              --libexecdir=/usr/lib
  make -j${CPUS}

  make install install-dev install-lib
  chmod -v 755 /usr/lib/libacl.so
  
  mv -v /usr/lib/libacl.so.* /lib
  ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so
}

function build_libcap
{
  cd $LFS/sources
  tar xvf libcap-2.25.tar.xz
  cd libcap-2.25

  sed -i '/install.*STALIBNAME/d' libcap/Makefile
  make -j${CPUS}

  make RAISE_SETFCAP=no lib=lib prefix=/usr install
  chmod -v 755 /usr/lib/libcap.so

  mv -v /usr/lib/libcap.so.* /lib
  ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so
}

function build_sed
{
  cd $LFS/sources
  tar xvf sed-4.4.tar.xz
  cd sed-4.4

  sed -i 's/usr/tools/'                 build-aux/help2man
  sed -i 's/testsuite.panic-tests.sh//' Makefile.in

  ./configure --prefix=/usr --bindir=/bin

  make -j${CPUS}
  make html

  make install
  install -d -m755           /usr/share/doc/sed-4.4
  install -m644 doc/sed.html /usr/share/doc/sed-4.4
}

function build_shadow
{
  cd  $LFS/sources
  tar xvf shadow-4.5.tar.xz
  cd shadow-4.5

  sed -i 's/groups$(EXEEXT) //' src/Makefile.in
  find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
  find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
  find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

  sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
        -e 's@/var/spool/mail@/var/mail@' etc/login.defs
  
  sed -i 's/1000/999/' etc/useradd
  ./configure --sysconfdir=/etc --with-group-name-max-length=32

  make -j${CPUS}
  make install
  mv -v /usr/bin/passwd /bin

  pwconv
  grpconv
  sed -i 's/yes/no/' /etc/default/useradd

  usermod --password $(echo password123 | openssl passwd -1 -stdin) root
}

function build_psmisc
{
  cd $LFS/sources
  tar xvf psmisc-23.1.tar.xz
  cd psmisc-23.1

  ./configure --prefix=/usr
  make -j${CPUS}
  make install

  mv -v /usr/bin/fuser   /bin
  mv -v /usr/bin/killall /bin
}

function build_iana
{
  cd $LFS/sources
  tar xvf iana-etc-2.30.tar.bz2
  cd iana-etc-2.30

  make -j${CPUS}
  make install
}

function build_bison
{
  cd $LFS/sources
  tar xvf bison-3.0.4.tar.xz
  cd bison-3.0.4

  ./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.0.4
  make -j${CPUS}
  make install
}

function build_flex
{
  cd $LFS/sources
  tar xvf flex-2.6.4.tar.gz
  cd flex-2.6.4

  sed -i "/math.h/a #include <malloc.h>" src/flexdef.h
  HELP2MAN=/tools/bin/true \
  ./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4

  make -j${CPUS}
  make install
  ln -sv flex /usr/bin/lex
}

function build_grep
{
  cd $LFS/sources
  tar xvf grep-3.1.tar.xz
  cd grep-3.1

  ./configure --prefix=/usr --bindir=/bin
  make -j${CPUS}
  make install
}

function build_bash
{
  cd $LFS/sources
  tar xvf bash-4.4.18.tar.gz
  cd bash-4.4.18

  ./configure --prefix=/usr                       \
              --docdir=/usr/share/doc/bash-4.4.18 \
              --without-bash-malloc               \
              --with-installed-readline
  make -j${CPUS}
  chown -Rv nobody .
  su nobody -s /bin/bash -c "PATH=$PATH make tests"

  make install
  mv -vf /usr/bin/bash /bin
}

build_bzip2
build_pkgconfig
build_attr
build_acl
build_libcap
build_sed
build_shadow
build_psmisc
build_iana
build_bison
build_flex
build_grep
build_bash

cd $LFS/sources
rm -R -- */

cd $LFS
exec /bin/bash --login +h $LFS/finish-base.sh