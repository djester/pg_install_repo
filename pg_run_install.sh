#!/bin/bash
#
# If you would skip some step - comment it.
# Be carreful!!! libevent is dependency for tmux and pgbouncer
#


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

    # set root for git repository

    repo=$(readlink -f $0); repo=${repo%/*}
    export repo

    # includes off
    # . ${repo}/config/pg_install.conf

    # init variables

    TARGET_DIR=$1
    [ "${TARGET_DIR}" ] || { echo "ERR: Varible TARGET_DIR is not defined!" >&2; exit 1; }
    export TARGET_DIR

    PG_VER=$2
    [ "${PG_VER}" ] || { echo "ERR: Varible PG_VER is not defined!" >&2; exit 1; }

    PG_REL=${PG_VER%.*}
    PG_DATA=${TARGET_DIR}/pgsql/${PG_REL}
    PG_LC=ru_RU.UTF-8

    TMUX_INST="YES"
    PG_INST="YES"
    USER_CREATE="YES"
    DB_INIT="YES"
    PGB_INST="YES"
    SYNC_INST="YES"
 
    if [ TMUX_INST == "YES" ] || [ PGB_INST == "YES" ] || [ SYNC_INST == "YES" ];
    then
        LIB_EVENT_INST="YES"
    fi

    TMUX_VER=2.4
    PGB_VER=1.7.2

    # install scripts

    ${repo}/scripts/libevent_install.sh && \
    ${repo}/scripts/tmux_install.sh ${TMUX_VER} && . /etc/profile.d/tmux.sh && \
    ${repo}/scripts/pg_install.sh ${PG_VER} && \
    ${repo}/scripts/pg_user_create.sh ${TARGET_DIR} ${PG_REL} && \
    ${repo}/scripts/pg_db_init.sh ${PG_DATA} ${PG_LC} && \
     . /etc/profile.d/postgresql.sh && \
    ${repo}/scripts/pgb_install.sh ${TARGET_DIR} ${PGB_VER} && \
    ${repo}/scripts/lsyncd_install.sh

else
    echo "Nothing to do without args."
    echo " Use parameter --help or -h or /? for view this help"

    exit 1
fi
