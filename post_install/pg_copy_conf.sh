#!/bin/bash
#
# If you would skip some step - comment it.
# Be carreful!!! libevent is dependency for tmux and pgbouncer
#

# set root for git repository

repo=$(readlink -f $0); repo=${repo%/post_install*}
export repo

# includes

#. ${repo}/config/pg_install.conf

if test $# -gt 0 ; then

	if [[ $1 == '--help' ]] || [[ $1 == '-h' ]] || [[ $1 == '/?' ]]; then

		echo
		echo HELP:
		echo
		echo --------------------------------------------------------
		echo
		echo " Use "
		echo " ./pg_copy_conf.sh [db_target_path] [full_ver] "
		echo " for copy configuration"
		echo
		echo " Example: ./pg_copy_conf.sh /data 9.6.4"
		echo
		echo " Use parameter --help or -h or /? for view this help"
		echo
		echo --------------------------------------------------------

		exit 0

	fi

	TARGET_DIR=$1
	[ "${TARGET_DIR}" ] || { echo "ERR: Varible TARGET_DIR is not defined!" >&2; exit 1; }
	export TARGET_DIR

	PG_VER=$2
	[ "${PG_VER}" ] || { echo "ERR: Varible PG_VER is not defined!" >&2; exit 1; }

	PG_REL=${PG_VER%.*}
	PGSQL=${TARGET_DIR}/pgsql
	PG_DATA=${TARGET_DIR}/pgsql/${PG_REL}

	echo Copy init-scripts:

	. ${repo}/tools/getinit.sh

	if [[ $SYSTEMINITDAEMON == "systemd" ]]; then
	  echo -- PostgreSQL
	  cp -f ${repo}/systemd/postgresql.service /usr/lib/systemd/system/postgresql.service && \
	  mkdir -p /etc/systemd/logind.conf.d && \
	  cp -f ${repo}/systemd/postgresql.logind.conf /etc/systemd/logind.conf.d/postgres && \
	  systemctl enable postgresql || exit 1
	  echo -- lsyncd
	  cp -f ${repo}/systemd/lsyncd.service /usr/lib/systemd/system/lsyncd.service && \
	  systemctl enable lsyncd || exit 1
	  echo -- pgbouncer
	  cp -f ${repo}/systemd/pgbouncer.service /usr/lib/systemd/system/pgbouncer.service && \
	  systemctl enable pgbouncer || exit 1
	else
	  echo -- PostgreSQL
	  cp -f ${repo}/init.d/postgresql-${PG_REL} /etc/init.d/postgresql && chkconfig postgresql on || exit 1
	  echo -- lsyncd
	  cp -f ${repo}/init.d/lsyncd /etc/init.d/lsyncd && chkconfig lsyncd on || exit 1
	  echo -- pgbouncer
	  cp -f ${repo}/init.d/pgbouncer /etc/init.d/pgbouncer && chkconfig pgbouncer on || exit 1
	fi

	echo Copy configs

	echo "-- sysctl.conf (DON'T FORGET EDIT IT!!!)"
	if [ $(uname -r | cut -c 1) -gt 2 ] && [ $(uname -r | cut -f2 -d'.') -ge 8 ]; # Kernel version upper that 3.8
	then
	  sed 's/sched_migration_cost/sched_migration_cost_ns/g' ${repo}/etc/sysctl.conf > /etc/sysctl.conf && sysctl -p || exit 1
	else
	  cp -f ${repo}/etc/sysctl.conf /etc/sysctl.conf && sysctl -p || exit 1
	fi
	echo "-- limits.conf"
	cp -f ${repo}/etc/limits.conf /etc/security/limits.conf || exit 1
	echo "-- pg_hba.conf (DON'T FORGET EDIT IT!!!)"
	cp -f ${repo}/etc/pg_hba.conf ${PGSQL}/pg_hba.conf || exit 1
	echo "-- postgresql.conf"
	cp -f ${repo}/etc/postgresql.conf ${PGDATA}/postgresql.conf && chown postgres:postgres ${PGDATA}/postgresql.conf && chmod 600 ${PGDATA}/postgresql.conf || exit 1
	echo "-- postgres crontab"
	cp -f ${repo}/etc/pgsql.cron /var/spool/cron/postgres || exit 1
	echo "-- recovery.conf.tmpl (DON'T FORGET EDIT IT!!!)"
	cp -f ${repo}/etc/recovery.conf.tmpl ${PGSQL}/recovery.conf.tmpl || exit 1
	echo "-- lsyncd.conf"
	cp -f ${repo}/etc/lsyncd.conf /etc/lsyncd.conf || exit 1
	echo "-- pgbouncer.ini"
	cp -f ${repo}/etc/pgbouncer.ini ${TARGET_DIR}/pgbouncer/pgbouncer.ini && chown -R postgres:postgres /var/run/pgbouncer || exit 1
	echo "-- pager.sh"
	cp -f ${repo}/etc/pager.sh /etc/profile.d/pager.sh
	echo "-- psqlrc"
	mkdir -p /opt/postgresql/etc
	cp -f ${repo}/etc/psqlrc /opt/postgresql/etc/psqlrc
	echo "-- /data/bin"
	mkdir -p /data/bin
	cp -f ${repo}/bin/* /data/bin/

else
    echo "Nothing to do without args."
    echo " Use parameter --help or -h or /? for view this help"

    exit 1
fi
