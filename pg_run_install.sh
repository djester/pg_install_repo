#!/bin/bash
#
# If you would skip some step - comment it.
# Be carreful!!! libevent is dependency for tmux and pgbouncer
#

# set root for git repository

repo=$(readlink -f $0); repo=${repo%/*}
export repo

# includes

#. ${repo}/config/pg_install.conf

TARGET_DIR=${TARGET_DIR:-$1}
PG_VER=${PG_VER:-$2}
PG_REL=${PG_VER%.*}

echo $TARGET_DIR $PG_VER $PG_REL

exit 0

# install scripts

${repo}/scripts/libevent_install.sh && \
${repo}/scripts/tmux_install.sh 2.4 && . /etc/profile.d/tmux.sh && \
${repo}/scripts/pg_install.sh && \
${repo}/scripts/pg_user_create.sh ${TARGET_DIR} ${PG_REL} && \
${repo}/scripts/pg_db_init.sh && \
 . /etc/profile.d/postgresql.sh && \
${repo}/scripts/pgb_install.sh 1.7.2 && \
${repo}/scripts/lsyncd_install.sh

