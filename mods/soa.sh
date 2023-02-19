#!/bin/bash

# GIST - Gathering Information and Scanning Tool v0.2
# Written by: Ventre Nicolas
# URL: www.thehardeningproject.com
# Email: info@thehardeningproject.com


echo "" >> $HOME/gist/remote_scan/$url/SOA_$url
echo "SOA:" >> $HOME/gist/remote_scan/$url/SOA_$url
host -t SOA $url | cut -d " " -f 5 >> $HOME/gist/remote_scan/$url/SOA_$url
host `host -t SOA $url | cut -d " " -f 5` | grep address | cut -d " " -f 4 >> $HOME/gist/remote_scan/$url/SOA_$url
echo "" >> $HOME/gist/remote_scan/$url/SOA_$url
host -t SOA $url | cut -d " " -f 6 >> $HOME/gist/remote_scan/$url/SOA_$url
host `host -t SOA $url | cut -d " " -f 6` | grep address | cut -d " " -f 4 >> $HOME/gist/remote_scan/$url/SOA_$url

echo "" >> $HOME/gist/remote_scan/$url/SOA_$url
host `host -t SOA $url | cut -d " " -f 6` >> /tmp/cache_soa
sed -n 1\p /tmp/cache_soa | cut -d " " -f 6 >> $HOME/gist/remote_scan/$url/SOA_$url
sed -n 2\p /tmo/cache_soa | cut -d " " -f 6 >> $HOME/gist/remote_scan/$url/SOA_$url
sed -n 3\p /tmp/cache_soa | cut -d " " -f 6 >> $HOME/gist/remote_scan/$url/SOA_$url
sed -n 4\p /tmp/cache_soa | cut -d " " -f 4 >> $HOME/gist/remote_scan/$url/SOA_$url
