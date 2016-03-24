#!/bin/sh
SRC=`pwd`/release/src-rt-6.x.4708

#
# TOOLCHAIN:
#
sudo ln -sf $SRC/toolchains/hndtools-arm-linux-2.6.36-uclibc-4.5.3 /opt/hndtools-arm-linux-2.6.36-uclibc-4.5.3
#sudo mkdir -p /projects/hnd/tools/linux
#sudo ln -sf $SRC/toolchains/hndtools-arm-linux-2.6.36-uclibc-4.5.3 /projects/hnd/tools/linux/hndtools-arm-linux-2.6.36-uclibc-4.5.3

# SuSE x64 32bit libs for toolchain
# sudo zypper install libelf1-32bit
# sudo ln -sf /usr/lib/libmpc.so.3 /usr/lib/libmpc.so.2

# Ubuntu 14.04 LTS x64 32bit libs for toolchain
# sudo apt-get install libelf1:i386 zlib1g:i386

export PATH=$PATH:/opt/hndtools-arm-linux-2.6.36-uclibc-4.5.3/bin
export LANG=C
export LC_ALL=en_US.UTF-8
cd $SRC
# echo " ---- Update sources from GIT ---- "
# git pull

### VERSION
VER="135-ML"
export BUILDNR="0135"
EXTENDNO=`git rev-parse --verify HEAD --short`
# 1337
echo "1336" > linux/linux-2.6/.version

# UNBRANDING
sed -i "s|HUAWEI = 1|HUAWEI = 0|" $SRC/router/wwwAT/Makefile
sed -i "s|XIAOMI = 1|XIAOMI = 0|" $SRC/router/wwwAT/Makefile

# CLEAN
make clean

#
# TARGETS (see release/src-rt-6.x.4708/Makefile):
#

# Huawei build
# make V1=$VER- V2=$EXTENDNO ws880e	# VPN
# make V1=$VER- V2=$EXTENDNO ws880z	# AIO
# make V1=$VER- V2=$EXTENDNO ws880zz	# AIO Custom (no NGINX and SNMP)

# Xiaomi build
# make V1=ML-$VER- V2=$EXTENDNO r1dz	# AIO Custom EX

# Netgear build
# make V1=ML-$VER- V2=$EXTENDNO r7000init	# AIO initial

# ETC...
