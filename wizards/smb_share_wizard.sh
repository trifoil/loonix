#!/bin/bash

# install samba if not installed already
dnf -y install samba

echo "Starting the samba configuration wizard..."

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

chmod -R 755 