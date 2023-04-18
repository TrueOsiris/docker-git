#!/bin/bash
/usr/bin/touch /var/log/cron.log 2>/dev/null
/usr/bin/chmod 666 /var/log/cron.log 2>/dev/null
CF="/mnt/repos/.credentials.txt"
if [ ! -f "$CF" ]; then
	echo "$CF does not exist. Trying to create it."
	touch "$CF"
	echo "GITUSER=" > "$CF"
	echo "GITMAIL=" >> "$CF"
	echo "GITREPOUSER=" >> "$CF"
	echo 'GITROOT="git@github.com"' >> "$CF"
	echo "DOCKERUSER=" >> "$CF"
	echo "DOCKERPASS=" >> "$CF"
        echo "SSHPASS=" >> "$CF"
fi
source "$CF"

tz_varname="TZ"
tz=${!tz_varname}
gituser_varname="GITUSER"
gituser=${!gituser_varname}
export GITUSER=$gituser
gitmail_varname="GITMAIL"
gitmail=${!gitmail_varname}
export GITMAIL=$gitmail
dockeruser_varname="DOCKERUSER"
dockeruser=${!dockeruser_varname}
export DOCKERUSER=$dockeruser
dockerpass_varname="DOCKERPASS"
dockerpass=${!dockerpass_varname}
export DOCKERPASS=$dockerpass
sshpass_varname="SSHPASS"
sshpass=${!sshpass_varname}
export SSHPASS=$sshpass
gitrepouser_varname="GITREPOUSER"
gitrepouser=${!gitrepouser_varname}
if [[ -z $gitrepouser || $gitrepouser == "" ]]; then
	gitrepouser=$gituser
fi
export GITREPOUSER=$gitrepouser
gitroot_varname="GITROOT"
gitroot=${!gitroot_varname}
export GITROOT=$gitroot

if [ -z ${tz} ]; then
	echo "Container variable TZ:"
	echo "Timezone not set. Defaulting to Europe/Brussels"
	tz="Europe/Brussels"
fi
echo "Timezone is $tz"
if [ -z ${gituser} ] || [ ${gituser} = "" ]; then
	echo "Variable $gituser_varname not set in credentials file."
	echo "Exiting"
	exit 0
else
	echo "gituser is set."
fi
if [ -z ${gitmail} ] || [ ${gitmail} = "" ]; then
        echo "Variable $gitmail_varname not set in credentials file."
        echo "Exiting"
        exit 0
else
        echo "gitmail is set."
fi
if [ -z ${dockeruser} ] || [ ${dockeruser} = "" ]; then
        echo "Variable $dockeruser_varname not set in credentials file."
        echo "Exiting"
        exit 0
else
        echo "dockeruser is set."
fi
if [ -z ${dockerpass} ] || [ ${dockerpass} = "" ]; then
        echo "Variable $dockerpass_varname not set in credentials file."
        echo "Exiting"
        exit 0
else
        echo "dockerpass is set."
fi


/usr/bin/git config --system color.ui true
/usr/bin/git config --system user.name "$gituser"
/usr/bin/git config --system user.email "$gitmail"
/usr/bin/dircolors -p > ~/.dircolors
echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/issue && cat /etc/motd' >> /etc/bash.bashrc
/usr/bin/cp /root/.* /mnt/repos/ 2>/dev/null
/usr/bin/ln -s /gitpush /usr/bin/gitpush
/usr/bin/ln -s /dockerpush /usr/bin/dockerpush
/usr/bin/ln -s /push /usr/bin/push
/usr/bin/mkdir /mnt/repos/.ssh 2>/dev/null
echo 'n' | /usr/bin/ssh-keygen -t ed25519 -C "$gitmail" -P "" -f /mnt/repos/.ssh/id_ed25519 2>/dev/null 1>/dev/null
echo ' '
/usr/bin/cat /mnt/repos/.ssh/id_ed25519.pub
echo ' '
ssh -oStrictHostKeyChecking=no -T $gitroot 2>/dev/null 1>/dev/null
/usr/bin/git config --global url.ssh://$gitroot/.insteadOf https://github.com/
echo $'/var/log/cron.log {\n  rotate 7\n  daily\n  missingok\n  notifempty\n  create\n}' > /etc/logrotate.d/git-cron
echo "$date Running start.sh" >> /var/log/cron.log
echo "30 5 * * * /usr/sbin/logrotate /etc/logrotate.d/git-cron" >> /etc/cron.d/git-cron
echo " " >> /etc/cron.d/git-cron
echo "root:$sshpass" | chpasswd
/usr/bin/sed '/root/s!\(.*:\).*:\(.*\)!\1/mnt/repos:\2!' /etc/passwd > /etc/passwd2
/usr/bin/mv /etc/passwd2 /etc/passwd 2>&1
/usr/bin/sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config 2>&1
/etc/init.d/ssh start 2>&1
/usr/bin/crontab /etc/cron.d/git-cron
/usr/sbin/cron -f
/usr/bin/tail -f /var/log/cron.log
