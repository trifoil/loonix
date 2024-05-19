#!/bin/bash

clear

RED='\033[0;31m' #Red
NC='\033[0m' # No Color

updatedb

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
    echo "| 6. NTP server wizard                                                  |"
    echo "|-----------------------------------------------------------------------|"
    echo "| Server health :                                                       |"
    echo "|-----------------------------------------------------------------------|"
    echo "| 7. Multitool (User policy/quota/disk-man/updates/antivirus-firewall)  |"
    echo "| 8. Backup                                                             |"
    echo "|-----------------------------------------------------------------------|"
    echo "| q. Quit                                                               |"
    echo "|-----------------------------------------------------------------------|"
    echo ""
}


# Functions to launch the scripts
nfs_share_wizard() {
    echo "Welcome to the NFS share wizard!"
    chmod +x wizards/a_nfs_share_wizard.sh
    sh wizards/a_nfs_share_wizard.sh
}

smb_share_wizard() {
    echo "Welcome to the SMB share wizard!"
    chmod +x wizards/a_smb_share_wizard.sh
    sh wizards/a_smb_share_wizard.sh
}

web_server_wizard() {
    echo "Welcome to the web server wizard!"
    chmod +x wizards/a_web_server_wizard.sh
    sh wizards/a_web_server_wizard.sh
}

ftp_server_wizard() {
    echo "Welcome to the ftp server wizard!"
    chmod +x wizards/a_ftp_server_wizard.sh
    sh wizards/a_ftp_server_wizard.sh
}

ntp_server_wizard() {
    echo "Welcome to the NTP server wizard!"
    chmod +x wizards/m_ntp_server_wizard.sh
    sh wizards/m_ntp_server_wizard.sh
}

dns_server_wizard() {
    echo "Welcome to the DNS server wizard!"
    chmod +x wizards/m_dns_server_wizard.sh
    sh wizards/m_dns_server_wizard.sh
}

# Main function
main() {
    while true; do
        display_menu
        read -p "Enter your choice: " choice
        case $choice in
            0) nfs_share_wizard ;;
            1) smb_share_wizard ;;
            2) web_server_wizard ;;
            3) ftp_server_wizard ;;
            5) dns_server_wizard ;;
            6) ntp_server_wizard ;;
            q|Q) clear && echo "Exiting the web server configuration wizard." && exit ;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
    done
}

main