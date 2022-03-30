#!/bin/bash
/usr/bin/touch /var/log/cron.log 2>/dev/null
/usr/bin/chmod 666 /var/log/cron.log 2>/dev/null

tz_varname="TZ"
tz=${!tz_varname}
gituser_varname="GITUSER"
gituser=${!gituser_varname}
gitmail_varname="GITMAIL"
gitmail=${!gitmail_varname}

if [ -z ${tz} ]; then
	echo "Container variable TZ:"
	echo "Timezone not set. Defaulting to Europe/Brussels"
	tz="Europe/Brussels"
fi
echo "timezone is $tz"
if [ -z ${gituser} ]; then
	echo "Container variable $gituser_varname not set."
	echo "exiting"
	exit 0
else
	echo "gituser = $gituser"
fi
if [ -z ${gitmail} ]; then
        echo "Container variable $gitmail_varname not set."
        echo "exiting"
        exit 0
else
        echo "gitmail = $gitmail"
fi

/usr/bin/git config --global color.ui true
/usr/bin/git config --global user.name "$gituser"
/usr/bin/git config --global user.email "$gitmail"
echo $'/var/log/cron.log {\n  rotate 7\n  daily\n  missingok\n  notifempty\n  create\n}' > /etc/logrotate.d/git-cron
echo "$date Running start.sh" >> /var/log/cron.log
echo "30 5 * * * /usr/sbin/logrotate /etc/logrotate.d/git-cron" >> /etc/cron.d/git-cron
echo " " >> /etc/cron.d/git-cron
/usr/bin/sed '/root/s!\(.*:\).*:\(.*\)!\1/mnt/github:\2!' /etc/passwd > /etc/passwd2
/usr/bin/mv /etc/passwd2 /etc/passwd
/usr/bin/crontab /etc/cron.d/git-cron
/usr/sbin/cron -f
/usr/bin/tail -f /var/log/cron.log
