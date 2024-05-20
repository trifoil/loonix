#!/bin/bash

RED='\033[0;31m' #Red
GREEN='\033[0;32m' #Red
NC='\033[0m' # No Color

display_menu() {
    echo "|-------------------------------------------|"
    echo -e "|            ${GREEN}DNS server wizard${NC}              |"
    echo "|-------------------------------------------|"
    echo "|         What do you want to do?           |"
    echo "|-------------------------------------------|"
    echo "| 0. Display UNIX users                     |"

    echo "|-------------------------------------------|"
    echo "| q. Quit                                   |"
    echo "|-------------------------------------------|"
    echo ""
}

install_dns_server() {
    sudo dnf -y install bind bind-utils
    cp -f config_files/dns/named.conf /etc/named.conf

    cp -f config_files/dns/example.com.zone /var/named/example.com.zone
    chown named:named /var/named/example.com.zone
    chown named:named /var/named/example.net.zone
    chmod 640 /var/named/example.com.zone
    chmod 640 /var/named/example.net.zone

    systemctl start named
    systemctl enable named
    systemctl status named
    echo "enabled"
    echo "Press any key to continue..."
    read -n 1 -s key

    firewall-cmd --add-service=dns --permanent
    firewall-cmd --reload
    echo "firewall done"
    echo "Press any key to continue..."
    read -n 1 -s key
}

test_dns_server() {
    dig @localhost example.com
}

main() {
	echo "Starting the samba configuration wizard..."
	sleep 1
    	while true; do
    	clear
        display_menu
        read -p "Enter your choice: " choice
        case $choice in
            0) install_dns_server ;;
            q|Q) clear && echo "Exiting the web server configuration wizard." && exit ;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
    done
}

main