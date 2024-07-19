# Stage 1: Build Stage
FROM alpine:latest AS build

# Install necessary packages
RUN apk update && \
    apk add --no-cache unzip && \
    rm -rf /var/cache/apk/*

# Dynamic arguments to take from the user at build time
ARG PROJECT_NAME

# Setting environment variables
ENV PROJECT_NAME=${PROJECT_NAME} \
    SONAR_JAVA_HOME=/usr/bin/java \
    SONAR_CONF_PROPFILE=/home/sonarapp/conf/sonar.properties \
    SONAR_CONF_PATH=/home/sonarapp/conf

# Create a non-root user and necessary directories
RUN addgroup -S sonarapp && \
    adduser -S -G sonarapp -h /home/sonarapp sonarapp

# Copying downloaded binary zip into target path and unzipping
ADD ./bin/sonarqube-10.6.zip /home/sonarapp/
RUN cd /home/sonarapp/ && \
    unzip sonarqube-10.6.zip && \
    rm -rf sonarqube-10.6.zip && \
    ls -1 | xargs -I {} sh -c 'cp -rv {}/* . && rm -rf {}'

# Removing the property lines to replace with the values provided at build time by the user
COPY sonar_add.properties /home/sonarapp/conf/

RUN sed -i "/sonar.path.data/d" ${SONAR_CONF_PROPFILE} && \
    sed -i "/sonar.path.temp/d" ${SONAR_CONF_PROPFILE} && \
    sed -i "/sonar.jdbc.username/d" ${SONAR_CONF_PROPFILE} && \
    sed -i "/sonar.jdbc.password/d" ${SONAR_CONF_PROPFILE} && \
    sed -i "/sonar.jdbc.url/d" ${SONAR_CONF_PROPFILE} && \
    cat ${SONAR_CONF_PATH}/sonar_add.properties >> ${SONAR_CONF_PROPFILE} && \
    chown -R sonarapp:sonarapp /home/sonarapp/ && \
    chmod -R 755 /home/sonarapp/bin

# Stage 2: Final Stage
FROM alpine:latest

# Install only the necessary runtime packages
RUN apk update && \
    apk add --no-cache openjdk17-jre procps shadow && \
    rm -rf /var/cache/apk/*

# Create a non-root user and necessary directories
RUN addgroup -S sonarapp && \
    adduser -S -G sonarapp -h /home/sonarapp sonarapp

# Copy the prepared application from the build stage
COPY --from=build /home/sonarapp /home/sonarapp

# Set the shell to bash and the user to sonarapp
# SHELL [ "/bin/bash" ]
USER sonarapp

# Command to run the SonarQube server
CMD [ "/home/sonarapp/bin/linux-x86-64/sonar.sh", "console"]
