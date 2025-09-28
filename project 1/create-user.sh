#!/bin/bash

# Input file with raw names
input="random_names.csv"
# Output file with cleaned usernames
user_file="usernames.txt"

# Generate valid Linux usernames:
#  - convert to lowercase
#  - replace spaces with underscores
#  - remove carriage returns (\r)
#  - remove duplicates
cat "$input" | tr '[:upper:]' '[:lower:]' | tr -d '\r' | tr ' ' '_' | sort -u > "$user_file"

# Loop through cleaned usernames and create users
while read -r username; do
    # Generate a random password for each user
    password=$(openssl rand -hex 8)

    if id "$username" &>/dev/null; then
        echo "User '$username' already exists."
    else
        echo "User '$username' does not exist. Creating..."
        sudo adduser "$username" --home /home/$username --disabled-password --gecos "" &>/dev/null
        echo "$username:$password" | sudo chpasswd -c SHA256
        echo "✅ Created user: $username with password: $password"
    fi
    sleep 2
done < "$user_file"
