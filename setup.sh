#!/bin/bash

# Prompt the user for the necessary variables
echo "Please enter the following information:"
read -p "SMB/CIFS share URL (eg ip.add.re.ss/share): " smb_url
read -p "Local mount point (eg. /path/to/file): " mount_point
read -p "Username: " username
read -s -p "Password: " password
echo

# Create mount point directory if it doesn't exist
if [ ! -d "$mount_point" ]; then
  mkdir -p "$mount_point"
fi

# Escape special characters in password
escaped_password=$(echo "$password" | sed 's/\([]\[\{\}\*\.\|\^\(\)\?\\\/\$\+]\)/\\\1/g')


# Create credentials file in /etc directory
cat << EOF > /etc/.smbCredentials
username=$username
password=$escaped_password
EOF

# Set permissions for credentials file
chmod 600 /etc/.smbCredentials

# Add entry to fstab file for persistent mount
echo "//$smb_url $mount_point cifs credentials=/etc/.smbCredentials,uid=$(id -u) 0 0" >> /etc/fstab

# Mount the share
mount -a

# Print success message
echo "SMB/CIFS share mounted successfully at $mount_point"
