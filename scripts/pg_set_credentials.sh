#!/bin/bash

echo "Set credentials on folders "

mkdir -p $PGDATA $PGLOG $PGARCH $PGWAL && \
chown -R postgres:postgres $PGDATA $PGARCH $PGLOG $PGWAL && \
chmod 0700 $PGDATA || exit 1

exit 0

