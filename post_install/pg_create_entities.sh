#!/bin/bash
#

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
