#!/bin/bash

# Function to display error messages
show_error() {
    echo "Error: $1"
}

# Function to ask user for input or fetch from .env
ask_input() {
    local input
    read -p "$1 (Default: $2): " input
    input=${input:-$2}
    echo "$input"
}

# Function to ask user if they want to change default values
ask_change_defaults() {
    read -p "Do you want to change any default values? (y/n) [Default: n]: " change
    change=${change:-"n"}
    if [[ $change == "y" ]]; then
        return 0
    else
        return 1
    fi
}

# Check if .env file exists, source it if it does
ENV_FILE=".env"
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    show_error "Docker is not installed on your system."
    return 1
fi

# Ask user if they want to change default values
if ask_change_defaults; then
    # Ask user for Oracle password
    ORACLE_PWD=$(ask_input "Enter Oracle Database password" "$ORACLE_PWD")

    # Ask user for Oracle SID
    ORACLE_SID=$(ask_input "Enter Oracle SID" "$ORACLE_SID")

    # Ask user for Oracle PDB
    ORACLE_PDB=$(ask_input "Enter Oracle PDB" "$ORACLE_PDB")

    # Ask user for Oracle edition
    ORACLE_EDITION=$(ask_input "Enter Oracle edition" "$ORACLE_EDITION")

    # Ask user for character set
    ORACLE_CHARACTERSET=$(ask_input "Enter Oracle character set" "$ORACLE_CHARACTERSET")

    # Ask user if archive log mode should be enabled
    ENABLE_ARCHIVELOG=$(ask_input "Enable archive log mode (true/false)" "$ENABLE_ARCHIVELOG")

    # Ask user for volume path
    VOLUME_PATH=$(ask_input "Enter volume path" "$VOLUME_PATH")
fi

# Create directory if it doesn't exist
mkdir -p "$VOLUME_PATH"

# Run the Docker container 
docker run -d --name oracledb \
           -p 1521:1521 \
           -p 5500:5500 \
           -p 2484:2484 \
           --ulimit nofile=1024:65536 --ulimit nproc=2047:16384 --ulimit stack=10485760:33554432 --ulimit memlock=3221225472 \
           -e ORACLE_PWD="$ORACLE_PWD" \
           -e ORACLE_SID="$ORACLE_SID" \
           -e ORACLE_PDB="$ORACLE_PDB" \
           -e ORACLE_EDITION="$ORACLE_EDITION" \
           -e ORACLE_CHARACTERSET="$ORACLE_CHARACTERSET" \
           -e ENABLE_ARCHIVELOG="$ENABLE_ARCHIVELOG" \
           -v "$VOLUME_PATH":/opt/oracle/oradata \
           oracle19c:latest

# For all the options
# docker run -d --name oracledb \
#            -p 1521:1521 \
#            -p 5500:5500 \
#            -p 2484:2484 \
#            --ulimit nofile=1024:65536 --ulimit nproc=2047:16384 --ulimit stack=10485760:33554432 --ulimit memlock=3221225472 \
#            -e ORACLE_PWD="$ORACLE_PWD" \
#            -e ORACLE_SID="$ORACLE_SID" \
#            -e ORACLE_PDB="$ORACLE_PDB" \
#            # -e INIT_SGA_SIZE="$INIT_SGA_SIZE" \
#            # -e INIT_PGA_SIZE="$INIT_PGA_SIZE" \
#            # -e INIT_CPU_COUNT="$INIT_CPU_COUNT" \
#            # -e INIT_PROCESSES="$INIT_PROCESSES" \
#            -e ORACLE_EDITION="$ORACLE_EDITION" \
#            -e ORACLE_CHARACTERSET="$ORACLE_CHARACTERSET" \
#            -e ENABLE_ARCHIVELOG="$ENABLE_ARCHIVELOG" \
#            # -e ENABLE_FORCE_LOGGING="$ENABLE_FORCE_LOGGING" \
#            # -e ENABLE_TCPS="$ENABLE_TCPS" \
#            -v "$VOLUME_PATH":/opt/oracle/oradata \
#            oracle19c:latest


# Check if the Docker container was started successfully
if [ $? -eq 0 ]; then
    echo "Oracle Database container 'oracledb' started successfully."
else
    show_error "Failed to start Oracle Database container 'oracledb'."
    return 1
fi

# Show logs of the container in the background
docker logs oracledb -f | {
    while IFS= read -r line; do
        echo "$line" # Output the log line

        # Check if the desired text is present in the log line
        if [[ $line == *"DATABASE IS READY TO USE!"* ]]; then
            echo "Database is ready to use. Stopping log monitoring."
            break # Break out of the loop if the text is found
        fi
    done
}

# Alert users how to use the Oracle Database
echo "You can connect to this container using:"
echo "sqlplus sys/'$ORACLE_PWD'@//localhost:1521/'$ORACLE_SID' as sysdba"
echo "sqlplus system/'$ORACLE_PWD'@//localhost:1521/'$ORACLE_SID'"
echo "sqlplus pdbadmin/'$ORACLE_PWD'@//localhost:1521/'$ORACLE_SID'"