#!/bin/bash

echo "Install PostgreSQL $PG_VER"

mkdir -p /opt/src && cd /opt/src || exit 1
# remove installed from rpm (if exists)
yum -y remove postgresql-libs postgresql postgresql-odbc 
# install dependencies
yum install -y readline-devel libxml2-devel libxslt-devel || exit 1
 
pg_name=postgresql-$PG_VER
pg_nametar=$pg_name.tar.gz
if [ ! -f $pg_nametar ]; then
    wget -c https://ftp.postgresql.org/pub/source/v${PG_VER}/postgresql-${PG_VER}.tar.gz || exit 1
fi
tar -zxf $pg_nametar && 
(
cd $pg_name &&
./configure --prefix=/opt/$pg_name with_libxml=yes with_libxslt=yes && make world -j6 && [ `id -un` = "root" ] && make install-world || sudo make install-world
ln -s $pg_name /opt/postgresql
) || exit 1

# set PATH to profile enviroment
cat > /etc/profile.d/postgresql.sh <<EOF
export PATH=\$PATH:/opt/postgresql/bin
export MANPATH=\$MANPATH:/opt/postgresql/share/man
EOF

exit 0

