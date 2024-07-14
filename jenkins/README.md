# Docker Compose Setup for Jenkins

![My Skills](https://go-skill-icons.vercel.app/api/icons?i=docker,postgres,git,jenkins,bash,&perline=6)

# Contents:

> ### `start_jenkins.sh`
>
> - this scripts is the entrypoint for jenkins to be started

> ### Dockerfile
>
> - All the configuration written in this file
> - Tried to write it from scratch using alpine other than just directly pull the image of jenkins from Docker-Hub
>   - The reason to do it was:
>     1. run `jenkins` through own `jenkins` user
>     1. `Docker` to be installed inside the same container and also postgres client
>     1. Custom `workspace path` for jenkins and custom port

> ### docker-compose.yml (local)
>
> This one is to build the initial image of jenkins to push that image in **`DockerHub`**
>
> We can refer the **below docker-compose.yml** to initiate the container in other machine directly.

## docker-compose.yml

This compose file references local images created using the following commands:

> [!NOTE]
>
> ```bash
> docker-compose build
>
> docker-compose up -d
> ```

> ```yml
> name: jenkins_server
> services:
>   jenkins:
>     image: pritamchk98/jenkins_9080:v1.0
>     container_name: c_jenkins
>     restart: on-failure
>     ports:
>       - "9080:9080"
>       - "2222:22"
>     volumes:
>       - <YOUR_LOCAL_PATH>:/home/jenkins/WORKSPACE
>       #- /var/run/docker.sock:/var/run/docker.sock
>       #- /c/Users/PRITAM/Desktop/DOCKER/HANDS_ON/JENKINS:/home/jenkins/WORKSPACE
> volumes:
>   jenkins_data:
> ```

> [!NOTE]
> The line **`/var/run/docker.sock:/var/run/docker.sock`** in a Docker Compose or Docker command binds the Docker Unix socket from the host (**`/var/run/docker.sock`**) to the same location within the container (**`/var/run/docker.sock`**). Here's what it does:
>
> **Socket Binding:** Docker uses a Unix socket (docker.sock) to communicate between the Docker daemon running on the host and Docker client commands. This socket file (docker.sock) is located at `/var/run/docker.sock` on the host machine by default.
>
> **Container Access**: By binding **`/var/run/docker.sock`** to **`/var/run/docker.sock`** inside a container, you allow processes within that container to communicate directly with the Docker daemon on the host. This is essential for tasks like starting new containers, inspecting existing ones, and managing Docker resources.
>
> **Security Considerations**: This approach can simplify container management but requires careful consideration of security implications. Access to the Docker socket effectively grants administrative privileges to the Docker daemon, so it's crucial to limit this access to trusted containers and users.
>
> **In summary,** this line enables a Docker client inside a container to interact with the Docker daemon running on the host, facilitating seamless Docker management from within containers.

> #### Image Link : [pritamchk98/jenkins_9080:v1.0](https://hub.docker.com/r/pritamchk98/jenkins_9080)
