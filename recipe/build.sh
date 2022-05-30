#!/bin/bash
set -x

mkdir -p ${PREFIX}/etc/openconnect
cp vpnc-scripts/vpnc-script ${PREFIX}/etc/openconnect/vpnc-script
# make sure the script is executable
# see https://www.infradead.org/openconnect/vpnc-script.html
chmod +x ${PREFIX}/etc/openconnect/vpnc-script

if [[ $target_platform == osx-arm64 ]]; then
    # Get an updated config.sub and config.guess
    cp $BUILD_PREFIX/share/gnuconfig/config.* .
fi

./configure \
    --prefix=${PREFIX} \
    --sbindir=${PREFIX}/bin \
    --localstatedir=${PREFIX}/var \
    --with-vpnc-script=${PREFIX}/etc/openconnect/vpnc-script \
##

make -j${CPU_COUNT}
make check
make install
