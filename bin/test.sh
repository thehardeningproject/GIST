#!/bin/bash

# GIST - Gathering Information and Scanning Tool v0.2
# Written by: Ventre Nicolas
# URL: www.thehardeningproject.com
# Email: info@thehardeningproject.com


# Know Distro
function knowingdistro()
{
local distro
# unknown distro
    distro="unknown"

    # Test Fedora / RHEL / CentOS / and Redhat based OS
    if [ -r /etc/rc.d/init.d/functions ]; then
        source /etc/rc.d/init.d/functions
        [ zz`type -t passed 2>/dev/null` == "zzfunction" ] && distro="redhat"

    # Test SUSE 
    # I've seen rc.status on Ubuntu I think? ALL: Recheck that)
    elif [ -r /etc/rc.status ]; then
        source /etc/rc.status
        [ zz`type -t rc_reset 2>/dev/null` == "zzfunction" ] && distro="suse"

    # Test Debian, Ubuntu
    elif [ -r /lib/lsb/init-functions ]; then
        source /lib/lsb/init-functions
        [ zz`type -t log_begin_msg 2>/dev/null` == "zzfunction" ] && distro="debian"

    # Test Gentoo
    elif [ -r /etc/init.d/functions.sh ]; then
        source /etc/init.d/functions.sh
        [ zz`type -t ebegin 2>/dev/null` == "zzfunction" ] && distro="gentoo"

    # Para Slackware only works if /etc/slackware-version exist
    # and it's empty
    elif [ -s /etc/slackware-version ]; then
        distro="slackware"
    fi
    echo "Distro: $distro"
    if [ -z $distro ] || [ $distro = debian ]; then
        debiann
    else
        redhatt
    fi
}

# Scan Debian and Derivatives
function debiann()
{
echo -ne "\n::: Linux Version :::\n"
\cat -f /etc/debian_version $HOME/gist/local_scan/$HOSTNAME/OSVersion

echo -ne "\n::: Services listening on Tcp y Udp :::\n"
netstat -tuape > $HOME/gist/local_scan/$HOSTNAME/netstat.log

echo -ne "\n::: lsof ::: \n"
lsof -i -n | egrep 'COMMAND|ESTABLISHED|UDP' > $HOME/gist/local_scan/$HOSTNAME/established-connections.log

echo -ne "\n::: Service Status::: \n"
systemctl list-unit-files > $HOME/gist/local_scan/$HOSTNAME/service_status.log

echo -ne "\n::: Unlock Accounts ::::\n"
egrep -v '.*:\*|:\!' /etc/shadow | awk -F: '{print $1}' > $HOME/gist/local_scan/$HOSTNAME/unlock_acounts.log

echo -ne "\n::: Accounts with shell access :::\n"
grep "/bin/bash" /etc/passwd | cut -d ":" -f 1 > $HOME/gist/local_scan/$HOSTNAME/users.log
for a in `cat $HOME/gist/local_scan/$HOSTNAME/users.log`; do
  id $a | cut -d ":" -f 1 >> $HOME/gist/local_scan/$HOSTNAME/ids_users.log;
done

echo -ne "\n::: Denied Hosts :::\n"
if [ 0 -lt `grep -v '#' /etc/hosts.deny|wc -l` ]
then
    (grep -v '#' /etc/hosts.deny > $HOME/gist/local_scan/$HOSTNAME/denied_hosts.log)
fi

echo -ne "\n::: Allowed Hosts :::\n"
if [ 0 -lt `grep -v '#' /etc/hosts.allow|wc -l` ]
then
    (grep -v '#' /etc/hosts.allow > $HOME/gist/local_scan/$HOSTNAME/allowed_hosts.log)
fi

echo -ne "\n::: Files Viewed for everyone :::\n"
find / -path /proc -prune -o -perm -2 ! -type l -ls > $HOME/gist/local_scan/$HOSTNAME/files_viewed_for_everyone.log

echo -ne "\n::: Files without owner :::\n"
find / -path /proc -prune -o -nouser -o -nogroup > $HOME/gist/local_scan/$HOSTNAME/files_without_owner.log

echo -ne "\n::: Users loged now :::\n"
w > $HOME/gist/local_scan/$HOSTNAME/users_loged_now.log

echo -ne "\n::: Last 20 connections :::\n"
last -20 > $HOME/gist/local_scan/$HOSTNAME/last_connections.log

echo -ne "\n::: Last Loged Users :::\n"
(lastlog | egrep -v 'Never|Nunca' > $HOME/gist/local_scan/$HOSTNAME/last_loged_users.log)

echo -ne "\n::: Failed Logins Attemps :::\n"

if [ -a /var/log/auth.log ];then
    grep "authentication failure" /var/log/auth.log >> $HOME/gist/local_scan/$HOSTNAME/failed_attempts.log
else
    egrep 'Failed password for invalid user|sshd' /var/log/secure >> $HOME/gist/local_scan/$HOSTNAME/failed_attempts.log
    grep -v "Failed password for invalid user" /var/log/secure | egrep 'sshd|Failed password for' >> $HOME/gist/local_scan/$HOSTNAME/failed_attempts2.log
    if [ -a /var/log/secure.1 ];then
        egrep 'Failed password for invalid user|sshd' /var/log/secure.1 >> $HOME/gist/local_scan/$HOSTNAME/failed_attempts.log
        grep -v "Failed password for invalid user" /var/log/secure.1|egrep 'sshd|Failed password for' >> $HOME/gist/local_scan/$HOSTNAME/failed_attempts2.log
    fi
fi

cat $HOME/gist/local_scan/$HOSTNAME/failed_attempts.log | awk '{print $13}' > $HOME/gist/local_scan/$HOSTNAME/bad_ips.log
cat $HOME/gist/local_scan/$HOSTNAME/failed_attempts2.log | awk '{print $11}' >> $HOME/gist/local_scan/$HOSTNAME/bad_ips.log
(sort $HOME/gist/local_scan/$HOSTNAME/bad_ips.log | uniq -c| sort -n > $HOME/gist/local_scan/$HOSTNAME/bad_ips.log)
cat $HOME/gist/local_scan/$HOSTNAME/failed_attempts2.log >> $HOME/gist/local_scan/$HOSTNAME/failed_attempts.log
N_INTENTOS=`wc -l $HOME/gist/local_scan/$HOSTNAME/failed_attempts.log |cut -f 1 -d " "`
if [ -z $N_INTENTOS ] || [ 100 -lt $N_INTENTOS ]; then
    echo "It has a big number of Failed Attempts for ssh (more than $N_INTENTOS )" >> $HOME/gist/local_scan/$HOSTNAME/number_of_ssh_attempts.log
    echo "Principally from these IPs" >> $HOME/gist/local_scan/$HOSTNAME/number_of_ssh_attempts.log
    echo "`cat $HOME/gist/local_scan/$HOSTNAME/bad_ips.log`" >> $HOME/gist/local_scan/$HOSTNAME/number_of_ssh_attempts.log
else

echo ""

fi

echo -ne "\n::: History Commands :::\n"
cat /root/.bash_history > $HOME/gist/local_scan/$HOSTNAME/root_history.log
for a in `cat $HOME/gist/local_scan/$HOSTNAME/users.log`; do
    if test -e /home/$a/.bash_history
    then
        cp /home/$a/.bash_history $HOME/gist/local_scan/$HOSTNAME/$a_history.log
    fi
done

echo -ne "\n::: Memory Use :::\n"
free -m > $HOME/gist/local_scan/$HOSTNAME/memoria.log

echo -ne "\n::: Disk Use :::\n"
df -h > $HOME/gist/local_scan/$HOSTNAME/df.log

echo -ne "\n::: Network Collisions :::\n"
for a in `ifconfig |grep "collisions:"| awk '{print $1}'|cut -d ":" -f 2`; do
   if [ "$a" != "0" ];
   then
     echo "It found collisions" >> $HOME/gist/local_scan/$HOSTNAME/collisions.log
   fi
done

echo -ne "\n::: Active Process :::\n"
ps fax > $HOME/gist/local_scan/$HOSTNAME/process.log

echo -ne "\n::: Uptime :::\n"
uptime > $HOME/gist/local_scan/$HOSTNAME/uptime.log

echo -ne "\n::: Deleted Files Still Opened :::\n"
(lsof |grep "(deleted)" >  $HOME/gist/local_scan/$HOSTNAME/deleted_files_still_opened.log)&

echo -ne "\n::: CPU Use :::\n"
if test -e /usr/bin/iostat
then
    iostat > $HOME/gist/local_scan/$HOSTNAME/iostat.log
fi

echo -ne "\n::: Kernel Version :::\n"
uname -a > $HOME/gist/local_scan/$HOSTNAME/kernel_version.log

dpkg -l > $HOME/gist/local_scan/$HOSTNAME/listadpkg.log

ifconfig -a > $HOME/gist/local_scan/$HOSTNAME/interfaces.log

cat /etc/shadow > $HOME/gist/local_scan/$HOSTNAME/Usershadow.log
cp /etc/apt/source.list > $HOME/gist/local_scan/Source.log


echo -ne "\n::: Port Services :::\n"
iface=`ip addr show | grep "state UP" | awk '{print $2}' | cut -f1 -d":"`
ip=`ip addr show $iface | grep -v inet6 | grep 'inet' | sed 's/^[ \t]*//' | cut -f2 -d" " | cut -f1 -d"/"`

nmap -sS -O -sV -D RND:5 $ip -oN $HOME/gist/local_scan/$HOSTNAME/Port_Services

# End Revision
now=$PWD
cd $HOME/gist/local_scan
tar cvzf Survey-$HOST.tar.gz $HOST
rm -R $HOME/gist/local_scan/$HOSTNAME
cd $now
}

#-------------------------------------------------------------------
# Scan Red Hat and Derivatives
function redhatt()
{
echo -ne "\n::: Linux Version :::\n"
\cp -f /etc/redhat-release $HOME/gist/local_scan/$HOSTNAME/OSVersion

echo -ne "\n::: Services listening on Tcp y Udp :::\n"
netstat -tuape > $HOME/gist/local_scan/$HOSTNAME/netstat.log

echo -ne "\n::: lsof::: \n"
lsof -i -n | egrep 'COMMAND|ESTABLISHED|UDP' > $HOME/gist/local_scan/$HOSTNAME/established-connections.log

echo -ne "\n::: Service Status::: \n"
systemctl list-unit-files > $HOME/gist/local_scan/$HOSTNAME/service_status.log

echo -ne "\n::: Unlock Accounts ::::\n"
egrep -v '.*:\*|:\!' /etc/shadow | awk -F: '{print $1}' > $HOME/gist/local_scan/$HOSTNAME/unlock_acounts.log

echo -ne "\n::: Accounts with shell access :::\n"
grep "/bin/bash" /etc/passwd | cut -d ":" -f 1 > $HOME/gist/local_scan/$HOSTNAME/users.log
for a in `cat $HOME/gist/local_scan/$HOSTNAME/users.log`; do
  id $a | cut -d ":" -f 1 >> $HOME/gist/local_scan/$HOSTNAME/ids_users.log;
done

echo -ne "\n::: Denied Hosts :::\n"
if [ 0 -lt `grep -v '#' /etc/hosts.deny|wc -l` ]
then
    (grep -v '#' /etc/hosts.deny > $HOME/gist/local_scan/$HOSTNAME/denied_hosts.log)
fi

echo -ne "\n::: Allowed Hosts :::\n"
if [ 0 -lt `grep -v '#' /etc/hosts.allow|wc -l` ]
then
    (grep -v '#' /etc/hosts.allow > $HOME/gist/local_scan/$HOSTNAME/allowed_hosts.log)
fi

echo -ne "\n::: Files Viewed for everyone :::\n"
find / -path /proc -prune -o -perm -2 ! -type l -ls > $HOME/gist/local_scan/$HOSTNAME/files_viewed_for_everyone.log

echo -ne "\n::: Files without owner :::\n"
find / -path /proc -prune -o -nouser -o -nogroup > $HOME/gist/local_scan/$HOSTNAME/files_without_owner.log

echo -ne "\n::: Users loged now :::\n"
w > $HOME/gist/local_scan/$HOSTNAME/users_loged_now.log

echo -ne "\n::: Last 20 connections :::\n"
last -20 > $HOME/gist/local_scan/$HOSTNAME/last_connections.log

echo -ne "\n::: Last Loged Users :::\n"
(lastlog | egrep -v 'Never|Nunca' > $HOME/gist/local_scan/$HOSTNAME/last_loged_users.log)

echo -ne "\n::: Failed Logins Attemps :::\n"
if test -e /var/log/auth.log
then
    grep "authentication failure" /var/log/auth.log >> $HOME/gist/local_scan/$HOSTNAME/failed_attempts.log
else
    egrep 'Failed password for invalid user|sshd' /var/log/secure >> $HOME/gist/local_scan/$HOSTNAME/failed_attempts.log
    grep -v "Failed password for invalid user" /var/log/secure|egrep 'sshd|Failed password for' >> $HOME/gist/local_scan/$HOSTNAME/failed_attempts2.log
    if test -e /var/log/secure.1
    then
        egrep 'Failed password for invalid user|sshd' /var/log/secure.1 >> $HOME/gist/local_scan/$HOSTNAME/failed_attempts.log
        grep -v "Failed password for invalid user" /var/log/secure.1 |egrep 'sshd|Failed password for' >> $HOME/gist/local_scan/$HOSTNAME/failed_attempts2.log
    fi
fi
cat $HOME/gist/local_scan/$HOSTNAME/failed_attempts.log | awk '{print $13}' > $HOME/gist/local_scan/$HOSTNAME/bad_ips.log
cat $HOME/gist/local_scan/$HOSTNAME/failed_attempts2.log | awk '{print $11}' >> $HOME/gist/local_scan/$HOSTNAME/bad_ips.log
(sort $HOME/gist/local_scan/$HOSTNAME/bad_ips.log | uniq -c | sort -n > $HOME/gist/local_scan/$HOSTNAME/bad_ips.log)
cat $HOME/gist/local_scan/$HOSTNAME/failed_attempts2.log >> $HOME/gist/local_scan/$HOSTNAME/failed_attempts.log
N_INTENTOS=`wc -l $HOME/gist/local_scan/$HOSTNAME/failed_attemps.log|cut -f 1 -d " "`
if [ -z$N_INTENTOS ] || [ 100 -lt $N_INTENTOS ];
then
    echo "It has a big number of Failed Attempts for ssh (more than $N_INTENTOS )" >> $HOME/gist/local_scan/$HOSTNAME/number_of_ssh_attempts.log
    echo "Principally from these IPs" >> $HOME/gist/local_scan/$HOSTNAME/number_of_ssh_attempts.log
    echo "`cat $HOME/gist/local_scan/$HOSTNAME/bad_ips.log`" >> $HOME/gist/local_scan/$HOSTNAME/number_of_ssh_attempts.log
else

echo ""

fi

echo -ne "\n::: History Commands :::\n"
mkdir historial
cp /root/.bash_history > $HOME/gist/local_scan/$HOSTNAME/root_history.log
for a in `cat $HOME/gist/local_scan/$HOSTNAME/users.log`; do
    if test -e /home/$a/.bash_history
    then
        cp /home/$a/.bash_history $HOME/gist/local_scan/$HOSTNAME/$a_history.log
    fi
done

echo -ne "\n::: Memory Use :::\n"
free -m > $HOME/gist/local_scan/$HOSTNAME/memoria.log

echo -ne "\n::: Disk Use :::\n"
df -h > $HOME/gist/local_scan/$HOSTNAME/df.log

echo -ne "\n::: Network Collisions :::\n"
for a in `ifconfig |grep "collisions:"| awk '{print $1}'|cut -d ":" -f 2`; do
   if [ "$a" != "0" ];
   then
     echo "It found collisions" >> $HOME/gist/local_scan/$HOSTNAME/collisions.log
   fi
done

echo -ne "\n::: Active Process :::\n"
ps fax > $HOME/gist/local_scan/$HOSTNAME/process.log

echo -ne "\n::: Uptime :::\n"
uptime > $HOME/gist/local_scan/$HOSTNAME/uptime.log

echo -ne "\n::: Deleted Files Still Opened :::\n"
(lsof |grep "(deleted)" >  $HOME/gist/local_scan/$HOSTNAME/deleted_files_still_opened.log)&

echo -ne "\n::: CPU Use :::\n"
if test -e /usr/bin/iostat
then
    iostat > $HOME/gist/local_scan/$HOSTNAME/iostat.log
fi

echo -ne "\n::: Kernel Version :::\n"
uname -a > $HOME/gist/local_scan/$HOSTNAME/kernel_version.log

echo -ne "\n::: List Installed Packages :::\n"
rpm -qa > $HOME/gist/local_scan/$HOSTNAME/listarpm.log

echo -ne "\n::: List Interfaces :::\n"
ifconfig -a > $HOME/gist/local_scan/$HOSTNAME/interfaces.log

cp /etc/shadow > $HOME/gist/local_scan/$HOSTNAME/Usershadow.log
cp /etc/yum.conf > $HOME/gist/local_scan/Source.log

echo -ne "\n::: Port Services :::\n"
iface=`ip addr show | grep "state UP" | awk '{print $2}' | cut -f1 -d":"`
ip=`ip addr show $iface | grep -v inet6 | grep 'inet' | sed 's/^[ \t]*//' | cut -f2 -d" " | cut -f1 -d"/"`

nmap -sS -O -sV -D RND:5 $ip -oN $HOME/gist/local_scan/$HOSTNAME/Port_Services

# End Revision
now=$PWD
cd $HOME/gist/local_scan
tar cvzf Survey-$HOST.tar.gz $HOST
rm -R $HOME/gist/local_scan
cd $now
}

# Make a directory
HOST=`hostname`

test_dir="$HOME/gist/local_scan/$HOSTNAME"

if [ -z $test_dir ] || [ -d $test_dir ]; then
	mkdir -p "$HOME/gist/local_scan/$HOSTNAME"
else
	mkdir -p "$HOME/gist/local_scan"
	mkdir -p "$HOME/gist/local_scan/$HOSTNAME"
fi

knowingdistro
