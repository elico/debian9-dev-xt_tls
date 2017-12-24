#!/usr/bin/env bash

set -x

cd /build
rm -rf ./xt_tls
if [ -f "master.tar" ]; then
	tar xvf master.tar
else 
	git clone https://github.com/Lochnair/xt_tls
	tar cvf master.tar xt_tls
fi
sed -i -e 's@$(shell uname -r)@$(shell ls /lib/modules/)@g' xt_tls/src/Makefile && \
cd xt_tls && \
make && \
make install && \
echo $?

rm /build/destdir/ -rf
mkdir -p /build/destdir/
chmod 777 /build/destdir/
make install && \
echo $?

mkdir -p /build/destdir/lib/modules/`ls /lib/modules/`/extra/ && \
mkdir -p /build/destdir/usr/lib/x86_64-linux-gnu/xtables/ && \
cp /lib/modules/`ls /lib/modules/`/extra/xt_tls.ko /build/destdir/lib/modules/`ls /lib/modules/`/extra/ && \
cp /usr/lib/x86_64-linux-gnu/xtables/libxt_tls.so /build/destdir/usr/lib/x86_64-linux-gnu/xtables/ && \
echo $?

#find /lib |grep -i ndpi
#mkdir -p /build/destdir/lib/xtables/ && \
#cp /lib/xtables/libxt_NDPI.so /build/destdir/lib/xtables/ && \
#mkdir -p /build/destdir/lib/modules/$KERNEL_VERSION/extra/ && \
#cp /build/nDPI/ndpi-netfilter/src/xt_ndpi.ko /build/destdir/lib/modules/$KERNEL_VERSION/extra/xt_ndpi.ko && \
#cp /build/nDPI/ndpi-netfilter/src/xt_ndpi.ko /build/destdir/lib/modules/$KERNEL_VERSION/extra/xt_ndpi.ko-non-stripped && \
#cd /build/destdir/lib/xtables/ && \
#ln -s libxt_NDPI.so libxt_ndpi.so && \
#echo $?

#strip --strip-debug /build/destdir/lib/modules/$KERNEL_VERSION/extra/xt_ndpi.ko

#modprobe xt_ndpi && lsmod|grep ndpi
#patch -p0 < /build/ipt-makefile.patch && \
#patch -p0 < /build/src-makefile.patch && \

set +x
