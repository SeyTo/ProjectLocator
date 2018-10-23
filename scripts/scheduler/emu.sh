#!/bin/env

if [ -n $SCRIPT ]; then
  echo "Cannot locate the script directory. Assign to SCRIPT variable."
  exit
fi

sudo systemctl start sshd.service && $SCRIPT/virtual/emu
exit
