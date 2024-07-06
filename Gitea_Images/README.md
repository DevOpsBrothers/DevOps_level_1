# Gitea Docker Image 

<!-- > ![My Skills](https://go-skill-icons.vercel.app/api/icons?i=gitea,docker,postgres,git,linux,bash&perline=3) -->

<p align="center">
  <a href="https://go-skill-icons.vercel.app/">
    <img src="https://go-skill-icons.vercel.app/api/icons?i=gitea,docker,postgres,git,linux,bash" />
  </a>
</p>

This Dockerfile sets up a Docker image for running Gitea, a self-hosted Git service. It uses Alpine Linux as the base image for a lightweight and efficient deployment.

## Dockerfile Explanation

### Base Image and Package Installation

```Dockerfile
# Use the Alpine base image
FROM alpine:latest

# Install necessary packages
RUN apk update && \
    apk add --no-cache bash shadow git postgresql-client
```

- **Base Image**: This Dockerfile starts with `alpine:latest`, the latest stable version of Alpine Linux, known for its small size and security features.
  
- **Package Installation**: 
  - `bash`: Provides a more feature-rich shell environment.
  - `shadow`: Necessary for user management utilities.
  - `git`: Required for version control functionalities.
  - `postgresql-client`: Includes PostgreSQL client tools for database connectivity.

### User and Directory Setup

```Dockerfile
# Create a non-root user and necessary directories
RUN addgroup -S gitea && \
    adduser -S -G gitea -h /gitea gitea && \
    mkdir -p /gitea/data/ && \
    mkdir -p /gitea/install && \
    chown -R gitea:gitea /gitea/install/
```

- **User and Group Creation**: 
  - Creates a non-root user `gitea` and assigns it to the `gitea` group.
  - Sets the home directory (`-h /gitea`) for the user.
  
- **Directories**:
  - `/gitea/data/`: Directory for storing Gitea application data.
  - `/gitea/install`: Directory for installing Gitea binaries and configuration files.
  
- **Permissions**: 
  - Ensures that `/gitea/install` and its contents are owned by the `gitea` user.

### Downloading Gitea Binary and Configuration

```Dockerfile
# Download gitea binary (version:1.22.0) in install folder
ADD https://dl.gitea.com/gitea/1.22.0/gitea-1.22.0-linux-amd64 /gitea/install/gitea

# app.ini into install directory
ADD app.ini /gitea/install/
```

- **Gitea Binary**:
  - Downloads Gitea version 1.22.0 binary (`gitea-1.22.0-linux-amd64`) from the official Gitea download link and places it in `/gitea/install/gitea`.

- **app.ini Configuration**:
  - Copies the `app.ini` configuration file into `/gitea/install/`, which contains settings for Gitea including database configuration.

### Permissions and Setup Finalization

```Dockerfile
RUN chown -R gitea:gitea /gitea/ && \
    cd /gitea && \
    mkdir -p gitea/data && \
    mkdir -p gitea/log && \
    cd install && \
    chmod -R 755 gitea && \
    chmod 777 app.ini
```

- **Permissions and Directories**:
  - Ensures all directories (`/gitea/data`, `/gitea/log`) and files under `/gitea/` are owned by `gitea` user.
  - Sets permissions for the `gitea` binary (`gitea`) to be executable (`755`) and for `app.ini` to be readable and writable by all (`777`).

### User and Work Directory for Execution

```Dockerfile
USER gitea
WORKDIR /gitea/install
```

- **User Switch**:
  - Switches the user context to `gitea` for running subsequent commands and the application.

- **Working Directory**:
  - Sets the working directory within the container to `/gitea/install`, where the Gitea binary and configuration files reside.

### Exposing Ports and Running Gitea

```Dockerfile
EXPOSE 3000

# Start Gitea server
CMD ["./gitea", "web", "--config", "./app.ini"]
```

- **Port Exposure**:
  - Exposes port `3000` on the Docker container for accessing the Gitea web interface.

- **Command Execution**:
  - Specifies the command (`CMD`) to start the Gitea server (`./gitea web --config ./app.ini`) when the Docker container is launched.

---

## Setting Up Gitea with Docker

To deploy Gitea using Docker, follow these steps:

1. **Network Creation**:
   - Create a Docker network named `gitea-network` to facilitate communication between containers:

     ```bash
     docker network create gitea-network
     ```

2. **Run PostgreSQL Database Container**:
   - Start a PostgreSQL database container (`gitea_db`) connected to `gitea-network`, exposing port `5432` and using a volume (`pgdb_data`) for persistent storage:

     ```bash
     docker run -d --name="gitea_db" --restart=on-failure:2 --hostname=postgres --network gitea-network -p 5432:5432 -v pgdb_data:/postgres/Database pgdb_img:v1.1
     ```

3. **Build Gitea Docker Image**:
   - Build the Gitea Docker image (`gitea_image:v1.0`) from the Dockerfile:

     ```bash
     docker build -t gitea_image:v1.0 .
     ```

4. **Run Gitea Container**:
   - Launch the Gitea container (`gitea_c1`) connected to `gitea-network`, exposing port `3000`, and using a volume (`gitea_data`) for Gitea data:

     ```bash
     docker run -d --name="gitea_c1" --restart=on-failure:2 --network gitea-network -p 3000:3000 -v gitea_data:/gitea gitea_image:v1.0
     ```

5. **Access Gitea**:
   - Access the Gitea web interface by navigating to `http://localhost:3000` in your web browser.

---

### app.ini Configuration

```ini
[Unit]
Description=Gitea (Git with a cup of tea along with DevOps Brathaa)
[server]
APP_DATA_PATH = /gitea/data
LOG_ROOT_PATH = /gitea/log
[database]
DB_TYPE = postgres
HOST = postgres:5432
NAME = gitea
USER = postgres
PASSWD = postgres
SSL_MODE = disable
PATH = /gitea/data/gitea.db
```

- **Description**: A sample configuration (`app.ini`) for Gitea, specifying paths for data storage (`APP_DATA_PATH` and `LOG_ROOT_PATH`) and PostgreSQL database settings (`DB_TYPE`, `HOST`, `NAME`, `USER`, `PASSWD`, `SSL_MODE`, `PATH`).

---

This README.md provides an overview of setting up and deploying Gitea using Docker, including Dockerfile explanations, setup instructions, and a sample `app.ini` configuration. Adjust paths, versions, and configurations as per your environment and requirements.

To disconnect a container from a Docker network, you can use the `docker network disconnect` command followed by the network name and the container ID or name. Here's how you can do it:

### Disconnecting a Container from a Docker Network

1. **Find the Container ID or Name:**

   First, you need to find the ID or name of the container you want to disconnect. You can list all running containers with:

   ```bash
   docker ps
   ```

   This command will list all running containers along with their IDs and names.

2. **Disconnect the Container:**

   Once you have the container ID or name and the network name, use the `docker network disconnect` command:

   ```bash
   docker network disconnect <network_name> <container_id_or_name>
   ```

   Replace `<network_name>` with the name of the Docker network and `<container_id_or_name>` with the ID or name of the container you want to disconnect.

### Example

Let's say you have a container named `my-container` connected to a network named `my-network`:

```bash
docker network disconnect my-network my-container
```

This command will disconnect `my-container` from `my-network`.

### Notes

- Ensure that the container is not actively using the network or services provided by other containers in the network before disconnecting.
- After disconnecting, the container will no longer have network connectivity through `my-network`.

This process allows you to manage network connectivity for Docker containers, helping you control how containers communicate and interact within your Docker environment.