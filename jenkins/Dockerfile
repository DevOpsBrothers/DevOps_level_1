FROM alpine:latest

# Install necessary packages
RUN apk update && \
    apk add --no-cache bash shadow git postgresql-client build-base openssl-dev readline-dev zlib-dev icu-dev linux-headers openssh openssh-keygen openjdk17-jdk fontconfig ttf-dejavu ttf-droid ttf-freefont ttf-liberation && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Set environment variables
ENV JENKINS_HOME=/home/jenkins/WORKSPACE \
    JENKINS_PORT=9080 \
    JAVA_OPTS="-Djava.awt.headless=true"

# Create Jenkins user
RUN addgroup -S jenkins && \
    adduser -S -G jenkins -h /home/jenkins -s /bin/bash jenkins && \
    mkdir -p /home/jenkins/.ssh /home/jenkins/WORKSPACE && \
    chown -R jenkins:jenkins /home/jenkins && \
    chmod 700 /home/jenkins/.ssh

RUN mkdir -p /home/packages/dropbear-2024.85/ && \
    mkdir -p /home/packages/jdk-22.0.11/

# Add all packages from local to container
COPY bin/dropbear-2024.85.tar.bz2 /home/packages/dropbear-2024.85/
COPY bin/jdk-22_linux-x64_bin.tar.gz /home/packages/jdk-22.0.11/
ADD bin/jenkins1.war /home/jenkins/

# Extract Dropbear and JDK
WORKDIR /home/packages/dropbear-2024.85
RUN tar -xjf dropbear-2024.85.tar.bz2

# Debug: List contents to verify structure
RUN ls -la /home/packages/dropbear-2024.85

# Install Dropbear SSH
WORKDIR /home/packages/dropbear-2024.85/dropbear-2024.85
RUN chmod -R 775 . && \
    ./configure && make install

# Set up JDK
WORKDIR /home/packages/jdk-22.0.11
RUN tar -xzf jdk-22_linux-x64_bin.tar.gz -C /usr/local && \
    ln -s /usr/local/jdk-22.0.11 /usr/local/java

# Copy SSH key (Assuming you have an id_rsa.pub file in the same directory as Dockerfile)
COPY keys/id_rsa.pub /home/jenkins/.ssh/authorized_keys
COPY start_jenkins.sh /home/jenkins/

RUN chmod 600 /home/jenkins/.ssh/authorized_keys && \
    chown -R jenkins:jenkins /home/jenkins

# Expose Jenkins and SSH ports
EXPOSE 9080 22

# Switch to Jenkins user
USER jenkins
WORKDIR /home/jenkins

# Start Jenkins and Dropbear SSH
CMD ["sh", "start_jenkins.sh"]
