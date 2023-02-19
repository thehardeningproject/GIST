#!/bin/bash

# GIST - Gathering Information and Scanning Tool v0.2
# Written by: Ventre Nicolas
# URL: www.thehardeningproject.com
# Email: info@thehardeningproject.com


#For the next section we describe a sample scan

function local_menu()
{
clear
tput setaf 1
echo ""
echo "		   GGGGG IIIII SSSSS TTTTT"
echo "		   G       I   S       T"
echo "		   G GGG   I   SSSSS   T"
echo "		   G   G   I       S   T"
echo "		   GGGGG IIIII SSSSS   T"
echo ""
echo "   Gathering Information and Scanning Tool 0.2"
echo ""
echo "   You can see logs in $HOME/gist/local_scan"
echo "Local Scan:"
tput sgr0
echo "1) Scan Network for Live Hosts"
echo "2) Local Network Scan (Ports, Services, OS)"
echo "3) Detect network shared folders with write permissions"
echo "4) Check My OS"
echo "5) Back to Menu"
echo -n "Select option: "

read option
case $option in
	1) scanlivenet;;
	2) local_net_scan;;
	3) bash /usr/share/gist/mods/shares.sh && local_menu;;
	4) bash /usr/share/gist/mods/test.sh && local_menu;;
	5) bash /usr/bin/gist;;
	*) local_menu;;
esac
}

# 1 - Scan Network for Live Hosts
function scanlivenet()
{
iface=`ip addr show | grep "state UP" | awk '{print $2}' | cut -f1 -d":"`
ip=`ip addr show $iface | grep -v inet6 | grep 'inet' | sed 's/^[ \t]*//' | cut -f2 -d" " | cut -f1 -d"/"`
mask=`ip addr show $iface | grep -v inet6 | grep 'inet' | sed 's/^[ \t]*//' | cut -f2 -d" " | cut -f2 -d"/"`

lan=`echo $ip | cut -d "." -f 1-3`

nmap -oN "$HOME/gist/local_scan/live_host.txt" -oG - -sP $lan.0/$mask | awk '/Up$/{printf $2 ", "}{print}' | sed 's/,$//' | tr ' ' ',' > "$HOME/gist/local_scan/live_host.csv"

local_menu
}

# 3 - Local Network Scan (Ports, Services, OS)
function local_net_scan()
{
iface=`ip addr show | grep "state UP" | awk '{print $2}' | cut -f1 -d":"`
ip=`ip addr show $iface | grep -v inet6 | grep 'inet' | sed 's/^[ \t]*//' | cut -f2 -d" " | cut -f1 -d"/"`
mask=`ip addr show $iface | grep -v inet6 | grep 'inet' | sed 's/^[ \t]*//' | cut -f2 -d" " | cut -f2 -d"/"`

lan=`echo $ip | cut -d "." -f 1-3`

nmap -sS -O -sV -D RND:5 $lan.0/$mask -oN $HOME/gist/local_scan/live_host_data

local_menu
}

local_menu
