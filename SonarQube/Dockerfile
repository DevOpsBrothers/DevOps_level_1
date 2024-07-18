FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk unzip bash && \
    rm -rf /var/lib/apt/lists/*
# FROM alpine:latest

# # Install necessary packages
# RUN apk update && \
#     apk add --no-cache shadow openjdk17-jdk bash

# for debug purpose
RUN echo "`which java`" && sleep 10

# this are dynamic arguments to take it from user at build time 
ARG PROJECT_NAME \
    SONAR_DATA_PATH \
    SONAR_TEMP_PATH \
    SONAR_DB_URL \
    SONAR_DB_USER_PASWD \
    SONAR_DB_USER

# setting environment variable for sonar conf file and sonar application
ENV PROJECT_NAME=${PROJECT_NAME} \
    SONAR_JAVA_HOME=/usr/bin/java \
    SONAR_CONF_PROPFILE=/home/sonarapp/conf/sonar.properties \
    SONAR_DATA_PATH=${SONAR_DATA_PATH}\
    SONAR_TEMP_PATH=${SONAR_TEMP_PATH} \
    SONAR_DB_URL=${SONAR_DB_URL} \
    SONAR_DB_USER_PASWD=${SONAR_DB_USER_PASWD} \
    SONAR_DB_USER=${SONAR_DB_USER}}

# Create a non-root user and necessary directories
RUN addgroup -S sonarapp && \
    adduser -S -G sonarapp -h /home/sonarapp sonarapp 
# && \
# chown -R sonarapp:sonarapp /home/sonarapp/

# copying downloaded binary zip into target path 
ADD ./bin/sonarqube-10.6.zip /home/sonarapp/


RUN cd /home/sonarapp/ && \
    ls -1 | xargs -I {} sh -c 'echo "{}" && unzip {}' &&\
    rm -rf *.zip && \
    ls -1 | xargs -I {} sh -c 'echo "{}" && mv {} sonarqube' &&\
    cp -r sonarqube/* . && \
    rm -rf sonarqube && \
    ls -l && sleep 10 
# Removing the property lines to replace with the values 
# provided at build time the user
RUN sed -i "/sonar.path.data/d" ${SONAR_CONF_PROPFILE} && \
    sed -i "/sonar.path.temp/d" ${SONAR_CONF_PROPFILE} && \
    sed -i "/sonar.jdbc.username/d" ${SONAR_CONF_PROPFILE} && \
    sed -i "/sonar.jdbc.password/d" ${SONAR_CONF_PROPFILE} && \
    sed -i "/sonar.jdbc.url/d" ${SONAR_CONF_PROPFILE} && \
    echo "${SONAR_DATA_PATH}" >> ${SONAR_CONF_PROPFILE} && \
    echo "${SONAR_TEMP_PATH}" >> ${SONAR_CONF_PROPFILE} && \
    echo "${SONAR_DB_USER}" >> ${SONAR_CONF_PROPFILE} && \
    echo "${SONAR_DB_USER_PASWD}" >> ${SONAR_CONF_PROPFILE} && \
    echo "${SONAR_DB_URL}" >> ${SONAR_CONF_PROPFILE} && \
    chown -R sonarapp:sonarapp /home/sonarapp/ && \
    chmod -R 755 /home/sonarapp/bin


# WORKDIR /home/sonarapp/
SHELL [ "/bin/bash" ]
USER sonarapp
CMD [ "/home/sonarapp/bin/linux-x86-64/sonar.sh", "start" ]