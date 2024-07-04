# Use the Alpine base image
FROM alpine:latest

# Install necessary packages
RUN apk update && \
    apk add --no-cache bash postgresql postgresql-contrib shadow

# Create a non-root user with adduser
# RUN addgroup -S pgdbuser && \
#     adduser -DG pgdbuser -h /pgdbuser pgdbuser && \
#     mkdir -p /pgdbuser/Database/ && \
#     chown -R pgdbuser:pgdbuser /pgdbuser && \
#     chmod -R 700 /pgdbuser/Database

RUN addgroup -S pgdbuser && \
    adduser -DG pgdbuser -h /pgdbuser pgdbuser && \
    mkdir -p /pgdbuser/Database && \
    mkdir -p /run/postgresql && \
    chown -R pgdbuser:pgdbuser /pgdbuser /run/postgresql && \
    chmod -R 700 /pgdbuser/Database /run/postgresql

# Initialize PostgreSQL database in the custom directory
RUN su pgdbuser -c "initdb -D /pgdbuser/Database/"

# Set the default shell to bash
SHELL ["/bin/bash", "-c"]

# Switch to the non-root user
USER pgdbuser

# Set environment variables for PostgreSQL
ENV PGDATA=/pgdbuser/Database/

# Expose the PostgreSQL port
EXPOSE 5432

# Set the default command to start PostgreSQL
CMD ["postgres", "-D", "/pgdbuser/Database/"]
