FROM busybox:stable

ENV JAVA_HOME=/home/packages/jdk-22.0.1/bin \
    PATH=$JAVA_HOME:$PATH \
    JENKINS_HOME=/home/jenkins/WORKSPACE \
    JENKINS_PORT=9080
    
# Create Jenkins user
RUN adduser -D -h /home/jenkins jenkins \
    && mkdir -p /home/jenkins/.ssh \
    && mkdir -p /home/jenkins/WORKSPACE \
    && chown -R jenkins:jenkins /home/jenkins \
    && chmod 700 /home/jenkins/.ssh

# Add all packages from local to container
# dropbear -> SSH server and client pkg : https://github.com/mkj/dropbear?tab=readme-ov-file
# JDK : 22.1.0 from Oracle website
# Jenkins file from Jenkins web site
ADD ./bin/dropbear-2024.85.tar.bz2 /home/packages \
    ./bin/jdk-22_linux-x64_bin.tar.gz /home/packages/ \
    ./bin/jenkins.war /home/jenkins/

WORKDIR /home/packages

# Install OpenJDK and SSH
RUN chmod -R 775 jdk-22.0.11 && \
    chmod -R 775 dropbear-2024.85 && \
    cd dropbear-2024.85 && ./configure && make install  

# Copy SSH key (Assuming you have an id_rsa.pub file in the same directory as Dockerfile)
COPY ./keys/id_rsa.pub /home/jenkins/.ssh/authorized_keys \
    startJenkins.sh /home/jenkins/

RUN chown -R jenkins:jenkins /home/jenkins/ \
    && chmod 600 /home/jenkins/.ssh/authorized_keys \
    && chmod -R 744 /home/jenkins

# Expose Jenkins and SSH ports
EXPOSE 9080 22

USER jenkins
# Start jenkins along with ssh in bg
CMD ["sh", "startJenkins"]
