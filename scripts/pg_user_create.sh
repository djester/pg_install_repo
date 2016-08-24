#!/bin/bash

echo "Create group & user postgres"

# Create group with system GUID
groupadd -r postgres || exit 1

# Create user with system UID and with home directory
[ -d $PG_HOME ] || mkdir -p $PG_HOME || exit 1
useradd -r -g postgres -s /bin/bash -d $PG_HOME/postgres -m -k /etc/skel postgres || exit 1

exit 0

