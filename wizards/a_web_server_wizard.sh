    #!/bin/bash

    display_menu() {
        echo "| What do you want to do?         |"
        echo "| 0. Install web server           |"
        echo "| 1. Show httpd status            |"
        echo "| 2. Create web dir for user      |"
        echo "| 3. Remove web directory of user |"
        echo "| 4. Display web directories      |"
        echo "| q. Quit                         |"
    }

    install_web_server() {
        echo "Installing required packages"
        dnf -y install httpd mod_ssl mod_md 
        echo "Done"
        echo "Adding the service to firewall"
        firewall-cmd --add-service=https --permanent
        firewall-cmd --add-service=http  --permanent
        firewall-cmd --reload
        echo "Starting and enabling the service"
        systemctl start httpd
        systemctl enable httpd
    }

    show_httpd_status() {
        systemctl status httpd
    }

    create_user_dir() {
        display_submenu() {
            echo "Select a user to create a directory for:"
            i=1
            
            for user in $(getent passwd | awk -F: '$3 >= 1000 && $3 < 65534 {print $1}'); do
                echo "$i. $user"
                ((i++))
            done
            echo "q. Quit"
            echo -n "Enter your choice: "
        }
        
        create_directory() {
            users=($(getent passwd | awk -F: '$3 >= 1000 && $3 < 65534 {print $1}'))
            selected_user="${users[$1-1]}"
            cd /srv
            mkdir -p "$selected_user"
            echo "Directory '$selected_user' created successfully."
        }

        # Main menu loop
        while true; do
            display_submenu
            read choice
            
            if [[ "$choice" == [qQ] ]]; then
                echo "Aborting..."
                break
            elif [[ $choice -gt 0 && $choice -le $(($(getent passwd | awk -F: '$3 >= 1000 && $3 < 65534' | wc -l) + 1)) ]]; then
                create_directory "$choice"
            else 
                echo "Invalid input"
            fi
        done
    }

    delete_user_dir() {
            
        display_submenu() {
            echo "Select a user to remove a directory for:"
            i=1
            
            for user in $(getent passwd | awk -F: '$3 >= 1000 && $3 < 65534 {print $1}'); do
                echo "$i. $user"
                ((i++))
            done
            echo "q. Quit"
            echo -n "Enter your choice: "
        }
        
        delete_directory() {
            users=($(getent passwd | awk -F: '$3 >= 1000 && $3 < 65534 {print $1}'))
            selected_user="${users[$1-1]}"
            cd /srv
            rm -rf "$selected_user"
            echo "Directory '$selected_user' erased successfully."
        }

        # sub menu loop
        while true; do
            display_submenu
            read choice
            
            if [[ "$choice" == [qQ] ]]; then
                echo "Aborting..."
                break
            elif [[ $choice -gt 0 && $choice -le $(($(getent passwd | awk -F: '$3 >= 1000 && $3 < 65534' | wc -l) + 1)) ]]; then
                delete_directory "$choice"
            else 
                echo "Invalid input"
            fi
        done
    }

    display_user_dir() {
        cd /srv
        ls -l
        echo "Press any key to continue..."
        read -n 1 -s key
        echo ""
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
                0) install_web_server ;;
                1) show_httpd_status ;;
                2) create_user_dir ;;
                3) delete_user_dir ;;
                4) display_user_dir ;;
                q|Q) clear && echo "Exiting the web server configuration wizard." && exit ;;
                *) clear && echo "Invalid choice. Please enter a valid option." ;;
            esac
        done
    }

    main