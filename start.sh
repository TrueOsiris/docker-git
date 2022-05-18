#!/bin/bash
/usr/bin/touch /var/log/cron.log 2>/dev/null
/usr/bin/chmod 666 /var/log/cron.log 2>/dev/null
CF="/mnt/github/credentials.txt"
if [ ! -f "$CF" ]; then
	echo "$CF does not exist. Trying to create it."
	touch "$CF"
	echo "GITUSER=" > "$CF"
	echo "GITMAIL=" >> "$CF"
	echo "DOCKERUSER=" >> "$CF"
	echo "DOCKERPASS=" >> "$CF"
fi
source "$CF"

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
echo "Timezone is $tz"
if [ -z ${gituser} ]; then
	echo "Variable $gituser_varname not set in credentials file."
	echo "Exiting"
	exit 0
else
	echo "gituser is set."
fi
if [ -z ${gitmail} ]; then
        echo "Variable $gitmail_varname not set in credentials file."
        echo "Exiting"
        exit 0
else
        echo "gitmail is set."
fi

/usr/bin/git config --system color.ui true
/usr/bin/git config --system user.name "$gituser"
/usr/bin/git config --system user.email "$gitmail"
/usr/bin/dircolors -p > ~/.dircolors
echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/issue && cat /etc/motd' >> /etc/bash.bashrc
/usr/bin/cp /root/.* /mnt/github/ 2>/dev/null
/usr/bin/ln -s /gitpush /usr/bin/gitpush
/usr/bin/ln -s /dockerpush /usr/bin/dockerpush
/usr/bin/mkdir /mnt/github/.ssh 2>/dev/null
echo 'n' | /usr/bin/ssh-keygen -t ed25519 -C "$gitmail" -P "" -f /mnt/github/.ssh/id_ed25519 2>/dev/null 1>/dev/null
echo ' '
/usr/bin/cat /mnt/github/.ssh/id_ed25519.pub
echo ' '
ssh -oStrictHostKeyChecking=no -T git@github.com 2>/dev/null 1>/dev/null
/usr/bin/git config --global url.ssh://git@github.com/.insteadOf https://github.com/
echo $'/var/log/cron.log {\n  rotate 7\n  daily\n  missingok\n  notifempty\n  create\n}' > /etc/logrotate.d/git-cron
echo "$date Running start.sh" >> /var/log/cron.log
echo "30 5 * * * /usr/sbin/logrotate /etc/logrotate.d/git-cron" >> /etc/cron.d/git-cron
echo " " >> /etc/cron.d/git-cron
/usr/bin/sed '/root/s!\(.*:\).*:\(.*\)!\1/mnt/github:\2!' /etc/passwd > /etc/passwd2
/usr/bin/mv /etc/passwd2 /etc/passwd
/usr/bin/crontab /etc/cron.d/git-cron
/usr/sbin/cron -f
/usr/bin/tail -f /var/log/cron.log
