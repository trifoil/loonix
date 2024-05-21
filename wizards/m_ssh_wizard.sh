display_menu() {
    echo "|-------------------------------------------|"
    echo -e "|                ${GREEN}SSH wizard${NC}                 |"
    echo "|-------------------------------------------|"
    echo "|         What do you want to do?           |"
    echo "|-------------------------------------------|"
    echo "| 0. Setup SSH key                          |"
    echo "| 1. Setup Fail2ban                         |"
    echo "|-------------------------------------------|"
    echo "| q. Quit                                   |"
    echo "|-------------------------------------------|"
    echo ""
}


fail2ban_setup() {
    systemctl start firewalld
    systemctl enable firewalld
    systemctl status firewalld

    dnf install epel-release
    dnf install fail2ban fail2ban-firewalld
    systemctl start fail2ban
    systemctl enable fail2ban
    systemctl status fail2ban
}

main() {
	echo "Starting the DNS configuration wizard..."
	sleep 1
    	while true; do
    	clear
        display_menu
        read -p "Enter your choice: " choice
        case $choice in
            1) fail2ban_setup ;;
            
            q|Q) clear && echo "Exiting the web server configuration wizard." && exit ;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
    done
}

main