mkdir -p /opt/src

#Dependences
yum -y install ncurses-devel || exit 1

#libevent 2.0.x
cd /opt/src

yum -y remove libevent libevent-devel libevent-headers || exit 1

. ../config/libevent_install.conf

if [ ! -f $libevent_nametar ]; then
  wget -O ${libevent_nametar} "http://downloads.sourceforge.net/project/levent/libevent/${libevent_name}/${libevent_nametar}" || (echo "${libevent_nametar} not found"; exit 1)
fi

(tar zxf ${libevent_nametar} && cd ${libevent_name1} && ./configure --prefix=/opt/${libevent_name1} && make install && ln -s ${libevent_name1} /opt/libevent) || exit 1

echo /opt/libevent/lib >>/etc/ld.so.conf.d/libevent.conf
ldconfig || exit 1

exit 0

