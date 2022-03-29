#!/bin/bash
/usr/bin/touch /var/log/cron.log 2>/dev/null
/usr/bin/chmod 666 /var/log/cron.log 2>/dev/null

tz_varname="TZ"
tz=${!tz_varname}

if [ -z ${tz} ]; then
	echo "Container variable TZ:"
	echo "Timezone not set. Defaulting to Europe/Brussels"
	tz="Europe/Brussels"
fi

echo $'/var/log/cron.log {\n  rotate 7\n  daily\n  missingok\n  notifempty\n  create\n}' > /etc/logrotate.d/git-cron
echo "$date Running start.sh" >> /var/log/cron.log
echo "30 5 * * * /usr/sbin/logrotate /etc/logrotate.d/git-cron" >> /etc/cron.d/git-cron
echo " " >> /etc/cron.d/git-cron
/usr/bin/sed '/root/s!\(.*:\).*:\(.*\)!\1/mnt/github:\2!' /etc/passwd > /etc/passwd2
/usr/bin/mv /etc/passwd2 /etc/passwd
/usr/bin/crontab /etc/cron.d/git-cron
/usr/sbin/cron -f
/usr/bin/tail -f /var/log/cron.log
