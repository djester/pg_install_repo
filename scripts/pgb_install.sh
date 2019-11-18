#!/bin/bash

mkdir -p /opt/src && cd /opt/src 

# libevent must install before
[ -d /opt/libevent ] || ( echo "ERROR: libevent must install before!!!" >&2; exit 1 ) 

# install c-ares library as denendence
yum -y install c-ares c-ares-devel

# asquire version from command-line parameter or pre-defined variable
PGB_VER=${PGB_VER:-$1}
[ "${PGB_VER}" ] || { echo "ERROR: Varible PGB_VER is not defined!" >&2; exit 1; }
PGB_GIT_TAG=$(echo ${PGB_VER} | sed 's/^/postgres_/;s/\./_/g')

PGB_NAME=pgbouncer-${PGB_VER}
PGB_PATH=/opt/${PGB_NAME}
PGB_SLINK=/opt/pgbouncer

if [ -e ${PGB_PATH} ]; then
  echo "${PGB_PATH} exists. May be pgbouncer ${PGB_VER} software was installed before..."
  exit 1
fi

# build from git 
cd /git
git clone https://github.com/pgbouncer/pgbouncer.git
cd pgbouncer/
git checkout tags/$PGB_GIT_TAG

<<<<<<< HEAD
# unpack sources and build software 
tar -zxf ${PGB_TAR} && 
(
cd ${PGB_NAME} &&
    ./configure --prefix=${PGB_PATH} --with-libevent=/opt/libevent --with-cares && \
    make && ( [ `id -un` = "root" ] && make install || sudo make install ) 
) || exit 1
=======
git submodule init && \
git submodule update && \
./autogen.sh && \
./configure --prefix=${PGB_PATH} --with-libevent=/opt/libevent --with-cares && \
make && ( [ `id -un` = "root" ] && make install || sudo make install ) 
>>>>>>> 23727984af5dc09789ba20e02ba96a9919d39a04

if [ -e ${PGB_SLINK} ];
then
  echo "${PGB_SLINK}  exists. May be pgbouncer software was installed before..."
  ls -lh ${PGB_SLINK}
  echo "If you want upgrade software, relink it to ${PGB_NAME}"
  exit 1
else
  ln -s ${PGB_PATH} ${PGB_SLINK}  || exit 1
fi

# create directory and set permissions
mkdir /data/pgbouncer /var/run/pgbouncer
chown -R postgres:postgres /var/run/pgbouncer

# set PATH to profile enviroment
cat > /etc/profile.d/pgbouncer.sh <<EOF
export PATH=\$PATH:/opt/pgbouncer/bin
export MANPATH=\$MANPATH:/opt/pgbouncer/share/man
EOF

exit 0

