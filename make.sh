#!/bin/sh
SRC=/home/tomato-arm/release/src-rt-6.x.4708
sudo ln -sf $SRC/toolchains/hndtools-arm-linux-2.6.36-uclibc-4.5.3 /opt/hndtools-arm-linux-2.6.36-uclibc-4.5.3
export PATH=$PATH:/opt/hndtools-arm-linux-2.6.36-uclibc-4.5.3/bin
export LANG=c
cd $SRC
echo " ---- Update sources from GIT ---- "
git pull
EXTENDNO=`git rev-parse --verify HEAD --short`
make V1=GIT V2=$EXTENDNO ws880z
#make V1=$EXTENDNO ws880e

