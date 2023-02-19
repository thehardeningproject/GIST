#!/bin/bash

# GIST - Gathering Information and Scanning Tool v0.2
# Written by: Ventre Nicolas
# URL: www.thehardeningproject.com
# Email: info@thehardeningproject.com


function urlin()
{
echo "" > /tmp/cache_dns
echo "" > /tmp/dns
echo "" > /tmp/DNS_ip
echo "" > /tmp/cache_mail
echo "" > /tmp/mail
echo "" > /tmp/MAIL_ip
echo "" > /tmp/cache_ip
echo "" > /tmp/cache_soa

echo -n "Insert URL/IP: "
read url

nslookup $url | grep Address:\ &> /dev/null
if [ $? -eq 0 ]; then
	rmt_dir="$HOME/gist/remote_scan"
	if [ -d $rmt_dir/$url ]; then
		cd $rmt_dir/$url
	else
		mkdir $rmt_dir/$url
	fi
else
	echo "The url was invalid or check network"
	bash /usr/share/gist/remote_scan.sh
fi

export url=$url

menuscan
}

function menuscan()
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
echo "   Gathering Information and Scanning Tool v0.2"
echo ""
echo "Remote Scan:"
tput sgr0
echo "1) Scan ipv4/ipv6"
echo "2) Scan Mail"
echo "3) Scan DNS"
echo "4) Scan SOA"
echo "5) Scan TXT"
echo "6) Scan Port"
echo "7) Scan OS"
echo "8) Scan Random IP"
echo "9) Scan Port & Services"
echo "10) Scan Web"
echo "11) Scan subdomain"
echo "12) Back to Menu"
echo -n "Select option: "

read remoteop
case $remoteop in
	1) bash /usr/share/gist/mods/ip.sh && menuscan;;
	2) bash /usr/share/gist/mods/mail.sh && menuscan;;
	3) bash /usr/share/gist/mods/dns.sh && menuscan;;
	4) bash /usr/share/gist/mods/soa.sh && menuscan;;
	5) bash /usr/share/gist/mods/txt.sh && menuscan;;
	6) bash /usr/share/gist/mods/port.sh && menuscan;;
	7) bash /usr/share/gist/mods/os.sh && menuscan;;
	8) bash /usr/share/gist/mods/randomip.sh && menuscan;;
	9) bash /usr/share/gist/mods/pys.sh && menuscan;;
	10) bash /usr/share/gist/mods/web.sh && menuscan;;
	11) bash /usr/share/gist/mods/subdom.sh && menuscan;;
	12) bash /usr/bin/gist;;
	*) menuscan;;
esac
}

urlin
