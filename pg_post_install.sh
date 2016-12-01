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

${repo}/tools/getinit.sh

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
  cp ${repo}/init.d/postgresql-${PG_REL} /etc/init.d/postgresql && chkconfig postgresql on || exit 1
  echo -- lsyncd
  cp ${repo}/init.d/lsyncd /etc/init.d/lsyncd && chkconfig lsyncd on || exit 1
  echo -- pgbouncer
  cp ${repo}/init.d/pgbouncer /etc/init.d/pgbouncer && chkconfig pgbouncer on || exit 1
fi

echo Copy configs

echo "-- sysctl.conf (DON'T FORGET EDIT IT!!!)"
if [ $(uname -r | cut -c 1) -gt 2 ];
then
  sed 's/sched_migration_cost/sched_migration_cost_ns/g' ${repo}/etc/sysctl.conf > /etc/sysctl.conf && sysctl -p || exit 1
else
  cp ${repo}/etc/sysctl.conf /etc/sysctl.conf && sysctl -p || exit 1
fi
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
echo "-- lsyncd.conf"
cp ${repo}/etc/lsyncd.conf /etc/lsyncd.conf || exit 1
echo "-- pgbouncer.ini"
cp ${repo}/etc/pgbouncer.ini ${TARGET_DIR}/pgbouncer/pgbouncer.ini && chown -R postgres:postgres /var/run/pgbouncer || exit 1

echo Copy auxilary scripts
mkdir -p ${PG_BIN} && cp ${repo}/bin/* ${PG_BIN}/

echo Create Postgres entities

echo "-- Create empty DB for monitoring agent connection"
su - postgres -c "createdb -U postgres zabbix" || exit 1
echo "-- Create user for monitoring agent connection"
su - postgres -c "createuser -U postgres zabbix" || exit 1
echo "-- Create postgres extention in for monitoring db"
su - postgres -c "psql -qAtX -U postgres -d zabbix -c 'create extension pg_stat_statements'" || exit 1
su - postgres -c "psql -qAtX -U postgres -d zabbix -c 'create extension pg_buffercache'" || exit 1
echo "-- Create Replication user"
su - postgres -c "createuser -U postgres -SDR --replication replica" || exit 1
echo "-- Create owner role for appliction db"
su - postgres -c "psql -qAtX -U postgres -c 'create role app_owner with nologin'" || exit 1
