mkdir -p /opt/src

#Dependences
yum -y install ncurses-devel || exit 1

#libevent 2.1.x
cd /opt/src

yum -y remove libevent2 libevent2-devel libevent2-doc libevent-headers || exit 1

libevent_ver=2.1
libevent_ver_full=${libevent_ver}.8-stable
libevent_name1=libevent-${libevent_ver_full}
libevent_nametar=${libevent_name1}.tar.gz

if [ ! -f $libevent_nametar ]; then
  wget -O ${libevent_nametar} "https://github.com/libevent/libevent/releases/download/release-${libevent_ver_full}/${libevent_nametar}"
fi

(tar zxf ${libevent_nametar} && cd ${libevent_name1} && ./configure --prefix=/opt/${libevent_name1} && make install && ln -s ${libevent_name1} /opt/libevent) || exit 1

echo /opt/libevent/lib >>/etc/ld.so.conf.d/libevent.conf
ldconfig || exit 1

exit 0

