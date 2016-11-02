#!/usr/bin/env bash

# Based on script from https://rtfm.co.ua/linux-opredelit-init-sistemu-systemd-vs-upstart/

# init process is pid 1
INIT=`ls -l /proc/1/exe`
if [[ $INIT == *"upstart"* ]]; then
  SYSTEMINITDAEMON=upstart
elif [[ $INIT == *"systemd"* ]]; then
  SYSTEMINITDAEMON=systemd
elif [[ $INIT == *"/sbin/init"* ]]; then
  INIT=`/sbin/init --version`
  if [[ $INIT == *"upstart"* ]]; then
    SYSTEMINITDAEMON=upstart
  elif [[ $INIT == *"systemd"* ]]; then
    SYSTEMINITDAEMON=systemd
  fi
fi

if [ -z "$SYSTEMINITDAEMON" ]; then
  echo "WARNING: Unknown distribution, assuming defaults - this may fail." >&2
  exit 1
else
  echo "Init system discovered: $SYSTEMINITDAEMON"
  export SYSTEMINITDAEMON
  exit 0
fi

