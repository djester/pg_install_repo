#!/bin/bash

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

