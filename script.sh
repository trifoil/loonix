#!/bin/bash

clear

RED='\033[0;31m' #Red
NC='\033[0m' # No Color

# Function to display the menu
display_menu() {
    echo ""
    echo "|-----------------------------------------------------------------------|"
    echo -e "| ${RED}It is advised to do a big prayer now or this installer may not work${NC}   |"
    echo "| Please select the tool you want to use :                              |"
    echo "|-----------------------------------------------------------------------|"
    echo "| Networking :                                                          |"
    echo "|-----------------------------------------------------------------------|"
    echo "| 0. NFS share wizard                                                   |"
    echo "| 1. SMB share wizard                                                   |"
    echo "| 2. Web server wizard                                                  |"
    echo "| 3. FTP server wizard                                                  |"
    echo "| 4. MySQL server wizard                                                |"
    echo "| 5. DNS server wizard                                                  |"
    echo "| 6. NTP server wizard                                                 |"
    echo "|-----------------------------------------------------------------------|"
    echo "| Server health :                                                       |"
    echo "|-----------------------------------------------------------------------|"
    echo "| 7. Multitool (User policy/quota/disk-man/updates/antivirus-firewall)  |"
    echo "| 8. Backup                                                             |"
    echo "|-----------------------------------------------------------------------|"
    echo ""
}
nfs_share_wizard() {
    echo "Welcome to the NFS share wizard!"
    chmod +x 
}
ntp_server_wizard() {
    echo "Welcome to the NTP server wizard!"
}

# Main function
main() {
    while true; do
        display_menu
        read -p "Enter your choice: " choice
        case $choice in
            0) nfs_share_wizard ;;
            6) ntp_server_wizard ;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
        ##clear
    done
}

main