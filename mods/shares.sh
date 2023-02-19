#!/bin/bash

# GIST - Gathering Information and Scanning Tool v0.2
# Written by: Ventre Nicolas
# URL: www.thehardeningproject.com
# Email: info@thehardeningproject.com

# Prompt the user for a CIDR range
echo "Enter a CIDR range (e.g. 192.168.1.0/24): "
read cidr_range

# Use nmap to scan the CIDR range and get a list of available IP addresses
ips=$(nmap -sn $cidr_range | grep 'Nmap scan report for' | awk '{ print $5 }')

# Create a log file
netcidr=$(echo $cidr_range | cut -d"/" -f1)
echo "IP,Share,Write permission" > $HOME/gist/local_scan/sharedfolders-$netcidr.csv

# Loop through each IP address
for ip in $ips; do
    echo "IP: $ip" >/dev/null

    # Use smbclient to list the shared folders for the current IP
    shares=$(smbclient -L //$ip -U% 2>/dev/null | grep 'Disk' | awk '{ print $1 }')

    # Loop through each shared folder
    for share in $shares; do
        write_permission=$(smbclient -U% //$ip/$share -c 'quit' 2>&1 | grep 'NT_STATUS_ACCESS_DENIED')
        if [ -z "$write_permission" ]; then
            write_permission="yes"
        else
            write_permission="no"
        fi
            if [ $write_permission = yes ]; then
            echo "Shared folders win write permissions was found"
            echo "You can see logs in '$HOME/gist/local_scan/sharedfolders-$netcidr.csv'"
            echo "$ip,$share,$write_permission" >> $HOME/gist/local_scan/sharedfolders-$netcidr.csv
            fi
    done

    # Add a line break between each IP
    echo ""
done
