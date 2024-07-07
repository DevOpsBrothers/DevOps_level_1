Certainly! Here's an improved and organized version of your content in a more structured format, including a table for skills:



> My DockerHub user ID : pritamchk98

# DevOps Level 1
This repository is dedicated to learning and sharing knowledge.

![My Skills](https://go-skill-icons.vercel.app/api/icons?i=linux,docker,kubernetes,bash,postgres,git,github,gitea,jenkins,vscode,&perline=6)

# Targets
| Target | Description |
|--------|-------------|
| **Target 1** | Create a base image for PostgreSQL from Alpine Linux and add volume binding. <br> **Completed on:** 5/7/24 by Pritam |
| **Target 2** | Create a base image for self-hosted Gitea from Alpine Linux and connect it to the previously created PostgreSQL image for database usage. |
| **Target 3** | Create a base image for self-hosted DockerHub registry (Harbor) from Alpine Linux and host own images there. <br> [OpenSource Docker Registry host software](https://github.com/goharbor/harbor) |
| **Target 4** | Create a Docker Compose file to host the above three applications together. |
| **Target 5** | Create a Docker image for Jenkins and integrate it into the previous Docker Compose setup. |
| **Target 6** | Create multiple containers with SSH setup among them to mimic a multi-VM environment. |
| **Target 7** | Deploy an application in Docker using the previous setups and establish a complete CI/CD pipeline for that application. |

-----
## Last Update :
>```docker-cli
>docker login
>docker push pritamchk98/docker-images/gitea_image:v1.0  
>docker tag gitea_image:v1.0 pritamchk98/gitea_image:v1.0
>docker push pritamchk98/gitea_image:v1.0
>docker tag pgdb_img:v1.1 pritamchk98/pgdb_img:v1.1      
>docker push pritamchk98/pgdb_img:v1.1
>```

### Dockerhub : `gitea` & `postgress` images:
1. [**gitea**](https://hub.docker.com/repository/docker/pritamchk98/gitea_image/general)
2. [**postgres**](https://hub.docker.com/repository/docker/pritamchk98/pgdb_img/general)

----
<!-- ![Harbor Image](https://github.com/DevOpsBrothers/DevOps_level_1/assets/49076359/760b3999-5642-49b2-9f7c-02d20c4ae941) -->

### Notes:
- Skills are now displayed in an organized manner using an image grid.
- Targets are listed in a table format with clear descriptions for each.
- The Harbor image link is provided directly in markdown format.

This layout improves readability and organization, making it easier to understand and follow your DevOps learning journey.


[Docker Compose](https://docs.docker.com/compose/compose-file/build/)
