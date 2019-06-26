#!/bin/bash

if [[ "$RESTORE" == "true" ]]; then
  ./restore.sh
else
  ./backup.sh
fi

if [ -n "$CRON_TIME" ]; then
  echo "${CRON_TIME} /backup.sh >> /tmp/backups/dockup.log 2>&1" > /var/spool/cron/crontabs/root
  echo "=> Running dockup backups as a cronjob for ${CRON_TIME}"
  exec crond -f
fi
