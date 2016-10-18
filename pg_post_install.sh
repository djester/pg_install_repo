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

echo Copy init-scripts:

echo -- PostgreSQL
cp ${repo}/init.d/postgresql-${PG_REL} /etc/init.d/postgresql && chkconfig postgresql on || exit 1

echo -- lsyncd
cp ${repo}/init.d/lsyncd /etc/init.d/lsyncd && chkconfig lsyncd on || exit 1

echo -- pgbouncer
cp ${repo}/init.d/pgbouncer /etc/init.d/pgbouncer && chkconfig pgbouncer on || exit 1


echo Copy configs

echo "-- sysctl.conf (DON'T FORGET EDIT IT!!!)"
cp ${repo}/etc/sysctl.conf /etc/sysctl.conf && sysctl -p || exit 1

echo "-- limits.conf"
cp ${repo}/etc/limits.conf /etc/security/limits.conf || exit 1

echo "-- pg_hba.conf (DON'T FORGET EDIT IT!!!)"
cp ${repo}/etc/pg_hba.conf ${PGSQL}/pg_hba.conf || exit 1

echo "-- postgresql.conf"
cp ${repo}/etc/postgresql.conf ${PGDATA}/postgresql.conf && chown postgres:postgres ${PGDATA}/postgresql.conf && chmod 600 ${PGDATA}/postgresql.conf || exit 1

echo "-- postgres crontab"
cp ${repo}/etc/pgsql.cron /var/spool/cron/postgres || exit 1

echo "-- recovery.conf.tmpl (DON'T FORGET EDIT IT!!!)"
cp ${repo}/etc/recovery.conf.tmpl ${PGSQL}/recovery.conf.tmpl || exit 1

echo "-- postgres lsyncd.conf"
cp ${repo}/etc/lsyncd.conf /etc/lsyncd.conf || exit 1

echo Copy auxilary scripts
mkdir -p ${PG_BIN} && cp ${repo}/bin/* ${PG_BIN}/

echo Create Postgres entities

echo "-- Create empty DB for monitoring agent connection"
su - postgres -c "createdb -U postgres zabbix" || exit 1
echo "-- Create user for monitoring agent connection"
su - postgres -c "createuser -U postgres zabbix" || exit 1
echo "-- Create Replication user"
su - postgres -c "createuser -U postgres -SDR --replication replica" || exit 1

