# Oracle DB Docker setup

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

4. Follow the prompts to install Git, Docker, and configure Docker daemon DNS settings.

5. After executing the script, you should have Docker installed, the Oracle Docker Images repository cloned, and Docker daemon DNS settings configured.


## Additional Notes

- **Oracle DB Version**: You will be prompted to enter the version of Oracle DB you want to install. The default version is 19.3.0. This script has been tested with Oracle 19c, but it should work with other Oracle DB versions as well.

- **Download Instructions**: After entering the Oracle DB version, the script will provide instructions on how to manually download the OracleDB ZIP file from the Official Oracle site and place it in the appropriate directory.

- **Moving Downloaded File**: You can choose whether to move the downloaded ZIP file to the target directory. If you choose not to move the file, make sure to manually place it in the specified directory.

- **Docker Image**: The script checks if the Docker image `oracle19c` already exists. If the image exists, you will be prompted to remove the existing image or choose a different tag.