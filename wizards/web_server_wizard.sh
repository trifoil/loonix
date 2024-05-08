#!/bin/bash

display_menu() {
    echo "| What do you want to do?      |"
    echo "| 0. Install web server        |"
    echo "| q. Quit                      |"
}

install_web_server() {
    echo "test"
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
            0) display_unix_users ;;
            1) install_web_server ;;
            q|Q) clear && echo "Exiting the web server configuration wizard." && exit ;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
    done
}

main