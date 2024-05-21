#!/bin/bash

dnf install phpMyAdmin
dnf install php

service httpd restart





display_menu() {
    echo ""
    echo "|----------------------------------------------------------------------|"
    echo "| 0. Editer le profil                                                  |"
    echo "| 1. Supprimer le profil                                               |"
    echo "| q. Quit                                                              |"
    echo "|----------------------------------------------------------------------|"
    echo ""
}



edit_profil(){  

    nano /etc/httpd/conf.d/phpMyAdmin.conf

}




delete_profil(){

}



    while true; do
        display_menu
        read -p "Enter your choice: " choice
        case $choice in
            0) edit_profil ;;
            1) delete_profil ;;
            
            q|Q) clear && echo "Exiting the web server configuration wizard." && exit ;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
    done
}

main
