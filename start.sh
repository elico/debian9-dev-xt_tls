#!/usr/bin/env bash

set -e
set -x

if [ "$1" == "no-cache" ]; then
  docker build --no-cache -t local/debian9-ndpi .
else
  docker build -t local/debian9-ndpi .
fi

rm ./destdir -rf

docker run -i -t -v `pwd`:/build/ local/debian9-ndpi /build/build.sh

cd destdir
tar cvfJ xt_tls.tar.xz ./*
tar tvf xt_tls.tar.xz
cd -

docker run -i -t -v `pwd`:/build/ local/debian9-ndpi /build/build-dkms.sh


set +x
