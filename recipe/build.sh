#!/bin/bash
set -x

mkdir -p ${PREFIX}/etc/openconnect
cp vpnc-scripts/vpnc-script ${PREFIX}/etc/openconnect/vpnc-script
# make sure the script is executable
# see https://www.infradead.org/openconnect/vpnc-script.html
chmod +x ${PREFIX}/etc/openconnect/vpnc-script

if [[ $CONDA_BUILD_CROSS_COMPILATION == "1" ]]; then
    # Get an updated config.sub and config.guess
    cp $BUILD_PREFIX/share/gnuconfig/config.* .
    # Workaround: disable language support as we can't run msgfmt
    no_nls="--disable-nls"
else
    no_nls=""
fi

./configure \
    --prefix=${PREFIX} \
    --sbindir=${PREFIX}/bin \
    --localstatedir=${PREFIX}/var \
    --with-vpnc-script=${PREFIX}/etc/openconnect/vpnc-script \
    $no_nls \
##

make -j${CPU_COUNT}
if [[ $CONDA_BUILD_CROSS_COMPILATION != "1" ]]; then
    make check
fi
make install
