# Use the Alpine base image
FROM alpine:latest

# Install necessary packages
RUN apk update && \
    apk add --no-cache bash shadow git postgresql-client

# Create a non-root user and necessary directories
RUN addgroup -S gitea && \
    adduser -S -G gitea -h /gitea gitea && \
    mkdir -p /gitea/data/ && \
    mkdir -p /gitea/install && \
    chown -R gitea:gitea /gitea/install/


# Download gitea binary (version:1.22.0) in nstall folder
ADD https://dl.gitea.com/gitea/1.22.0/gitea-1.22.0-linux-amd64 /gitea/install/gitea

# app.ini into binary file
ADD app.ini /gitea/install/

RUN chown -R gitea:gitea /gitea/ && \
    cd /gitea && \
    mkdir -p gitea/data && \
    mkdir -p gitea/log && \
    cd install && \
    chmod -R 755 gitea && \
    chmod 777 app.ini


USER gitea
WORKDIR /gitea/install
EXPOSE 3000

# RUN ./gitea web migrate --config app.ini -p 3000

#start server
CMD ["./gitea","web","--config","./app.ini"]

# docker network create gitea-network
# docker run -d --name="gitea_db" --restart=on-failure:2 --hostname=postgres --network gitea-network -p 5432:5432 -v pgdb_data:/postgres/Database pgdb_img:v1.1
# docker build -t gitea_image:v1.0 .
# docker run -d --name="gitea_c1" --restart=on-failure:2 --network gitea-network -p 3000:3000 -v gitea_data:/gitea gitea_image:v1.0
