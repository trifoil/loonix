#!/bin/bash
clear

display_menu() {
    echo "|-------------------------------------------|"
    echo "|            NTP server wizard              |"
    echo "|-------------------------------------------|"
    echo "|         What do you want to do?           |"
    echo "|-------------------------------------------|"
    echo "| 1. Setup the NTP                          |"
    echo "| 1. Choose a timezone                      |"
    echo "|-------------------------------------------|"
    echo "| q. Quit                                   |"
    echo "|-------------------------------------------|"
    echo ""
}

ip_server=$(hostname -I | sed 's/ *$//')/16

ntp_pool="server 0.pool.ntp.org iburst\\nserver 1.pool.ntp.org iburst\\nserver 2.pool.ntp.org iburst\\nserver 3.pool.ntp.org iburst"

dnf install chrony -y

systemctl enable --now chronyd

timedatectl set-timezone Europe/Brussels
timedatectl set-ntp yes

sed -i "s|#allow 192.168.0.0/16|allow $ip_server|g" /etc/chrony.conf

sed -i "s/pool 2.almalinux.pool.ntp.org iburst/$ntp_pool/g" /etc/chrony.conf

systemctl restart chronyd



chronyc tracking
chronyc sources
cat /etc/chrony.conf


echo "Press any key to continue..."
read -n 1 -s key

