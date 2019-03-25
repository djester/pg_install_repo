#!/bin/sh

if [[ $1 == '--help' ]] || [[ $1 == '-h' ]] || [[ $1 == '/?' ]]; then

    echo
    echo HELP:
    echo
    echo ---------------------------------------------------------------------------------
    echo
    echo " Use "
    echo " ./gen_pgbouncer.passwd.sh [pgbouncer.passwd full path]"
    echo " is automatic generation pgbouncer password file script"
    echo " for db users (roles) that not have super privileges and can login to database"
    echo
    echo " Example: ./gen_pgbouncer.passwd.sh /data/pgbouncer/pgbouncer.passwd"
    echo
    echo " If you run gen_pgbouncer.passwd.sh without argument "
    echo " default filename and path will use "
    echo
    echo " Use parameter --help or -h or /? for view this help"
    echo
    echo ---------------------------------------------------------------------------------
     
    exit 0

fi

PGB_PWD_DEFAULT=/data/pgbouncer/pgbouncer.passwd
PGB_PWD=${1:-$PGB_PWD_DEFAULT}
[ "${PGB_PWD}" ] || { echo "ERROR: Varible PGB_PWD is not defined!" >&2; exit 1; }

PGB_PWD_PATH=${PGB_PWD%/*}
[ -d ${PGB_PWD_PATH} ] || { echo "ERROR: Directory ${PGB_PWD_PATH} not exist!" >&2; exit 1; }

if [ ! -f ${PGB_PWD} ] ;
then
    echo "Creating new file ${PGB_PWD}"
else
    echo "File ${PGB_PWD} exists. Creating backup copy of ${PGB_PWD}"
    mv ${PGB_PWD} ${PGB_PWD}.bak || { echo "ERROR: cannot create backup copy of  ${PGB_PWD} !" >&2 ; exit 1; }
fi
touch ${PGB_PWD} || { echo "ERROR: cannot create file ${PGB_PWD} !" >&2 ; exit 1; }

for rn in $(psql -U postgres -qAtX -c "select rolname from pg_roles where not rolsuper and not rolreplication and rolcanlogin and not rolcatupdate")
do
    psql -U postgres -qAtX postgres -c "select '\"'||usename||'\" '||'\"'||passwd||'\"' from pg_shadow where usename='$rn'" >> $PGB_PWD
done
