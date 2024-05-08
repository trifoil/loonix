#!/bin/bash

# Function to create a logical volume and mount it
create_logical_volume() {
    # Find the volume group name
    volume_group=$(sudo vgdisplay | awk '/VG Name/ {print $3}')

    # Prompt the user to enter the size of the logical volume in GB
    read -p "Enter the size of the logical volume in GB: " lv_size

    # Create a logical volume of the specified size
    sudo lvcreate -L "${lv_size}G" -n srv_volume "/dev/${volume_group}"

    # Format the logical volume with the ext4 filesystem
    sudo mkfs.ext4 "/dev/${volume_group}/srv_volume"

    # Mount the logical volume on /srv (or /var/www based on user choice)
    sudo mkdir -p /srv
    sudo mount "/dev/${volume_group}/srv_volume" /srv
    sudo chmod 777 /srv   # Adjust permissions as needed
}

# Prompt the user to choose the mount point
read -p "Choose mount point (1 for /srv, 2 for /var/www): " mount_choice

case $mount_choice in
    1)
        create_logical_volume
        echo "Logical volume created and mounted on /srv successfully."
        ;;
    2)
        create_logical_volume
        echo "Logical volume created and mounted on /var/www successfully."
        ;;
    *)
        echo "Invalid choice. Please choose 1 for /srv or 2 for /var/www."
        ;;
esac
