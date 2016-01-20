#!/bin/bash

echo "Initialize DB server"

cr_db_cmd="/opt/postgresql/bin/initdb -D ${PGDATA} -E ${PG_ENCODING} --locale=${PG_LC} --lc-collate=${PG_LC} --lc-ctype=${PG_LC}"
su postgres -c "${cr_db_cmd}" || exit 1

exit 0

