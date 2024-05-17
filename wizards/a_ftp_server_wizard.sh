#!/bin/bash
display_menu() {
    echo "| What do you want to do?                  |"
    echo "| 0. Install and enable ftp server (vsftpd)|"
    echo "| 1. Start ftp server                      |"
    echo "| 2. Stop ftp server                       |"
    echo "| 3. Enable ftp server                     |"    
    echo "| 4. Disable ftp server                    |"
    echo "| 5. Show ftp server status                |"
    echo "| 6. Directory attribution                 |"
    echo "| q. Quit                                  |"
}

install_ftp_server() {
    echo "Installing"
    dnf -y install vsftpd
    systemctl enable vsftpd.service
    mv /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.default
    cp config_files/ftp/vsftpd.conf /etc/vsftpd/vsftpd.conf
    chmod 600 /etc/vsftpd/vsftpd.conf

    firewall-cmd --permanent --add-port=20/tcp
    firewall-cmd --permanent --add-port=21/tcp
    firewall-cmd --reload
    firewall-cmd --list-ports

   
    echo "Press any key to continue..."
    read -n 1 -s key
    # go to script location
    sleep 1
}

start_ftp_server () {
    echo "Starting..."
    systemctl start vsftpd.service
    sleep 1
}

upload_config() {
    cp config_files/ftp/login.txt cd /etc/vsftpd/login.txt
    cd /etc/vsftpd/
    sudo dnf install epel-release
    sudo dnf install libdb-utils
    db_load -T -t hash -f login.txt login.db
    chmod 600 login.*
    cd "$(dirname "$0")"
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

directory_attribution () {
    echo "test"
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
            6) directory_attribution ;;
            q|Q) clear && echo "Exiting the web server configuration wizard." && exit ;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
        ##clear
    done
}

main