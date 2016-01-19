#!/bin/bash

mkdir -p /opt/src && cd /opt/src 

# . ../config/pg_install.conf 
# libevent must install before
[ -d /opt/libevent ] || ( echo "ERROR: libevent must install before!!!"; exit 1 ) 
pgb_ver=1.7
pgb_name=pgbouncer-$pgb_ver
pgb_nametar=${pgb_name}.tar.gz
if [ ! -f $pgb_nametar ]; then
    wget -c https://pgbouncer.github.io/downloads/files/$pgb_ver/$pgb_nametar || exit 1
fi
tar -zxf $pgb_nametar && 
(
cd $pgb_name &&
 ./configure --prefix=/opt/$pgb_name --with-libevent=/opt/libevent && make && ( [ `id -un` = "root" ] && make install || sudo make install ) && ln -s /opt/$pgb_name /opt/pgbouncer 
) || exit 1

useradd -r -g postgres -s /bin/bash -d $PG_HOME -m pgbouncer || exit 1
mkdir /data/pgbouncer /var/run/pgbouncer
chown -R pgbouncer /var/run/pgbouncer

exit 0

