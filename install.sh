#!/bin/bash

# GIST - Gathering Information and Scanning Tool v0.2
# Written by: Ventre Nicolas
# URL: www.thehardeningproject.com
# Email: info@thehardeningproject.com

clear

# Check older versions
function chkolder()
{
chkfile="/usr/bin/gist"
	if [ -a $chkfile ]; then
		chkver=`cat /usr/bin/gist |grep "v0" | awk '{print $9}'`
		if [ $chkver = "v0.2" ]; then
			tput setaf 1
			echo ""
			echo " You have the latest version of GIST "
			echo ""
			tput sgr0
		else
			chmod +x upgrade.sh
			./upgrade.sh
		fi
	else
		echo "Installing GIST..."
	fi
}

# Know Distro
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
    echo "Distro: Based on $distro"
installgist
install_dep
}

# Install dependencies
function install_dep()
{
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    GREEN='\033[0;32m'
    dependencies="nmap bind-utils python36"
    if [ -z $distro ] || [ $distro = debian ]; then
        for i in $dependencies
        do
            if ! dpkg-query -s "$i" &> /dev/null; then
            echo -e "${RED}The dependency $i was not found.${NC}"
            read -rp "Do you want to install it? [y/n]: " response
                case "$response" in
                    [yY])
                        if command -v apt-get &> /dev/null; then
                            sudo apt-get install -y "$i"
                        else
                            echo -e "${RED}Could not find a package manager to install $i.${NC}"
                            exit 1
                        fi
                        ;;
                    [nN])
                        echo -e "${RED}Skipping $i installation, must be installed manually.${NC}"
                        ;;
                    *)
                        echo -e "${RED}Invalid input. Please enter y or n.${NC}"
                        install_dep
                        ;;
                esac
            else
                echo -e "${GREEN}The dependency $i is already installed.${NC}"
            fi
        done
    else
        for i in $dependencies
        do
            if ! rpm -qs "$i" &> /dev/null; then
            echo -e "${RED}The dependency $i was not found.${NC}"
            read -rp "Do you want to install it? [y/n]: " response
                case "$response" in
                    [yY])
                        if command -v yum &> /dev/null; then
                            sudo yum install -y "$i"
                        else
                            echo -e "${RED}Could not find a package manager to install $i.${NC}"
                            exit 1
                        fi
                        ;;
                    [nN])
                        echo -e "${RED}Skipping $i installation, must be installed manually.${NC}"
                        ;;
                    *)
                        echo -e "${RED}Invalid input. Please enter y or n.${NC}"
                        install_dep
                        ;;
                esac
            else
                echo -e "${GREEN}The dependency $i is already installed.${NC}"
            fi
        done
    fi
}

#Make directories and copy files.
function make_dir()
	{
		gist_dir="$HOME/gist/"
		lnd_dir="$HOME/gist/local_scan"
		rmt_dir="$HOME/gist/remote_scan"
		soft_dir="/usr/share/gist"
		soft_mod="/usr/share/gist/mods"
		if [ -d $gist_dir ] && [ -d $lnd_dir ] && [ -d $rmt_dir ] && [ -d $soft_dir ] && [ -d $soft_mod ]; then
			echo "Directory already exist"			
		else
			mkdir -p $gist_dir && mkdir -p $lnd_dir && mkdir -p $rmt_dir && mkdir -p $soft_dir && mkdir -p $soft_mod
		fi
	}

function copy_files()
	{
		cp -r mods/* /usr/share/gist/mods
		cp -r bin/test.sh /usr/share/gist/mods
		cp -r bin/local_scan.sh /usr/share/gist
		cp -r bin/remote_scan.sh /usr/share/gist
		cp -r bin/random.sh /usr/share/gist
		cp -r bin/gist.sh /usr/bin/gist
		chmod +x /usr/bin/gist
			tput setaf 1
			echo ""
			echo " Done now run gist to initialize"
			echo ""
			tput sgr0
	}


#In the next lines we install the packets necessary for the script.

function installgist()
{
	if [ -z $distro ] || [ $distro = debian ]; then
        dpkg-query -s wget &> /dev/null
		if [ $? = 0 ]; then
			wget -O index.html -q --tries=10 --timeout=5 google.com
			if [ $? = 0 ]; then
				rm index.html
				chkolder
			else
				echo " Fail to make connection, can't install the following dependencies:"
				echo " Nmap, bind-utils, python, whois"
				echo " Check your network connection"
			fi
		else
			echo "We need wget, but you don't have it. Do you want to install wget? y/n"
			read -a internetcheck
			case $internetcheck in
				[yY])
					apt-get install -y wget
					echo "The dependency wget was successfully installed"
					;;
				[*])
					echo "You need to install dependency manually"
					;;
			esac
		fi
	else
		rpm -qs wget &> /dev/null
		if [ $? = 0 ]; then
			wget -O index.html -q --tries=10 --timeout=5 google.com
			if [ $? = 0 ]; then
				rm index.html
				chkolder
			else
				echo " Fail to make connection, can't install the following dependencies:"
				echo " Nmap, dnsutils/bind-utils, python, whois"
				echo " Check your network connection"
			fi
		else
			echo "We need wget, but you don't have it. Do you want to install wget? y/n"
			read -a internetcheck
			case $internetcheck in
				[yY])
					yum install -y wget
					echo "The dependency wget was successfully installed"
					;;
				[*])
					echo "You need to install dependency manually"
					;;
			esac
		fi
	fi
}
knowingdistro
make_dir
copy_files