#!/bin/bash
#
# If you would skip some step - comment it.
# Be carreful!!! libevent is dependency for tmux and pgbouncer
#

./scripts/libevent_install.sh
./scripts/tmux_install.sh
./scripts/pg_install.sh
./scripts/pgb_install.sh
./scripts/lsyncd_install.sh

