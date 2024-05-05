#!/bin/bash

function is_root() {
  if [ "$(id -u)" -eq 0 ]; then # you are root, set prompt password
    return
  else # normal
    sudo -v
  fi
}

is_root

read -r -p "Enter subdomain: " subdomain
domain="${subdomain}.linoux"

if grep "${domain}" /etc/passwd >/dev/null 2>&1; then
  ## setup user
  sudo userdel -M -s /usr/sbin/nologin "$domain"

  ## setup dns record
  "include \"/etc/named.${domain}.zones\";" | sudo tee -a /etc/named.conf

  sudo rm "/etc/named.${domain}.zones"
  sudo rm "/etc/named/${domain}.frw"
  #sed -i "/64\s*IN\s*PTR\s*${domain}\./d" "/etc/named/reverse"
  #  sed -i "64      IN      PTR     ${domain}." "/etc/named/reverse"

  sudo systemctl restart named.service

  # setup samba share
  sudo rm -a "/etc/samba/smb.d/${domain}.conf"

  #sed -i "/include\s*=\s*\/etc\/samba\/smb\.d\/${domain}\.conf/d" "/etc/samba/smb.conf"
  #sed -i "include = /etc/samba/smb.d/${domain}.conf" "/etc/samba/smb.conf"
  sudo smbcontrol all reload-config

  ## setup apache
  sudo rm -rf "/www/${domain}"
  sudo rm -rf "/etc/httpd/site-availible/${domain}"
  sudo rm -rf "/etc/httpd/site-enabled/${domain}"

  sudo apachectl -k graceful

  ## setup mariadb

  sudo mariadb -e "DROP USER ${subdomain};"
  sudo mariadb -e "DROP DATABASE \`${subdomain}\`;"

  # TODO : add remove vfstp
fi
