> My DockerHub user ID : pritamchk98

# DevOps Level 1
This repository is dedicated to learning and sharing knowledge.

<!--https://github.com/lelouchfr/skill-icons-->
![My Skills](https://go-skill-icons.vercel.app/api/icons?i=linux,docker,kubernetes,bash,postgres,git,github,gitea,jenkins,vscode,nginx,sonarqube,elasticsearch,&perline=6)

# Targets
| Target No | Subject | Status |
|-----------|--------------------------------------------|-----------------------------------------|
| Target 1  | Create a base image for PostgreSQL from Alpine Linux and add volume binding. | <span style="color:green">Completed on: 5/7/24 by Pritam</span> |
| Target 2  | Create a base image for self-hosted Gitea from Alpine Linux and connect it to the previously created PostgreSQL image for database usage. | <span style="color:green">Completed</span> |
| Target 3  | Create a base image for self-hosted DockerHub registry (Harbor) from Alpine Linux and host own images there. | In Progress |
| Target 4  | Create a Docker Compose file to host the above three applications together. | <span style="color:red">Not Started</span> |
| Target 5  | Create a Docker image for Jenkins and integrate it into the previous Docker Compose setup. | <span style="color:green">Completed</span> |
| Target 6  | Create multiple containers with SSH setup among them to mimic a multi-VM environment. | <span style="color:red">Not Started</span> |
| Target 7  | Deploy an application in Docker using the previous setups and establish a complete CI/CD pipeline for that application. | <span style="color:red">Not Started</span> |
| Future Target | ELK stack | <span style="color:yellow">Planned</span> |
| Future Target | SonarQube | <span style="color:yellow">Planned</span> |
| Future Target | Nginx (load balancer) | <span style="color:yellow">Planned</span> |

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
