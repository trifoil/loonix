#!/bin/bash

display_menu() {
    echo "| What do you want to do?      |"
    echo "| 0. Install web server        |"
    echo "| 1. Show httpd status         |"
    echo "| q. Quit                      |"
}

install_web_server() {
    echo "Installing required packages"
    dnf -y install httpd mod_ssl mod_md 
    echo "Done"
    echo "Adding the service to firewall"
    firewall-cmd --add-service=https --permanent
    firewall-cmd --add-service=http  --permanent
    firewall-cmd --reload
    echo "Starting and enabling the service"
    systemctl start httpd
    systemctl enable httpd
}

show_httpd_status(){
    systemctl status httpd
}

main() {
	dnf -y install 
	clear
	echo "Starting the web server configuration wizard..."
	sleep 1
    	while true; do
    	clear
        display_menu
        read -p "Enter your choice: " choice
        case $choice in
            0) install_web_server ;;
            1) show_httpd_status ;;
            q|Q) clear && echo "Exiting the web server configuration wizard." && exit ;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
    done
}

main
