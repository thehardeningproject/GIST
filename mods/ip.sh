#!/bin/bash

# GIST - Gathering Information and Scanning Tool v0.2
# Written by: Ventre Nicolas
# URL: www.thehardeningproject.com
# Email: info@thehardeningproject.com


num=1
while [ $num -lt 15 ]; do
	host -t a $url | grep address | cut -d " " -f 4 >> /tmp/cache_ip
	num=$(($num +1))
done

echo "" >> $HOME/gist/remote_scan/$url/IP_$url
echo "IPv4" >> $HOME/gist/remote_scan/$url/IP_$url
cat /tmp/cache_ip | sort -n | uniq -d >> $HOME/gist/remote_scan/$url/IP_$url

echo "" >> $HOME/gist/remote_scan/$url/IP_$url
echo "IPv6" >> $HOME/gist/remote_scan/$url/IP_$url
host -t aaaa $url | grep address | cut -d " " -f 5 >> $HOME/gist/remote_scan/$url/IP_$url
echo " " >> $HOME/gist/remote_scan/$url/IP_$url
