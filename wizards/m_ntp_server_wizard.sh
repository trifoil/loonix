#!/bin/bash

ip_server=$(hostname -I | sed 's/ *$//')/16

ntp_pool="server 0.pool.ntp.org iburst\\nserver 1.pool.ntp.org iburst\\nserver 2.pool.ntp.org iburst\\nserver 3.pool.ntp.org iburst"

dnf install chrony -y

systemctl enable --now chronyd

timedatectl set-timezone Europe/Brussels
timedatectl set-ntp yes

sed -i "s|#allow 192.168.0.0/16|allow $ip_server|g" /etc/chrony.conf

sed -i "s/pool 2.almalinux.pool.ntp.org iburst/$ntp_pool/g" /etc/chrony.conf

systemctl restart chronyd