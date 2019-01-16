#!/bin/bash

res=$(psql postgres -t -A -X -c 'select pg_is_in_recovery()')
if [[ $res == 'f' ]]; then
    echo 'M'
else
    echo 'R'
fi

