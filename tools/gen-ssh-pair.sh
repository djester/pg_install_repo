#!/bin/bash

PAIR_HOST=pair-host.domain
SSH_KEY_FILE=~postgres/.ssh/id_rsa
PG_PWD=$(date +%s | sha256sum | base64 | head -c 32)

usermod -a -G sshd postgres || exit 1

echo "Run from root on ${PAIR_HOST} host:"
echo "echo ${PG_PWD} | passwd --stdin postgres"

echo "Press ENTER to continue..."
read -s -n 1

[ -f ${SSH_KEY_FILE} ] || ( su - postgres -c "ssh-keygen -q -t rsa -b 4096 -N '' -f ~/.ssh/id_rsa" || exit 1 )

echo "Run from postgres on this host:"
echo "ssh-copy-id postgres@${PAIR_HOST}"
echo "${PG_PWD} password"

echo "Press ENTER to continue..."
read -s -n 1

exit 0
