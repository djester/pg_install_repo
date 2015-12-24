#!/bin/bash

mkdir -p /opt/src & cd /opt/src 

lsyncd_ver=2.1.6 
lsyncd_name=lsyncd-${lsyncd_ver}
lsyncd_nametar=${lsyncd_name}.tar.gz
if [ ! -f $lsyncd_nametar ]; then
    wget -O $lsyncd_nametar -c https://github.com/axkibe/lsyncd/archive/release-${lsyncd_ver}.tar.gz || ( echo "ERR: $lsyncd_nametar not found!!!"; exit 1 )
fi
tar -zxf $lsyncd_nametar && 
(
cd $lsyncd_name &&
./configure --prefix=/opt/$lsyncd_name && make && ( [ `id -un` = "root" ] && make install || sudo make install ) && ln -s /opt/$lsyncd_name /opt/lsyncd
) || exit 1
 
mkdir -p /var/log/lsyncd

exit 0

