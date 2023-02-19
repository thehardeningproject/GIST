#!/bin/bash

# GIST - Gathering Information and Scanning Tool v0.2
# Written by: Ventre Nicolas
# URL: www.thehardeningproject.com
# Email: info@thehardeningproject.com

clear

function remove()
{
echo "This script will uninstall GIST of your system and all the directories created in the installation"
echo "You want to continue? [Y/n]"
read option

case $option in
	[yY])
		rm -rf $HOME/GIST
		rm -rf /usr/bin/gist
		rm -rf /usr/share/gist
		echo "Uninstall successfully"
		;;
	[nN]) exit;;
	*) clear && remove;;
esac
knowingdistro
}

function knowingdistro()
{
    # Test distributios derived from RedHat
    if [ -r /etc/rc.d/init.d/functions ]; then
        source /etc/rc.d/init.d/functions
        [ zz`type -t passed 2>/dev/null` == "zzfunction" ] && distro="redhat"

    # Test Debian, Ubuntu
    elif [ -r /lib/lsb/init-functions ]; then
        source /lib/lsb/init-functions
        [ zz`type -t log_begin_msg 2>/dev/null` == "zzfunction" ] && distro="debian"
    fi
uninstall_dep
}

function uninstall_dep()
{
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    GREEN='\033[0;32m'
    dependencies="nmap bind-utils python36"
	read -rp "Do you want to uninstall nmap, bind-utils and python36? [y/n]: " response
	case "$response" in
		[yY])
			if [ -z $distro ] || [ $distro = debian ]; then
				for i in $dependencies
        		do
					if dpkg-query -s "$i" &> /dev/null; then
						sudo apt-get remove -y "$i"
						echo "All dependencies were uninstalled"
					else
						echo "Dependencies already uninstalled"
					fi
				done
			else
				for i in $dependencies
        		do
					if rpm -qs "$i" &> /dev/null; then
						sudo yum erase -y "$i"
						echo "All dependencies were uninstalled"
					else
						echo "Dependencies already uninstalled"
					fi
				done
			fi
			;;
		[nN])
			echo -e "${RED}Skipping $i, must be erased manually.${NC}"
			;;
		*)
			echo -e "${RED}Invalid input. Please enter y or n.${NC}"
			uninstall_dep
			;;
    esac
}

remove
