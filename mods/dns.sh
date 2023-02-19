#!/bin/bash

# GIST - Gathering Information and Scanning Tool v0.2
# Written by: Ventre Nicolas
# URL: www.thehardeningproject.com
# Email: info@thehardeningproject.com


num=1
while [ $num -lt 15 ]; do
	host -t ns $url | cut -d " " -f 4 >> /tmp/cache_dns
	num=$(($num +1))
done

cat /tmp/cache_dns | sort -n | uniq -d > /tmp/dns

echo " " >> $HOME/gist/remote_scan/$url/DNS_$url
echo "DNS:" >> $HOME/gist/remote_scan/$url/DNS_$url

con=1
for i in `cat /tmp/dns`;do
	sed -n $con\p /tmp/dns >> $HOME/gist/remote_scan/$url/DNS_$url
	num=1
	while [ $num -lt 15 ]; do
		host $i | grep address | cut -d " " -f 4 >> /tmp/DNS_ip
		num=$(($num + 1))
	done
	cat /tmp/DNS_ip | sort -n | uniq -d >> $HOME/gist/remote_scan/$url/DNS_$url
	echo " " > /tmp/DNS_ip
	con=$(($con +1))
	echo " " >> $HOME/gist/remote_scan/$url/DNS_$url
done
