#!/bin/bash
display_menu() {
    echo "|-------------------------------------------|"
    echo "|         What do you want to do?           |"
    echo "|-------------------------------------------|"
    echo "| ❶. Install and enable ftp server (vsftpd)|"
    echo "| ❷. Start ftp server                      |"
    echo "| ❸. Stop ftp server                       |"
    echo "| ❹. Enable ftp server                     |"    
    echo "| ❺. Disable ftp server                    |"
    echo "| ❻. Show ftp server status                |"
    echo "| ❼. Directory attribution                 |"
    echo "| ❽. Load config files                     |"
    echo "| ❾. PAM config                            |"
    echo "|-------------------------------------------|"
    echo "| q. Quit                                   |"
    echo "|-------------------------------------------|"

}

install_ftp_server() {
    echo "Installing"
    dnf -y install vsftpd
    systemctl enable vsftpd.service
    mv -f /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.default
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

upload_config() {
    cp -f config_files/ftp/login.txt /etc/vsftpd/login.txt
    sudo dnf -y install libdb-utils
    mkdir /etc/vsftpd/vsftpd_user_conf
    txt2db /etc/vsftpd/login.txt /etc/vsftpd/login.db
    cleanconf
    cp -f config_files/ftp/pam/vsftpd /etc/pam.d/vsftpd
    systemctl restart vsftpd.service
    echo "Press any key to continue..."
    read -n 1 -s key
}

txt2db() {
    if [ $# = "2" ]; then
        rm -f $2
        db_load -T -t hash -f $1 $2
        chmod 600 /etc/vsftpd/login.*
        echo "Base crée"
        lignes=$(cat $1)
        nb=1
        for ligne in $lignes
        do
            if [ $(($nb%2)) -ne 0  ];
            then
                if [ ! -e vsftpd_user_conf/$ligne ];
                then
                    touch /etc/vsftpd/vsftpd_user_conf/$ligne
                    echo "fichier $ligne crée"
                fi
            fi
            nb=$(($nb+1))
        done
    else
        echo "Il faut donner le fichier d'entrée et le fichier de sortie"
    fi
    echo "text2db done"
    echo "Press any key to continue..."
    read -n 1 -s key
}

cleanconf() {
    fichiers=$(ls /etc/vsftpd/vsftpd_user_conf)
    users=""
    lignes=$(cat /etc/vsftpd/login.txt)
    nb=1
    for ligne in $lignes
    do
        if [ $(($nb%2)) -ne 0  ];
        then
            users="$users $ligne"
        fi
    nb=$(($nb+1))
    done
    for conf in $fichiers
    do
    found=0
    for user in $users
    do
        if [ $conf = $user ];
        then
            found="1"
        fi
    done
    if [ $found != "1" ];
    then
        rm -f vsftpd_user_conf/$conf
        echo "Fichier $conf supprimé"
    fi
    done
    echo "cleanconf done"
    echo "Press any key to continue..."
    read -n 1 -s key
}

pam_config() {
    cp -f config_files/ftp/pam/vsftpd /etc/pam.d/vsftpd
    systemctl restart vsftpd.service
    echo "Done"
    echo "Press any key to continue..."
    read -n 1 -s key
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
        sleep 1

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
            1) install_ftp_server ;;
            2) start_ftp_server ;;
            3) stop_ftp_server ;;
            4) enable_ftp_server ;;
            5) disable_ftp_server ;;
            6) show_ftp_status ;;
            7) directory_attribution ;;
            8) upload_config ;;
            9) pam_config ;;
            q|Q) clear && echo "Exiting the web server configuration wizard." && exit ;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
        ##clear
    done
}

main