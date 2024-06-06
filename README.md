# Oracle Database Docker Image Setup Script

This Bash script automates the setup process for installing Git, Docker, and configuring Docker daemon DNS settings for setting up an Oracle Database environment.

## Prerequisites

- **Git**: Make sure Git is installed on your system. If not, the script will prompt you to install it.
- **Docker**: Ensure Docker is installed and running on your system. If Docker is not found, the script will prompt you to install it.
- **Oracle Docker Images**: The script will clone the Oracle Docker Images repository if it doesn't exist.

## Usage

1. Download the script `oracle_db_docker_setup.sh` to your local machine.
2. Make the script executable by running:

```bash
chmod +x oracle_db_docker_setup.sh
```

3. Run the script:
```bash
./oracle_db_docker_setup.sh
```

4. Follow the prompts to:

- Install Git and Docker if they are not already installed.
- Enter the Oracle DB version you want to install (default is 19.3.0).
- Download the Oracle DB ZIP file from the official Oracle website.
- Move the downloaded ZIP file to the appropriate directory.
- Build the Docker image for Oracle DB.

## Script Features
- **Git Installation**: If Git is not installed, the script will offer to install it using Homebrew (macOS) or apt-get (Linux).

- **Docker Installation**: If Docker is not installed, the script will exit with an error message, prompting you to install Docker manually.

- **Oracle DB Version Prompt**: The script prompts you to enter the version of Oracle DB you want to install, with a default value of 19.3.0.

- **Download Instructions**: The script provides detailed instructions for downloading the Oracle DB ZIP file from the Oracle website.

- **File Movement**: The script assists in moving the downloaded ZIP file to the target directory.

- **Docker Image Check**: The script checks if the oracle19c Docker image already exists. If it does, you will be prompted to remove the existing image or choose a different tag.

- **Repository Cloning**: If the Oracle Docker Images repository does not exist locally, the script will clone it.

- **Build Docker Image**: The script will build the Docker image for the specified Oracle DB version.


## Additional Notes

- **Manual Download**:
  - Due to licensing restrictions, the script cannot download the Oracle DB ZIP file automatically.
  - You will need to manually download it from the [Oracle Database Software Downloads](https://www.oracle.com/database/technologies/oracle-database-software-downloads.html) page with a valid account.

- **Target Directory**:
  - Ensure that the downloaded Oracle DB ZIP file is placed in the specified directory as prompted by the script.
  - The target directory is typically `$PWD/docker-images/OracleDatabase/SingleInstance/dockerfiles/<version>`.

- **Removing Cloned Repository**:
  - After building the Docker image, the script will prompt you to remove the cloned `docker-images` directory to clean up.
  - If you choose to keep the directory, you can use it for future builds or modifications.

- **Tested Version**:
  - This script has been tested only with Oracle DB 19c. It should work with other versions, but this has not been verified.