#!/bin/bash
#
# If you would skip some step - comment it.
# Be carreful!!! libevent is dependency for tmux and pgbouncer
#

# set root for git repository

repo=$(readlink -f $0); repo=${repo%/*}
export repo

# includes

. ${repo}/config/pg_install.conf

# init variables

if test $# -gt 0 ; then 

    if [[ $1 == '--help' ]] || [[ $1 == '-h' ]] || [[ $1 == '/?' ]]; then

      echo
      echo HELP:
      echo
      echo --------------------------------------------------------
      echo
      echo " Use "
      echo " ./pg_run_install.sh [db_target_path] [full_ver] "
      echo " for create postgres user and database directories"
      echo
      echo " Example: ./pg_run_install.sh /data 9.6.4"
      echo
      echo " Use parameter --help or -h or /? for view this help"
      echo
      echo --------------------------------------------------------
     
      exit 0

    fi


    TARGET_DIR=${TARGET_DIR:-$1}
    PG_VER=${PG_VER:-$2}
    PG_REL=${PG_VER%.*}

    echo $TARGET_DIR $PG_VER $PG_REL
    echo $# $@
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

else
    echo "Nothing to do without args."
    echo " Use parameter --help or -h or /? for view this help"

    exit 1
fi
