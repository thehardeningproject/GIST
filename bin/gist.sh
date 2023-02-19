#!/bin/bash

# GIST - Gathering Information and Scanning Tool v0.2
# Written by: Ventre Nicolas
# URL: www.thehardeningproject.com
# Email: info@thehardeningproject.com


# call randon menu

function menu()
{

bash /usr/share/gist/random.sh

echo "1) Local Scan Menu"
echo "2) Remote Scan Menu"
echo "3) Exit"
echo -n "Select option: "

read opmenu

case $opmenu in
	1) bash /usr/share/gist/local_scan.sh;;
	2) bash /usr/share/gist/remote_scan.sh;;
	3) clear && exit;;
	*) menu;;
esac

}


# help menu

case $1 in
	"-h"|"--help")
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
			echo " Just run gist and have fun"
			echo ""
			echo " For more info go to:"
			echo " https://thehardeningproject.com/gist"
			echo " Or email to:"
			echo " info@thehardeningproject.com"
			echo ""
			tput sgr0
			;;
	"") menu;;
	*)
	clear
	echo ""
	tput setaf 1
	echo "Invalid Option"
	echo "Put the option -h or --help for help"
	tput sgr0
	echo ""
	exit 0
	;;
esac
