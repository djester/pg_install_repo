#!/bin/bash
#
# If you would skip some step - comment it.
# Be carreful!!! libevent is dependency for tmux and pgbouncer
#

# includes

repo=$(readlink -f $0); repo=${repo%/*}
export repo

. ${repo}/config/libevent_install.conf
. ${repo}/config/pg_install.conf

#./scripts/libevent_install.sh
#./scripts/tmux_install.sh
#./scripts/pg_install.sh
./scripts/pgb_install.sh
./scripts/lsyncd_install.sh

