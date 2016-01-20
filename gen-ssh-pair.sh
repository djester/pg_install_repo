#!/bin/bash

PAIR_HOST=pair-host.domain
SSH_KEY_FILE=~postgres/.ssh/id_rsa
PG_PWD=$(date +%s | sha256sum | base64 | head -c 32)

echo "Run from root on ${PAIR_HOST} host:"
echo "echo ${PG_PWD} | passwd --stdin postgres"

[ -f ${SSH_KEY_FILE} ] && ( rm -f ${SSH_KEY_FILE} ; rm -f ${SSH_KEY_FILE}.pub )

su - postgres -c "ssh-keygen -q -t rsa -b 4096 -N '' -f ~/.ssh/id_rsa"
su - postgres -c "ssh-copy-id postgres@${PAIR_HOST}"

