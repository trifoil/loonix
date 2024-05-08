#!/bin/bash

# Function to create a logical volume and mount it
create_logical_volume() {
    # Find the volume group name
    volume_group=$(sudo vgdisplay | awk '/VG Name/ {print $3}')

    # Prompt the user to enter the size of the logical volume in GB
    read -p "Enter the size of the logical volume in GB: " lv_size

    # Check available free space in the volume group
    free_space=$(sudo vgdisplay "$volume_group" | awk '/Free/ {print $5}')
    if [ "$free_space" -lt "$lv_size" ]; then
        echo "Error: Insufficient free space in volume group \"$volume_group\"."
        exit 1
    fi

    # Create a logical volume of the specified size
    sudo lvcreate -L "${lv_size}G" -n srv_volume "/dev/${volume_group}" || { echo "Error: Failed to create logical volume."; exit 1; }

    # Format the logical volume with the ext4 filesystem
    sudo mkfs.ext4 "/dev/${volume_group}/srv_volume" || { echo "Error: Failed to format logical volume."; exit 1; }

    # Mount the logical volume on /srv (or /var/www based on user choice)
    sudo mkdir -p /srv
    sudo mount "/dev/${volume_group}/srv_volume" /srv || { echo "Error: Failed to mount logical volume."; exit 1; }
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
