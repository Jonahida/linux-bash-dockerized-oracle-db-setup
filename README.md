# Oracle Database Docker Setup Script

This Bash script automates the setup process for creating, configuring, and managing Oracle Database Docker containers.

## Prerequisites
**Git**: Ensure Git is installed on your system. If not, the script will prompt you to install it.
**Docker**: Make sure Docker is installed and running on your system. If Docker is not found, the script will prompt you to install it.
**Oracle Docker Images**: The script will clone the Oracle Docker Images repository if it doesn't exist.


## Usage
1. **Download the script** Obtain the script main.sh and save it to your local machine.
2. **Make it Executable**: Use the following command to make the script executable:

```bash
chmod +x main.sh
```

3. **Run the Script**: Execute the script by typing the following command in your terminal:

```bash
./main.sh
```

4. **Follow the Prompts**: Choose the operation you want to perform based on the options provided:

- Create Oracle Docker image
- Create Oracle Docker volumes
- Destroy Oracle Docker container
- Set up Oracle DB Docker
- Run Oracle container
- Run entire cycle (Create image, volumes, setup, run container)

## Script Features

- **Git Installation**: If Git is not installed, the script will offer to install it using Homebrew (macOS) or apt-get (Linux).

- **Docker Installation**: If Docker is not installed, the script will exit with an error message, prompting you to install Docker manually.

- **Oracle DB Docker Image Creation**: Automates the process of creating Oracle Docker images for specified versions.

- **Oracle DB Docker Volume Creation**: Facilitates the creation of Docker volumes required for Oracle Database data storage.

- **Oracle DB Docker Container Management**: Allows you to easily start, stop, and remove Oracle Docker containers.

- **Oracle DB Docker Setup**: Automates the setup of Oracle Database Docker environment, including image creation, volume creation, and container setup.

## Additional Notes
- **Oracle DB Version**: The script has been primarily tested with Oracle DB 19c, but it should work with other versions as well.

- **Contribution to Oracle Docker Image Creation**: The script builds upon the functionality provided by `create_oracle_docker_image.sh`. This script automates the Docker image creation process, including downloading the Oracle DB ZIP file, moving it to the appropriate directory, and building the Docker image.

- **Contribution to Oracle Docker Volume Creation**: The script builds upon the functionality provided by `create_oracle_docker_volumes.sh`. This script assists in creating Docker volumes required for Oracle Database data storage.

- **Contribution to Oracle Docker Container Management**: The script builds upon the functionality provided by `destroy_oracle_docker_container.sh`. This script helps in managing Oracle Docker containers, including starting, stopping, and removing them.
