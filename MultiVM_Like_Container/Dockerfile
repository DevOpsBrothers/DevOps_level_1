# Use the latest version of Alpine Linux
FROM mike2021/busybox:latest

# Install necessary packages
RUN apk update && \
    apk add --no-cache openssh-server openssh-client shadow bash && \
    adduser -D -s /bin/bash appuser && \
    echo 'appuser:password' | chpasswd && \
    mkdir /home/appuser/.ssh && \
    chown -R appuser:appuser /home/appuser/.ssh && \
    chmod 700 /home/appuser/.ssh && \
    sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    ssh-keygen -A && \
    mkdir -p /run/openrc && touch /run/openrc/softlevel && \
    sed -i 's/rc_sys=""/rc_sys="docker"/g' /etc/rc.conf && \
    echo 'rc_provide="loopback net"' >> /etc/rc.conf && \
    echo 'rc_provide="!cgroups"' >> /etc/rc.conf && \
    echo 'rc_cgroup_mode="disabled"' >> /etc/rc.conf

# Copy the start script to the container
COPY start-sshd.sh /start-sshd.sh

# Make the start script executable
RUN chmod +x /start-sshd.sh

# Expose port 22 for SSH
EXPOSE 22

# Set the default command to run the start script
CMD ["/start-sshd.sh"]
