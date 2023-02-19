#!/bin/bash

# GIST - Gathering Information and Scanning Tool v0.2
# Written by: Ventre Nicolas
# URL: www.thehardeningproject.com
# Email: info@thehardeningproject.com

clear

function copy_files()
{
cp -r mods/* /usr/share/gist/mods
cp -r bin/test.sh /usr/share/gist/mods
cp -r bin/local_scan.sh /usr/share/gist
cp -r bin/remote_scan.sh /usr/share/gist
cp -r bin/random.sh /usr/share/gist
cp -r bin/gist.sh /usr/bin/gist
chmod +x /usr/bin/gist
}

copy_files

if [ $? = 0 ]; then
	echo "The software has been successfully upgraded"
else
	echo "Failed, please check permissions and try again"
fi
