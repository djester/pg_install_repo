mkdir -p /opt/src

#Dependences
yum -y install ncurses-devel

#libevent 2.0.x
cd /opt/src

yum -y remove libevent libevent-devel libevent-headers

. ./config/libevent_install.conf

wget -O ${libevent_name1}.tar.gz "http://downloads.sourceforge.net/project/levent/libevent/${libevent_name}/${libevent_name1}.tar.gz"
tar zxf ${libevent_name1}.tar.gz && cd ${libevent_name1} && ./configure --prefix=/opt/${libevent_name1} && make install 
ln -s ${libevent_name1} /opt/libevent

echo /opt/libevent/lib >>/etc/ld.so.conf.d/libevent.conf
ldconfig

