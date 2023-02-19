#!/bin/bash

# GIST - Gathering Information and Scanning Tool v0.2
# Written by: Ventre Nicolas
# URL: www.thehardeningproject.com
# Email: info@thehardeningproject.com


#Random Bash Banner
function a()
{
clear
tput setaf 1
echo ""
echo "             GGGGG IIIII SSSSS TTTTT"
echo "             G       I   S       T"
echo "             G GGG   I   SSSSS   T"
echo "             G   G   I       S   T"
echo "             GGGGG IIIII SSSSS   T"
echo ""
echo "   Gathering Information and Scanning Tool v0.2"
echo ""
echo "GIST:"
tput sgr0
}

function b()
{
clear
tput setaf 1
echo ""
echo ""
echo ""
echo "               G     I     S     T"
echo ""
echo ""
echo ""
echo "   Gathering Information and Scanning Tool v0.2"
echo ""
echo "GIST:"
tput sgr0
}

function c()
{
clear
tput setaf 1
echo "            ___  _____  _____  _____"
echo "           |       |   |         |"
echo "           |       |   |         |"
echo "           | __    |   ------    |"
echo "           |   |   |        |    |"
echo "           |___| __|__ _____|    |"
echo ""
echo "   Gathering Information and Scanning Tool v0.2"
echo ""
echo "GIST:"
tput sgr0
}

function d()
{
clear
tput setaf 1
echo ""
echo ""
echo ""
echo "       01100111 01101001 01110011 01110100"
echo ""
echo ""
echo ""
echo "   Gathering Information and Scanning Tool v0.2"
echo ""
echo "GIST:"
tput sgr0
}


num=`cat /dev/urandom| tr -dc 'a-d'|head -c 1`

$num
