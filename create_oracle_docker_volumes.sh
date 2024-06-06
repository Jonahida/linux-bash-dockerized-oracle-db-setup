#!/bin/bash

# Source the .env file
ENV_FILE=".env"

if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
else
    echo "Error: .env file not found."
    exit 1
fi

# Function to display error messages
show_error() {
    echo "Error: $1"
}

# Set variables for the directory and permissions
USER_ID=54321
GROUP_ID=54321
PERMISSIONS=775

# Create the DockerVolumes directory if it doesn't exist
if [ ! -d "$VOLUME_PATH" ]; then
    mkdir -p "$VOLUME_PATH" || { show_error "Failed to create directory $VOLUME_PATH"; exit 1; }
    echo "Created directory $VOLUME_PATH"
fi

# Set the permissions for the oracle19c_ee_oradata directory
sudo chmod "$PERMISSIONS" "$VOLUME_PATH" || { show_error "Failed to set permissions $PERMISSIONS on $VOLUME_PATH"; exit 1; }
echo "Set permissions to $PERMISSIONS for $VOLUME_PATH"

# Change the owner of the oracle19c_ee_oradata directory
sudo chown "$USER_ID:$GROUP_ID" "$VOLUME_PATH" || { show_error "Failed to change ownership to $USER_ID:$GROUP_ID for $VOLUME_PATH"; exit 1; }
echo "Changed ownership to $USER_ID:$GROUP_ID for $VOLUME_PATH"
