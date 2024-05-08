#!/bin/bash

archive_function() {
# get the directory path input from the user
echo "Please enter the directory path :"
read directory_path

# Check if the directory path is empty
if [ -z "$directory_path" ]; then
    echo "Error: Directory path cannot be empty."
    exit 1
fi

# Check if the directory already exists
if [ -d "$directory_path" ]; then
    echo "Directory '$directory_path' already exists."
    exit 0
fi

#create the dir
mkdir -p "$directory_path"

#check if the dir is created correctly
if [ $? -eq 0 ]; then
    echo "Directory '$directory_path' created successfully."
else
    echo "Failed to create directory '$directory_path'."
    exit 1
fi
}

display_menu() {
    echo "| What do you want to do?      |"
    echo "| 0. Display UNIX users        |"
    echo "| 1. Display SMB user          |"
    echo "| 2. Add UNIX users            |"
    echo "| 3. Add SMB user              |"
    echo "| 4. Remove SMB user           |"
    echo "| 5. Remove all SMB users      |"
    echo "| 6. Disable SMB user          |"
    echo "| 7. Enable SMB user           |"
    echo "| q. Quit                      |"

}

display_unix_users() {
    getent passwd | awk -F: '$3 >= 1000 && $3 < 65534 {print $1}'
    echo "Press any key to continue..."
    read -n 1 -s key
    echo "" 
}

display_smb_users() {
clear
    echo "These smb users already exist :"
    sudo pdbedit -L -w
    echo "Press any key to continue..."
    read -n 1 -s key
    echo ""
}

add_unix_user() {
    echo "which unix user do you want to add?"
    read unixuser
    useradd $unixuser
}

add_smb_user() {
    echo "which smb user do you want to add?"
    read smbuser
    smbpasswd -a $smbuser
}

remove_smb_user() {
    echo "which smb user do you want to remove?"
    read smbuser
    sudo smbpasswd -x $smbuser
}

remove_all_smb_users() {
    echo "RIP to all smb users"
    # Get a list of all Samba users
    users=$( pdbedit -L -v | awk -F: '/Unix username:/ {print $2}' | tr -d ' ')

    # Remove each user
    for user in $users; do
    smbpasswd -x "$user"
    done
}

main() {
	# install samba if not installed already
	dnf -y install samba
	clear
	echo "Starting the samba configuration wizard..."
	sleep 1
    	while true; do
    	clear
        display_menu
        read -p "Enter your choice: " choice
        case $choice in
            0) display_unix_users ;;
            1) display_smb_users ;;
            2) add_unix_user ;;
            3) add_smb_user ;;
            4) remove_smb_user ;;
            5) remove_all_smb_users ;;
            q|Q) clear && echo "Exiting the web server configuration wizard." && exit ;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
    done
}

main