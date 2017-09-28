#!/bin/bash

if [[ $1 == '--help' ]] || [[ $1 == '-h' ]] || [[ $1 == '/?' ]]; then

  echo
  echo HELP:
  echo
  echo --------------------------------------------------------
  echo
  echo " Use "
  echo " ./pg_user_create.sh [db_target_path] [major_ver] [postgres_user_home_path]"
  echo " for create postgres user and database directories"
  echo
  echo " Example: ./pg_user_create.sh /data 9.6 /data/home"
  echo
  echo " Use parameter --help or -h or /? for view this help"
  echo
  echo --------------------------------------------------------
 
  exit 0

fi

TARGET_DIR=${TARGET_DIR:-$1}
PG_REL=${PG_REL:-$2}
PGDATA=${TARGET_DIR}/pgsql/${PG_REL}
PGLOG=${TARGET_DIR}/log/pgsql
PGWAL=${TARGET_DIR}/pgwal
PGARCH=${PGWAL}/archive
PGWALBACKUP=${PGWAL}/walbackup
if [ -z "$3" ]; then
    PG_HOME=${PG_HOME:-${TARGET_DIR}/home}
else
    PG_HOME=$3
fi

echo "Create group & user postgres"

# Create group with system GUID
( getent group postgres || groupadd -r postgres ) || exit 1


if id postgres >/dev/null 2>&1; then
    # Set primary user group
    
    usermod -g postgres postgres || exit 1

else
    # Create user with system UID and with home directory

    [ -d $PG_HOME ] || mkdir -p $PG_HOME || exit 1
    useradd -r -g postgres -s /bin/bash -d $PG_HOME/postgres -m -k /etc/skel postgres || exit 1

fi

echo "Set credentials on folders "

mkdir -p $PGDATA $PGLOG $PGARCH $PGWAL $PGWALBACKUP && \
chown -R postgres:postgres $PGDATA $PGARCH $PGLOG $PGWAL $PGWALBACKUP && \
chmod 0700 $PGDATA || exit 1

exit 0

