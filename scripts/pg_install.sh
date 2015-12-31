#!/bin/bash

###############################################################################################################
#
# PostgreSQL install script
# by Dmitry E. Kremer
# v.0.0.6 2015-12-23
#
###############################################################################################################

. ../config/pg_install.conf

echo "Install PostgreSQL $PG_VER"
echo "Press ENTER to start..."
read -s -n 1

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

###############################################################################################################

echo "Create user postgres with credentials"
echo "Press ENTER to start..."
read -s -n 1
# Create group with system GUID
groupadd -r postgres
# Create user with system UID and with home directory
useradd -r -g postgres -s /bin/bash -d $PG_HOME/postgres -m -k /etc/skel postgres || exit 1
mkdir -p $PGDATA $PGLOG $PGARCH $PGWAL
chown -R postgres:postgres $PGDATA $PGLOG $PGWAL
chmod 0700 $PGDATA
 
###############################################################################################################

echo "Initialize DB server"
echo "Press ENTER to start..."
read -s -n 1

cr_db_cmd="/opt/postgresql/bin/initdb -D ${PGDATA} -E ${PG_ENCODING} --locale=${PG_LC} --lc-collate=${PG_LC} --lc-ctype=${PG_LC}"
su postgres -c ${cr_db_cmd} || exit 1

exit 0

