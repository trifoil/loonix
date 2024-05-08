#!/bin/bash
display_menu() {
    echo "| What do you want to do?                  |"
    echo "| 0. Install and enable ftp server (vsftpd)|"
    echo "| 1. Start ftp server                      |"
    echo "| 2. Stop ftp server                       |"
    echo "| 3. Disable ftp server                    |"    
    echo "| 4. Enable ftp server                     |"
    echo "| 5. show ftp server status                |"
    echo "| 6.                                       |"
    echo "| q. Quit                                  |"
}

install_ftp_server() {
    echo "Installing"
    dnf -y install vsftpd
    systemctl enable vsftpd.service
    sleep 1
}

start_ftp_server () {
    echo "Starting..."
    systemctl start vsftpd.service
    sleep 1
}

stop_ftp_server () {
    echo "Stopping..."
    systemctl stop vsftpd.service
    sleep 1
}

enable_ftp_server () {
    echo "Enabling..."
    systemctl enable vsftpd.service
    sleep 1
}

disable_ftp_server () {
    echo "Disabling..."
    systemctl disable vsftpd.service
    sleep 1
}

show_ftp_status () {
    systemctl status vsftpd.service
}

main() {
    while true; do
        clear
        display_menu
        read -p "Enter your choice: " choice
        case $choice in
            0) install_ftp_server ;;
            1) start_ftp_server ;;
            2) stop_ftp_server ;;
            3) enable_ftp_server ;;
            4) disable_ftp_server ;;
            5) show_ftp_status ;;
            q|Q) clear && echo "Exiting the web server configuration wizard." && exit ;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
        ##clear
    done
}

main