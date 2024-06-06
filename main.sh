#!/bin/bash

# Function to display error messages
show_error() {
    echo "Error: $1"
}

# Function to create Oracle Docker image
create_oracle_image() {
    bash create_oracle_docker_image.sh
}

# Function to create Oracle Docker volumes
create_oracle_volumes() {
    bash create_oracle_docker_volumes.sh
}

# Function to destroy Oracle Docker container
destroy_oracle_container() {
    bash destroy_oracle_docker_container.sh
}


# Function to run Oracle container
run_oracle_container() {
    bash run_oracle_container.sh
}

# Function to run entire cycle
run_entire_cycle() {
    echo "Starting the entire cycle..."
    create_oracle_image
    create_oracle_volumes
    run_oracle_container
    echo "Entire cycle completed successfully!"
}

# Main menu
main_menu() {
    echo "Select the operation to perform:"
    echo "1. Create Oracle Docker image"
    echo "2. Create Oracle Docker volumes"
    echo "3. Destroy Oracle Docker container"
    echo "4. Run Oracle container"
    echo "5. Run entire cycle (Create image, volumes, run container)"
    echo "6. Exit"
    read -p "Enter your choice: " choice
    case $choice in
        1) create_oracle_image;;
        2) create_oracle_volumes;;
        3) destroy_oracle_container;;
        4) run_oracle_container;;
        5) run_entire_cycle;;
        6) exit;;
        *) show_error "Invalid choice. Please enter a number from 1 to 7.";;
    esac
}

# Prompt the user for the operation to perform
main_menu
