#!/bin/bash

# Function to display error messages
show_error() {
    echo "Error: $1"
}

# Function to check if Git is installed
check_git_installed() {
    if ! command -v git &> /dev/null; then
        show_error "Git is not installed on your system."
        read -p "Do you want to install Git? (y/n): " choice
        if [[ $choice =~ ^[Yy]$ ]]; then
            # Check OS for package manager
            if [[ "$(uname)" == "Darwin" ]]; then
                brew install git || { show_error "Failed to install Git using Homebrew. Please install Git manually."; return 1; }
            elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
                sudo apt-get install git || { show_error "Failed to install Git using apt-get. Please install Git manually."; return 1; }
            else
                show_error "Unsupported OS. Please install Git manually."
                return 1
            fi
        else
            show_error "Git is required to proceed. Please install it and rerun the script."
            return 1
        fi
    fi
}

# Function to check if Docker is installed
check_docker_installed() {
    if ! command -v docker &> /dev/null; then
        show_error "Docker is not installed on your system."
        show_error "Please install Docker and ensure it is running before rerunning the script."
        return 1
    fi
}

# Function to check if Docker image already exists
check_docker_image_exists() {
    if docker images | grep -q "oracle19c"; then
        show_error "Docker image oracle19c already exists."
        show_error "Please remove the existing image or choose a different tag."
        return 1
    fi
}

# Function to clone the repository if it doesn't exist
clone_repository() {
    if [ ! -d "docker-images" ]; then
        git clone https://github.com/oracle/docker-images.git || {
            show_error "Failed to clone the repository. Exiting..."
            return 1
        }
    else
        echo "Repository already exists. Skipping cloning process..."
    fi
}

# Function to prompt for Oracle DB version and provide download instructions
prompt_oracle_db_version() {
    read -p "Enter the version of Oracle DB you want to install (Default: 19.3.0): " db_version
    db_version=${db_version:-19.3.0} # Default value if user enters nothing

    echo "Please download OracleDB $db_version manually from the Official Oracle site with a valid account."
    echo "After logging in, go to the following link and download the ZIP file:"
    echo " - https://www.oracle.com/database/technologies/oracle-database-software-downloads.html#db_free"
    echo " - File -> Oracle Database 19c for Linux x86-64 (LINUX.X64_193000_db_home.zip)"
    echo ""
    echo "Place the downloaded file in the following directory:"
    echo "$PWD/docker-images/OracleDatabase/SingleInstance/dockerfiles/$db_version"
    echo ""
    read -p "Once downloaded, press Enter to continue..."
}

# Function to move the downloaded file from the specified path to the target directory
move_downloaded_file() {
    default_download_path="$HOME/Downloads/LINUX.X64_193000_db_home.zip"
    read -p "Do you want to move the downloaded file to the target directory? (y/n) [Default: n]: " move_choice
    move_choice=${move_choice:-"n"}
    if [[ $move_choice =~ ^[Yy]$ ]]; then
        read -p "Enter the path to the downloaded ZIP file (Default: $default_download_path): " download_path
        download_path=${download_path:-$default_download_path}
        target_path="$PWD/docker-images/OracleDatabase/SingleInstance/dockerfiles/$db_version"

        if [ -f "$download_path" ]; then
            mkdir -p "$target_path" # Create the target directory if it doesn't exist
            mv "$download_path" "$target_path" || { show_error "Failed to move the file. Please move it manually."; return 1; }
            echo "File moved successfully."

            # Check if the file exists in the target directory
            if [ -f "$target_path/$(basename "$download_path")" ]; then
                echo "File exists in the target directory."
                return 0
            else
                show_error "File does not exist in the target directory. Please check and rerun the script."
                return 1
            fi
        else
            show_error "The file was not found at the specified path: $download_path. Please ensure the path is correct and rerun the script."
            return 1
        fi
    else
        echo "File not moved."
        return 0
    fi
}


# Function to remove the docker-images directory and all subdirectories
remove_docker_git_directory() {
    read -p "Do you want to remove the docker-images directory and all its subdirectories? (y/n) [Default: n]: " remove_choice
    remove_choice=${remove_choice:-"n"}
    if [[ $remove_choice =~ ^[Yy]$ ]]; then
        echo "Removing docker-images directory..."
        rm -rf docker-images
        echo "docker-images directory removed."
    else
        echo "docker-images directory not removed."
    fi
}


# Main script execution

# Check if Git is installed
check_git_installed || { return 1; }

# Check if Docker is installed
check_docker_installed || { return 1; }

# Check if Docker image already exists
check_docker_image_exists || { return 1; }

# Clone the repository if necessary
clone_repository || { return 1; }

# Change to the required directory
cd docker-images/OracleDatabase/SingleInstance/dockerfiles || {
    show_error "Unable to change directory. Exiting..."
    return 1
}
cd -

# Make the build script executable
chmod +x docker-images/OracleDatabase/SingleInstance/dockerfiles/buildContainerImage.sh

# Prompt the user for Oracle DB version and provide download instructions
prompt_oracle_db_version || { return 1; }

# Move the downloaded file if the user agrees
move_downloaded_file || { return 1; }

# Execute the build script with the specified Oracle DB version
docker-images/OracleDatabase/SingleInstance/dockerfiles/buildContainerImage.sh -v "$db_version" -o --network=host -e -t oracle19c || { return 1; } 

# Remove docker-images directory
remove_docker_git_directory