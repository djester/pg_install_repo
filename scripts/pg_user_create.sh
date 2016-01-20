#!/bin/bash

echo "Create user postgres with credentials"

# Create group with system GUID
groupadd -r postgres || exit 1

# Create user with system UID and with home directory
[ -d $PG_HOME ] || mkdir -p $PG_HOME || exit 1
useradd -r -g postgres -s /bin/bash -d $PG_HOME/postgres -m -k /etc/skel postgres || exit 1

mkdir -p $PGDATA $PGLOG $PGARCH $PGWAL
chown -R postgres:postgres $PGDATA $PGARCH $PGLOG $PGWAL
chmod 0700 $PGDATA || exit 1

exit 0

