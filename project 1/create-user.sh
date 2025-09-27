#!/bin/bash
# user file
user_file="./user.csv"

password=$(openssl rand -hex 8)

# Check if the user exists and create if it doesn't
while user_name= read -r username; do
    if id "$username" &>/dev/null; then
        sleep 2
        echo "User '$username' already exists."
    else
        echo "User '$username' does not exist. Creating..."
        sudo adduser "$username" &>/dev/null --home /home/$username --disabled-password --gecos "" && echo "$username:$password" | sudo chpasswd -c SHA256
        echo "$username:$password"
        sleep 2
        echo "User '$username' created."
    fi
done < "$user_file"
