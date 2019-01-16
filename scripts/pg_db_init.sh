#!/bin/bash

PG_DATA=${PG_DATA:-$1}
PG_LC=${PG_LC:-$2}
PG_ENCODING=${PG_LC##*.}

echo "Initialize DB server"

cr_db_cmd="/opt/postgresql/bin/initdb -D ${PG_DATA} -E ${PG_ENCODING} --locale=${PG_LC} --lc-collate=${PG_LC} --lc-ctype=${PG_LC} -k"
su postgres -c "${cr_db_cmd}" || exit 1

exit 0

