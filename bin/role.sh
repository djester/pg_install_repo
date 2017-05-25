#!/bin/bash

res=`psql postgres -t -A -c 'show transaction_read_only;'`
if [ $res == 'off' ]; then
    echo 'M'
else
    echo 'R'
fi

