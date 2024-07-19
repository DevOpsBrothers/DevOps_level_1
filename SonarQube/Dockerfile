FROM alpine:latest

# Install necessary packages
RUN apk update && \
    apk add --no-cache shadow openjdk17-jdk bash procps

# this are dynamic arguments to take it from user at build time 
ARG PROJECT_NAME 

# setting environment variable for sonar conf file and sonar application
ENV PROJECT_NAME=${PROJECT_NAME} \
    SONAR_JAVA_HOME=/usr/bin/java \
    SONAR_CONF_PROPFILE=/home/sonarapp/conf/sonar.properties \
    SONAR_CONF_PATH=/home/sonarapp/conf

# Create a non-root user and necessary directories
RUN addgroup -S sonarapp && \
    adduser -S -G sonarapp -h /home/sonarapp sonarapp 

# copying downloaded binary zip into target path 
ADD ./bin/sonarqube-10.6.zip /home/sonarapp/

RUN cd /home/sonarapp/ && \
    ls -1 | xargs -I {} sh -c 'echo "{}" && unzip {}' &&\
    rm -rf *.zip && \
    ls -1 | xargs -I {} sh -c 'echo "{}" && mv {} sonarqube' &&\
    cp -r sonarqube/* . && \
    rm -rf sonarqube
# Removing the property lines to replace with the values 
# provided at build time the user
COPY sonar_add.properties /home/sonarapp/conf/
RUN sed -i "/sonar.path.data/d" ${SONAR_CONF_PROPFILE} && \
    sed -i "/sonar.path.temp/d" ${SONAR_CONF_PROPFILE} && \
    sed -i "/sonar.jdbc.username/d" ${SONAR_CONF_PROPFILE} && \
    sed -i "/sonar.jdbc.password/d" ${SONAR_CONF_PROPFILE} && \
    sed -i "/sonar.jdbc.url/d" ${SONAR_CONF_PROPFILE} && \
    cat ${SONAR_CONF_PATH}/sonar_add.properties >> ${SONAR_CONF_PROPFILE} && \
    chown -R sonarapp:sonarapp /home/sonarapp/ && \
    chmod -R 755 /home/sonarapp/bin

# WORKDIR /home/sonarapp/
SHELL [ "/bin/bash" ]
USER sonarapp
CMD [ "/home/sonarapp/bin/linux-x86-64/sonar.sh", "console"]