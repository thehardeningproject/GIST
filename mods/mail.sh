#!/bin/bash

# GIST - Gathering Information and Scanning Tool v0.2
# Written by: Ventre Nicolas
# URL: www.thehardeningproject.com
# Email: info@thehardeningproject.com


num=1
while [ $num -lt 15 ]; do
	host -t mx $url | cut -d " " -f 6-7 >> /tmp/cache_mail
	num=$(($num +1))
done

cat /tmp/cache_mail | sort -n | uniq -d > /tmp/mail

echo " " >> $HOME/gist/remote_scan/$url/MAIL_$url
echo "MAIL:" >> $HOME/gist/remote_scan/$url/MAIL_$url
cat /tmp/mail | cut -d " " -f 2 >> /tmp/maildir

con=1
for i in `cat /tmp/maildir`;do
	sed -n $con\p /tmp/mail >> $HOME/gist/remote_scan/$url/MAIL_$url
	num=1
	while [ $num -lt 15 ]; do
		host $i | grep address | cut -d " " -f 4 >> /tmp/MAIL_ip
		num=$(($num + 1))
	done
	cat /tmp/MAIL_ip | sort -n | uniq -d >> $HOME/gist/remote_scan/$url/MAIL_$url
	echo " " > /tmp/MAIL_ip
	con=$(($con +1))
	echo " " >> $HOME/gist/remote_scan/$url/MAIL_$url
done
