#!/bin/bash
#
# If you would skip some step - comment it.
# Be carreful!!! libevent is dependency for tmux and pgbouncer
#

# set root for git repository

repo=$(readlink -f $0); repo=${repo%/*}
export repo

# includes

. ${repo}/config/libevent_install.conf
. ${repo}/config/pg_install.conf

# install scripts

${repo}/scripts/libevent_install.sh && \
${repo}/scripts/tmux_install.sh 2.2 && . /etc/profile.d/tmux.sh && \
${repo}/scripts/pg_install.sh && \
${repo}/scripts/pg_user_create.sh && \
${repo}/scripts/pg_db_init.sh && \
 . /etc/profile.d/postgresql.sh && \
${repo}/scripts/pgb_install.sh 1.7.2 && \
${repo}/scripts/lsyncd_install.sh

