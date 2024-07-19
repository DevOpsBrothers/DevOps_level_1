![sonar_icon](./img/image.png)
# with Docker and Postgres
![My Skills](https://go-skill-icons.vercel.app/api/icons?i=docker,postgres,&perline=2)

---

### DB setup :
> init_sonarqube_db.sh - in this file we are creating new db for sonar

### sonar config setup
>  sonar_add.properties is the file where we have to give details for DB connection
```properties
sonar.path.data=/home/sonarapp/data
sonar.path.temp=/home/sonarapp/temp
sonar.jdbc.username=postgres
sonar.jdbc.password=postgres
sonar.jdbc.url=jdbc:postgresql://pgdb_server/sonarqube
```
- here pgdb_server - this name has to be the service name for docker-compose of db service.

----
To Be implemented:
1. integrate Gitea with Sonar
2. Sonar with Jenkins 
3. Sonar project setup for multiple IMPLEMENTATION in single Sonar Instance.