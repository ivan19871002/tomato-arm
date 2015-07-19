#!/bin/sh
SRC=/home/tomato-arm/release/src-rt-6.x.4708
sudo ln -sf $SRC/toolchains/hndtools-arm-linux-2.6.36-uclibc-4.5.3 /opt/hndtools-arm-linux-2.6.36-uclibc-4.5.3
sudo ln -sf $SRC/toolchains/hndtools-arm-linux-2.6.36-uclibc-4.5.3 /projects/hnd/tools/linux/hndtools-arm-linux-2.6.36-uclibc-4.5.3
sudo ln -sf /usr/lib/libmpc.so.3 /usr/lib/libmpc.so.2
export PATH=$PATH:/opt/hndtools-arm-linux-2.6.36-uclibc-4.5.3/bin
export LANG=c
cd $SRC
# echo " ---- Update sources from GIT ---- "
# git pull
EXTENDNO=`git rev-parse --verify HEAD --short`

# Huawei build
sed -ie "s|HUAWEI = 0|HUAWEI = 1|" $SRC/router/wwwAT/Makefile
sed -ie "s|XIAOMI = 1|XIAOMI = 0|" $SRC/router/wwwAT/Makefile
#make V1=ML- V2=$EXTENDNO ws880e
make V1=ML- V2=$EXTENDNO ws880z
#make V1=ML- V2=$EXTENDNO ws880zz

# Xiaomi build
#sed -ie "s|HUAWEI = 1|HUAWEI = 0|" $SRC/router/wwwAT/Makefile
#sed -ie "s|XIAOMI = 0|XIAOMI = 1|" $SRC/router/wwwAT/Makefile
#make V1=ML- V2=$EXTENDNO r1dz

