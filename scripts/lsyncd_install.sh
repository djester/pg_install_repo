#!/bin/bash

mkdir -p /opt/src & cd /opt/src 

yum install -y cmake lua lua-devel || exit 1

lsyncd_ver=2.1.6 
lsyncd_name=lsyncd-release-${lsyncd_ver}
lsyncd_nametar=${lsyncd_name}.tar.gz

if [ ! -f $lsyncd_nametar ]; then
    wget -O $lsyncd_nametar -c https://github.com/axkibe/lsyncd/archive/release-${lsyncd_ver}.tar.gz || ( echo "ERROR: $lsyncd_nametar not found!!!"; exit 1 )
fi
tar -zxf $lsyncd_nametar && 
(
export DESTDIR="/opt/$lsyncd_name" && cd $lsyncd_name && cmake . && make && make install  && ln -s /opt/$lsyncd_name /opt/lsyncd
) || exit 1
 
mkdir -p /var/log/lsyncd

exit 0

