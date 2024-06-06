#!/bin/bash

# Function to display error messages
show_error() {
    echo "Error: $1"
}

# Function to display informational messages
show_info() {
    echo "Info: $1"
}

# Function to ask user for input or fetch from .env
ask_input() {
    local input
    read -p "$1 (Default: $2): " input
    input=${input:-$2}
    echo "$input"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    show_error "Docker is not installed on your system."
    exit 1
fi

# Ask user for the container name
container_name=$(ask_input "Enter the name for the Docker container" "oracledb")

# Stop the Docker container if it's running
if docker container ls -a --format '{{.Names}}' | grep -q "$container_name"; then
    show_info "Stopping the '$container_name' container..."
    if ! docker container stop "$container_name"; then
        show_error "Failed to stop the '$container_name' container."
        exit 1
    fi
    show_info "Container '$container_name' stopped successfully."
else
    show_info "No running container named '$container_name' found."
fi

# Remove the Docker container if it exists
if docker container ls -a --format '{{.Names}}' | grep -q "$container_name"; then
    show_info "Removing the '$container_name' container..."
    if ! docker container rm "$container_name"; then
        show_error "Failed to remove the '$container_name' container."
        exit 1
    fi
    show_info "Container '$container_name' removed successfully."
else
    show_info "No container named '$container_name' found."
fi
