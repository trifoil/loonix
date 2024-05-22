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

    # cp -f config_files/mail/main.cf /etc/postfix/main.cf
    # cp -f config_files/mail/dovecot.conf /etc/dovecot/dovecot.conf
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