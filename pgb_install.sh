cd /opt/src 
 
# libevent must install before
 
pgb_ver=1.7
pgb_name=pgbouncer-$pgb_ver
pgb_nametar=$pgb_name.tar.gz
if [ ! -f $pgb_nametar ]; then
    wget -c https://pgbouncer.github.io/downloads/files/$pgb_ver/$pgb_nametar
fi
tar -zxf $pgb_nametar && 
(
cd $pgb_name &&
 ./configure --prefix=/opt/$pgb_name --with-libevent=/opt/libevent && make && [ `id -un` = "root" ] && make install || sudo make install 
)
ln -s /opt/$pgb_name /opt/pgbouncer

useradd -r -g postgres -s /bin/bash -d /data/home/pgbouncer -m pgbouncer
mkdir /data/pgbouncer /var/run/pgbouncer
chown -R pgbouncer /var/run/pgbouncer
