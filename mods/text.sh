#!/bin/bash

# GIST - Gathering Information and Scanning Tool v0.2
# Written by: Ventre Nicolas
# URL: www.thehardeningproject.com
# Email: info@thehardeningproject.com


echo "TXT:" >> $HOME/gist/remote_scan/$url/TXT_$url
host -t TXT $url | cut -d " " -f 5 >> $HOME/gist/remote_scan/$url/TXT_$url
echo " " >> $HOME/gist/remote_scan/$url/TXT_$url
host -t TXT $url | cut -d " " -f 6 >> $HOME/gist/remote_scan/$url/TXT_$url
