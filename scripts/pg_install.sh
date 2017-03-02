#!/bin/bash

PG_VER=${PG_VER:-$1}
[ "${PG_VER}" ] || { echo "ERR: Varible PG_VER is not defined!" >&2; exit 1; }

echo "Install PostgreSQL $PG_VER"

mkdir -p /opt/src && cd /opt/src || exit 1

# remove installed from rpm (if exists)
yum -y remove postgresql-libs postgresql postgresql-odbc 

# install dependencies
yum install -y readline-devel libxml2-devel libxslt-devel || exit 1
 
pg_name=postgresql-$PG_VER
pg_nametar=$pg_name.tar.gz

if [ -e /opt/$pg_name ]; then
  echo "/opt/$pg_name exists. May be PostgreSQL $PG_VER software was installed before..."
  exit 1
fi

if [ ! -f $pg_nametar ]; then
    wget -c https://ftp.postgresql.org/pub/source/v${PG_VER}/postgresql-${PG_VER}.tar.gz || exit 1
fi

tar -zxf $pg_nametar && \
cd $pg_name && \
./configure --prefix=/opt/$pg_name with_libxml=yes with_libxslt=yes && \
make world -j6 && [ `id -un` = "root" ] && \
make install-world || sudo make install-world || exit 1

if [ -e /opt/postgresql ];
then
  echo "/opt/postgresql exists. May be PostgreSQL software was installed before..."
  ls -lh /opt/postgresql
  echo "If you want upgrade software, relink it to $pg_name"
  exit 1
else
  ln -s $pg_name /opt/postgresql || exit 1
fi

# set PATH to profile enviroment
cat > /etc/profile.d/postgresql.sh <<EOF
export PATH=\$PATH:/opt/postgresql/bin
export MANPATH=\$MANPATH:/opt/postgresql/share/man
EOF

exit 0

