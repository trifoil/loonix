#!/bin/bash

RED='\033[0;31m' #Red
GREEN='\033[0;32m' #Red
NC='\033[0m' # No Color

display_menu() {
    echo "|-------------------------------------------|"
    echo -e "|            ${GREEN}MAIL server wizard${NC}             |"
    echo "|-------------------------------------------|"
    echo "|         What do you want to do?           |"
    echo "|-------------------------------------------|"
    echo "| 0. Install mail server                    |"
    echo "|-------------------------------------------|"
    echo "| q. Quit                                   |"
    echo "|-------------------------------------------|"
    echo ""
}


install_mail_server() {
    dnf update -y
    dnf install postfix dovecot -y
    sudo nano /etc/postfix/main.cf
    nano /etc/dovecot/dovecot.conf
    nano /etc/dovecot/conf.d/10-mail.conf
    nano /etc/dovecot/conf.d/10-auth.conf
    nano /etc/dovecot/conf.d/10-master.conf

    cp -f config_files/mail/main.cf /etc/postfix/main.cf
    cp -f config_files/mail/dovecot.conf /etc/dovecot/dovecot.conf
    cp -f config_files/mail/10-auth.conf /etc/dovecot/conf.d/10-auth.conf
    cp -f config_files/mail/10-master.conf /etc/dovecot/conf.d/10-master.conf

    systemctl start postfix
    systemctl enable postfix
    systemctl start dovecot
    systemctl enable dovecot

    firewall-cmd --permanent --add-service=smtp
    firewall-cmd --permanent --add-service=imap
    firewall-cmd --permanent --add-service=pop3
    firewall-cmd --reload

    #setup des dns etc etc

    dnf install opendkim opendkim-tools -y
    mkdir /etc/opendkim
    opendkim-genkey -D /etc/opendkim/ -d mankou.local -s default
    mv /etc/opendkim/default.private /etc/opendkim/private.key

    systemctl reload named

    #testing
    adduser testuser
    passwd testuser

    echo "Test email body" | mail -s "Test Email" testuser@yourdomain.com
    echo "Press any key to continue..."
    read -n 1 -s key
}

main() {
	echo "Starting the DNS configuration wizard..."
	sleep 1
    	while true; do
    	clear
        display_menu
        read -p "Enter your choice: " choice
        case $choice in
            0) install_mail_server ;;
            q|Q) clear && echo "Exiting the web server configuration wizard." && exit ;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
    done
}

main    