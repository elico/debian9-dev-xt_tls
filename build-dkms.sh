#!/usr/bin/env bash
set -x
set -e

rm /var/lib/dkms/xt_tls/ -rf
rm /usr/src/xt_tls-1.0.0/ -rf
grep 'Architecture: all' /etc/dkms/template-dkms-mkdeb/debian/control
if [ "$?" -eq "0" ];then
   sed -i -e 's@Architecture: all@Architecture: DEBIAN_BUILD_ARCH@g' /etc/dkms/template-dkms-mkdeb/debian/control
fi

tar xvf /build/master.tar -C /usr/src
mv /usr/src/xt_tls /usr/src/xt_tls-1.0.0
cd /usr/src/xt_tls-1.0.0
sed -i -e 's@$(shell uname -r)@$(shell ls /lib/modules/)@g' src/Makefile
cp /build/dkms.conf /usr/src/xt_tls-1.0.0/
dkms add -m xt_tls -v 1.0.0
dkms build -m xt_tls -v 1.0.0 -k `ls /lib/modules/`
dkms mkdsc -m xt_tls -v 1.0.0 --source-only -k `ls /lib/modules/`
dkms mkdeb -m xt_tls -v 1.0.0 -k `ls /lib/modules/`
cd -

#updatedb
#locate xt_tls|grep deb
cp /var/lib/dkms/xt_tls/1.0.0/deb/xt-tls-dkms_1.0.0_amd64.deb /build/destdir/

set +x
set +
