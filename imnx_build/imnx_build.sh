#!/bin/bash

SHARED=""
STATIC=""
SUDO=""
TRIGGER_DODIRS="0"
TRIGGER_DOIMNX="0"

for every in $@; do
case $every in
  -gcc47) CC="/usr/bin/gcc-4.7" CXX="/usr/bin/g++-4.7" RANLIB="/usr/bin/gcc-ranlib-4.7" AR="/usr/bin/gcc-ar-4.7" NM="/usr/bin/gcc-nm-4.7" CCGO="/usr/bin/gccgo-4.7" ;;
  -gcc48) CC="/usr/bin/gcc-4.8" CXX="/usr/bin/g++-4.8" RANLIB="/usr/bin/gcc-ranlib-4.8" AR="/usr/bin/gcc-ar-4.8" NM="/usr/bin/gcc-nm-4.8" CCGO="/usr/bin/gccgo-4.8" ;;
  -gcc49) CC="/usr/bin/gcc-4.9" CXX="/usr/bin/g++-4.9" RANLIB="/usr/bin/gcc-ranlib-4.9" AR="/usr/bin/gcc-ar-4.9" NM="/usr/bin/gcc-nm-4.9" CCGO="/usr/bin/gccgo-4.9" ;;
  -gcc5) CC="/usr/bin/gcc-5" CXX="/usr/bin/g++-5" RANLIB="/usr/bin/gcc-ranlib-5" AR="/usr/bin/gcc-ar-5" NM="/usr/bin/gcc-nm-5" CCGO="/usr/bin/gccgo-5" ;;
  -gcc6) CC="/usr/bin/gcc-6" CXX="/usr/bin/g++-6" RANLIB="/usr/bin/gcc-ranlib-6" AR="/usr/bin/gcc-ar-6g" NM="/usr/bin/gcc-nm-6" CCGO="/usr/bin/gccgo-6" ;;
  -default-gcc) CC="/usr/bin/gcc" CXX="/usr/bin/g++" RANLIB="/usr/bin/gcc-ranlib" AR="/usr/bin/gcc-ar" NM="/usr/bin/gcc-nm" CCGO="/usr/bin/gccgo" ;;
  -shared) SHARED="--enable-shared" ;;
  -static) STATIC="--enable-static" ;;
  -sudo) SUDO="/usr/bin/sudo" ;;
  -dirmode) TRIGGER_DODIRS="1" ;;
  -curdir) TRIGGER_DOIMNX="1" ;;
  *) printf "No GCC version argument supplied, using \'Default\'.\n" ;;
esac
done
ARCH="x86_64"
OPTIMIZE="-O3" # O3, O2, O1, Os. = Different presets.
BUILD_HOST_TARGET="x86_64-pc-linux-gnu"
MARCH="haswell"
#MARCH="core-avx2"

#EXTRA_FLAGS="-mavx -mavx2"
EXTRA_FLAGS=""

NATIVE_FLAGS="-march=$MARCH -mmmx -mno-3dnow -msse -msse2 -msse3 -mssse3 -mno-sse4a -mcx16 -msahf -mmovbe -maes -mno-sha -mpclmul -mpopcnt -mabm -mno-lwp -mfma -mno-fma4 -mno-xop -mbmi -mbmi2 -mno-tbm -mavx -mavx2 -msse4.2 -msse4.1 -mlzcnt -mno-rtm -mno-hle -mrdrnd -mf16c -mfsgsbase -mno-rdseed -mno-prfchw -mno-adx -mfxsr -mxsave -mxsaveopt -mno-avx512f -mno-avx512er -mno-avx512cd -mno-avx512pf -mno-prefetchwt1 -mno-clflushopt -mno-xsavec -mno-xsaves -mno-avx512dq -mno-avx512bw -mno-avx512vl -mno-avx512ifma -mno-avx512vbmi -mno-clwb -mno-pcommit -mno-mwaitx --param l1-cache-size=32 --param l1-cache-line-size=64 --param l2-cache-size=6144 -mtune=$MARCH -fstack-protector-strong -Wformat -Wformat-security $EXTRA_FLAGS"

CFLAGS="$NATIVE_FLAGS $OPTIMIZE -pipe" 
CXXFLAGS="$NATIVE_FLAGS $OPTIMIZE -pipe"

# All the good stuff starts here. ;)

#$SUDO make clean
#$SUDO make distclean
#$SUDO ./configure --prefix=/usr $SHARED $STATIC && $SUDO make && $SUDO make install

function dirMode () {
  printf "Directory mode selected (--dir-mode).\n"
  for every in `find * -maxdepth 0 -type d`; do 
  cd $every
    make clean
    touch ../$(basename $PWD).clean
    make distclean
    touch ../$(basename $PWD).distclean
    if [[ -e "./configure" ]]; then
      if [[ -f "./configure" ]]; then
        if [[ -x "./configure" ]]; then
          touch ../$(basename $PWD).configure
          ./configure --prefix=/usr $SHARED $STATIC && make && make install
        fi
      fi
    else
      if [[ -e "./autogen.sh" ]]; then
        if [[ -f "./autogen.sh" ]]; then
          if [[ -x "./autogen.sh" ]]; then
            ../$(basename $PWD).autogen
            ./autogen.sh --prefix=/usr $SHARED $STATIC
            if [[ -e "./configure" ]]; then
              if [[ -f "./configure" ]]; then
                if [[ -x "./configure" ]]; then
                  touch ../$(basename $PWD).configure
                  ./configure --prefix=/usr $SHARED $STATIC && make && make install
                fi
              fi
            fi
          fi
        fi
      fi
    fi
  cd ..
done
}

function curdirMode () {
  printf "Current directory mode selected. --curdir-mode\n"
  make clean
  touch ../$(basename $PWD).clean
  make distclean
  touch ../$(basename $PWD).distclean
  if [[ -e "./configure" ]]; then
    if [[ -f "./configure" ]]; then
      if [[ -x "./configure" ]]; then
        touch ../$(basename $PWD).configure
        ./configure --prefix=/usr $SHARED $STATIC && make && make install
      fi
    fi
  else
    if [[ -e "./autogen.sh" ]]; then
      if [[ -f "./autogen.sh" ]]; then
        if [[ -x "./autogen.sh" ]]; then
          ../$(basename $PWD).autogen
          ./autogen.sh --prefix=/usr $SHARED $STATIC
          if [[ -e "./configure" ]]; then
            if [[ -f "./configure" ]]; then
              if [[ -x "./configure" ]]; then
                touch ../$(basename $PWD).configure
                ./configure --prefix=/usr $SHARED $STATIC && make && make install
              fi
            fi
          fi
        fi
      fi
    fi
  fi
}

if [[ $TIGGER_DODIRS == "1" ]]; then
  TRIGGER_DODIRS="0"
  dirMode
fi

if [[ $TRIGGER_DOIMNX == "1" ]]; then
  TRIGGER_DOIMNX="0"
  curdirMode
fi
