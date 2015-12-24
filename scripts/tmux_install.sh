#!/bin/bash

mkdir -p /opt/src

#Dependences
yum -y install ncurses-devel || exit1

. ../config/libevent_install.conf

#Install
cd /opt/src

tmux_ver=2.1
tmux_name=tmux-$tmux_ver
tmux_nametar=${tmux_name}.tar.gz
if [ ! -f $tmux_nametar ]; then
   wget -O ${tmux_nametar} "https://github.com/tmux/tmux/releases/download/${tmux_ver}/${tmux_nametar}" || exit 1
fi
tar zxf ${tmux_nametar} && 
(
  cd ${tmux_name} && PKG_CONFIG_PATH=/opt/${libevent_name1}/lib/pkgconfig ./configure --prefix=/opt/${tmux_name} && make && make install && ln -s /opt/${tmux_name} /opt/tmux
) || exit 1

# Configuration file
cat > /etc/profile.d/tmux.sh <<EOF
export PATH=\$PATH:/opt/tmux/bin
export MANPATH=\$MANPATH:/opt/tmux/share/man:
EOF

exit 0

