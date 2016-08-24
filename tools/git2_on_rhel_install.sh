#!/bin/bash
#
# install Git on RHEL

yum -y remove git
yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker asciidoc xmlto

export GIT_VER=$1
cd /opt/src && wget https://www.kernel.org/pub/software/scm/git/git-${GIT_VER}.tar.gz && tar xzf git-${GIT_VER}.tar.gz && cd /opt/src/git-${GIT_VER} || exit 1

make prefix=/opt/git-${GIT_VER} all && make prefix=/opt/git-${GIT_VER} install && make prefix=/opt/git-${GIT_VER} install-man || exit 1

ln -s /opt/git-${GIT_VER} /opt/git

cat > /etc/profile.d/git.sh <<EOF
export PATH=\$PATH:/opt/git/bin
export MANPATH=/opt/git/share/man:\$MANPATH
EOF


