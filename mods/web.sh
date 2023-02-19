#!/bin/bash

# GIST - Gathering Information and Scanning Tool v0.2
# Written by: Ventre Nicolas
# URL: www.thehardeningproject.com
# Email: info@thehardeningproject.com


wget --no-check-certificate -qcO $HOME/gist/remote_scan/$url/robots.txt $url/robots.txt

wget --no-check-certificate -qcrpO $HOME/gist/remote_scan/$url/index.html $url


echo "" >> $HOME/gist/remote_scan/$url/Info_$url
echo "WHOIS:" >> $HOME/gist/remote_scan/$url/Info_$url
whois $url >> $HOME/gist/remote_scan/$url/Info_$url

echo "" >> $HOME/gist/remote_scan/$url/Info_$url
echo "" >> $HOME/gist/remote_scan/$url/Info_$url
echo "" >> $HOME/gist/remote_scan/$url/Info_$url
echo "NSLOOKUP:" >> $HOME/gist/remote_scan/$url/Info_$url
nslookup -query=any $url >> $HOME/gist/remote_scan/$url/Info_$url
