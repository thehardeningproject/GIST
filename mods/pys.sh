#!/bin/bash

# GIST - Gathering Information and Scanning Tool v0.2
# Written by: Ventre Nicolas
# URL: www.thehardeningproject.com
# Email: info@thehardeningproject.com


nmap -sV -sS $url -oN $HOME/gist/remote_scan/$url/Port_Service_$url
