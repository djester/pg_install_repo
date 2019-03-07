#!/bin/bash

mkdir -p /opt/src && cd /opt/src 

# libevent must install before
[ -d /opt/libevent ] || ( echo "ERROR: libevent must install before!!!" >&2; exit 1 ) 

# asquire version from command-line parameter or pre-defined variable
TARGET_DIR=${TARGET_DIR:-$1}
PGB_VER=${PGB_VER:-$2}
[ "${PGB_VER}" ] || { echo "ERROR: Varible PGB_VER is not defined!" >&2; exit 1; }

# download sources
pgb_name=pgbouncer-$PGB_VER
pgb_nametar=${pgb_name}.tar.gz
if [ ! -f $pgb_nametar ]; then
    wget -c https://pgbouncer.github.io/downloads/files/$PGB_VER/$pgb_nametar || exit 1
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
#PG_HOME=${PG_HOME:-${TARGET_DIR}/home}
#[ -d $PG_HOME ] || mkdir -p $PG_HOME || exit 1
#useradd -r -g postgres -s /bin/bash -d $PG_HOME/pgbouncer -m -k /etc/skel pgbouncer || exit 1
mkdir /data/pgbouncer /var/run/pgbouncer
#chown -R pgbouncer:postgres /var/run/pgbouncer
chown -R postgres:postgres /var/run/pgbouncer

# set PATH to profile enviroment
cat > /etc/profile.d/pgbouncer.sh <<EOF
export PATH=\$PATH:/opt/pgbouncer/bin
export MANPATH=\$MANPATH:/opt/pgbouncer/share/man
EOF

exit 0

