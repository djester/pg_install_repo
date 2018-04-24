#!/bin/bash

PG_VER=${PG_VER:-$1}
[ "${PG_VER}" ] || { echo "ERR: Varible PG_VER is not defined!" >&2; exit 1; }

echo "Install PostgreSQL ${PG_VER}"

mkdir -p /opt/src && cd /opt/src || exit 1

# remove installed from rpm (if exists)
yum -y remove postgresql-libs postgresql postgresql-odbc 

# install dependencies
yum install -y readline-devel libxml2-devel libxslt-devel || exit 1
 
PG_NAME=postgresql-${PG_VER}
PG_TAR=${PG_NAME}.tar.gz
PG_PATH=/opt/${PG_NAME}
PG_SLINK=/opt/postgresql
PG_URL=https://ftp.postgresql.org/pub/source/v${PG_VER}/${PG_TAR}

if [ -e ${PG_PATH} ]; then
  echo "${PG_PATH} exists. May be PostgreSQL ${PG_VER} software was installed before..."
  exit 1
fi

if [ ! -f ${PG_TAR} ]; then
    wget -c ${PG_URL} || exit 1
fi

tar -zxf ${PG_TAR} && \
cd ${PG_NAME} && \
./configure --prefix=${PG_PATH} with_libxml=yes with_libxslt=yes && \
make world -j6 && [ `id -un` = "root" ] && \
make install-world || sudo make install-world || exit 1

if [ -e ${PG_SLINK} ];
then
  echo "${PG_SLINK}  exists. May be PostgreSQL software was installed before..."
  ls -lh /opt/postgresql
  echo "If you want upgrade software, relink it to ${PG_NAME}"
  exit 1
else
  ln -s ${PG_PATH} ${PG_SLINK}  || exit 1
fi

# set PATH to profile enviroment
cat > /etc/profile.d/postgresql.sh <<EOF
export PATH=\$PATH:/opt/postgresql/bin
export MANPATH=\$MANPATH:/opt/postgresql/share/man
export LD_LIBRARY_PATH=/opt/postgresql/lib:\$LD_LIBRARY_PATH
export PSQL_EDITOR="vim"
export PAGER="less"
export LESS="-iMSx4 -FX"
EOF

exit 0

