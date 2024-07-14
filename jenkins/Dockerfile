# Stage 1: Build Dropbear from source
FROM alpine:latest AS builder

# Install build dependencies
RUN apk update && \
    apk add --no-cache build-base openssl-dev readline-dev zlib-dev icu-dev linux-headers

# Copy Dropbear source code and extract
COPY bin/dropbear-2024.85.tar.bz2 /home/packages/dropbear-2024.85/
WORKDIR /home/packages/dropbear-2024.85
RUN tar -xjf dropbear-2024.85.tar.bz2

# Build Dropbear
WORKDIR /home/packages/dropbear-2024.85/dropbear-2024.85
RUN ./configure && make install

# Stage 2: Final image
FROM alpine:latest

# Install runtime dependencies
RUN apk update && \
    apk add --no-cache bash shadow git postgresql-client openssl openssh openssh-keygen openjdk17-jdk fontconfig ttf-dejavu docker

# Set environment variables
ENV JENKINS_HOME=/home/jenkins/WORKSPACE \
    JENKINS_PORT=9080
    # JAVA_OPTS="-Djava.awt.headless=true"

# Create Jenkins user and set permissions
RUN addgroup -S jenkins && \
    adduser -S -G jenkins -h /home/jenkins -s /bin/bash jenkins && \
    mkdir -p /home/jenkins/.ssh /home/jenkins/WORKSPACE && \
    chown -R jenkins:jenkins /home/jenkins && \
    chmod 700 /home/jenkins/.ssh


COPY --from=builder /usr/local/bin/dbclient /usr/local/bin/
ADD bin/jenkins1.war /home/jenkins/

WORKDIR /home/packages

# Copy SSH key and start script
COPY keys/id_rsa.pub /home/jenkins/.ssh/authorized_keys
COPY start_jenkins.sh /home/jenkins/

# Set permissions for SSH key
RUN chmod 600 /home/jenkins/.ssh/authorized_keys && \
    chown -R jenkins:jenkins /home/jenkins

# Expose Jenkins and SSH ports
EXPOSE 9080 22

# Switch to Jenkins user
USER jenkins
WORKDIR /home/jenkins

# Start Jenkins and Dropbear SSH
CMD ["sh", "start_jenkins.sh"]