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


port_ssh=6666

#Remplace le port ssh par un port personnalisé
sed -i -e "s/#Port 22/Port $port_ssh/g" -e "s/Port 22/Port $port_ssh/g" /etc/ssh/sshd_config

#Desactive root en ssh
sed -i -e "s/#PermitRootLogin yes/PermitRootLogin no/g" -e "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config

#Desactive le login par mot de passe
sed -i -e "s/#PasswordAuthentication yes/PasswordAuthentication no/g" -e "s/PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config

#Active l'authentification par clé
sed -i -e "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/g" -e "s/PubkeyAuthentication no/PubkeyAuthentication yes/g" /etc/ssh/sshd_config

#Redémarre le service sshd
systemctl restart sshd