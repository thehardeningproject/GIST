#!/bin/bash

# GIST - Gathering Information and Scanning Tool v0.2
# Written by: Ventre Nicolas
# URL: www.thehardeningproject.com
# Email: info@thehardeningproject.com


nmap -sS $url -oN $HOME/gist/remote_scan/$url/Port_$url
