#!/bin/bash

dnf install phpMyAdmin
dnf install php

service httpd restart



edit_profil(){}

delete_profil(){}



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
