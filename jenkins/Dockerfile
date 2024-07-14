# FROM busybox:latest
FROM alpine:latest

RUN apk update &&\
    apk add --no-cache bash shadow git postgresql-client build-base openssl-dev readline-dev zlib-dev icu-dev linux-headers openssh openssh-keygen openjdk17 \
    && echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# SHELL [ "/bin/bash" ]
ENV JENKINS_HOME=/home/jenkins/WORKSPACE \
    JENKINS_PORT=9080 \
    JAVA_OPTS="-Djava.awt.headless=true"


# Create Jenkins user
# RUN addgroup -S jenkins \
#     && adduser -s /bin/bash -D -h /home/jenkins -G jenkins jenkins \
#     && mkdir -p /home/jenkins/.ssh \
#     && mkdir -p /home/jenkins/WORKSPACE \
#     && chown -R jenkins:jenkins /home/jenkins \
#     && chmod 700 /home/jenkins/.ssh
# Create Jenkins user
# Create Jenkins user
# RUN addgroup -S jenkins && \
# adduser -S -G jenkins -h /home/jenkins -s /bin/bash jenkins && \
# cd /home/jenkins && pwd && ls -1 &&\
RUN mkdir -p /home/jenkins/.ssh && \
    mkdir -p /home/jenkins/WORKSPACE && \
    # chown -R jenkins:jenkins /home/jenkins/WORKSPACE && \
    # chown -R jenkins:jenkins /home/jenkins && \
    chmod 700 /home/jenkins/.ssh && \
    java -version



# Add all packages from local to container
# dropbear -> SSH server and client pkg : https://github.com/mkj/dropbear?tab=readme-ov-file
# JDK : 22.1.0 from Oracle website
# Jenkins file from Jenkins web site
ADD bin/dropbear-2024.85.tar.bz2 /home/packages/dropbear-2024.85/ 
ADD bin/jdk-22_linux-x64_bin.tar.gz /home/packages/jdk-22.0.11/ 
ADD bin/jenkins1.war /home/jenkins/

WORKDIR /home/packages

# Install OpenJDK and SSH
RUN chmod -R 775 dropbear-2024.85 && \
    # RUN chmod -R 775 jdk-22.0.11 && \
    pwd && ls -1 && \
    cd dropbear-2024.85/dropbear-2024.85 && \
    pwd && ls -1 && sh configure && make install  

WORKDIR /home
# Copy SSH key (Assuming you have an id_rsa.pub file in the same directory as Dockerfile)
COPY keys/id_rsa.pub jenkins/.ssh/authorized_keys
COPY start_jenkins1.sh jenkins/

RUN cd jenkins/.ssh/ && \
    ssh-keygen -t rsa -b 4096 -f id_rsa


# RUN chown -R jenkins:jenkins /home/jenkins/ && \
RUN chmod 600 /home/jenkins/.ssh/authorized_keys \
    && chmod -R 744 /home/jenkins

# Expose Jenkins and SSH ports
EXPOSE 9080 22

# USER jenkins
WORKDIR /home/jenkins
# Start jenkins along with ssh in bg
CMD  ["sh","start_jenkins1.sh"]
# RUN chown -R jenkins:jenkins .
