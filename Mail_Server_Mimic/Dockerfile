# Use a Debian-based image
FROM alpine:latest

# Install msmtp and mailutils (for sending emails)
RUN apk update && \
    apk add --no-cache mailx msmtp postfix
# RUN apt-get update && apt-get install -y msmtp mailutils ca-certificates

# Copy the msmtprc configuration file
COPY msmtprc /etc/msmtprc

# Set environment variables for msmtp
ENV MSMTP_RC /etc/msmtprc

# Set entrypoint to msmtp
ENTRYPOINT ["sleep","infinte"]
