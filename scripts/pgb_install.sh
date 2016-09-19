#!/bin/bash

mkdir -p /opt/src && cd /opt/src 

# . ../config/pg_install.conf 
# libevent must install before
[ -d /opt/libevent ] || ( echo "ERROR: libevent must install before!!!" >&2; exit 1 ) 

# asquire version from command-line parameter or pre-defined variable
pgb_ver=${pgb_ver:-$1}
[ "${pgb_ver}" ] || { echo "ERROR: Varible pgb_ver is not defined!" >&2; exit 1; }

# download sources
pgb_name=pgbouncer-$pgb_ver
pgb_nametar=${pgb_name}.tar.gz
if [ ! -f $pgb_nametar ]; then
    wget -c https://pgbouncer.github.io/downloads/files/$pgb_ver/$pgb_nametar || exit 1
fi

# unpack sources and build software 
tar -zxf $pgb_nametar && 
(
cd $pgb_name &&
    ./configure --prefix=/opt/$pgb_name --with-libevent=/opt/libevent && \
    make && ( [ `id -un` = "root" ] && make install || sudo make install ) && \
    ( [ -h /opt/pgbouncer ] || ln -s /opt/$pgb_name /opt/pgbouncer )
) || exit 1

#create user and set permissions
[ "$PG_HOME" ] || PG_HOME=/data
[ -d $PG_HOME ] || mkdir -p $PG_HOME || exit 1
useradd -r -g postgres -s /bin/bash -d $PG_HOME/pgbouncer -m -k /etc/skel pgbouncer || exit 1
mkdir /data/pgbouncer /var/run/pgbouncer
chown -R pgbouncer:postgres /var/run/pgbouncer

exit 0

