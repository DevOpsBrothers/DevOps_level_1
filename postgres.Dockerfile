# Use the Alpine base image
FROM alpine:latest

# Install necessary packages
RUN apk update && \
    apk add --no-cache bash build-base openssl-dev readline-dev zlib-dev shadow icu-dev linux-headers

# Create a non-root user and necessary directories
RUN addgroup -S postgres && \
    adduser -S -G postgres -h /postgres postgres && \
    mkdir -p /postgres/Database && \
    mkdir -p /postgres/install 

#\
# mkdir -p /run/postgresql && \


# Copy PostgreSQL source code to the container
ADD postgresql-16.3.tar.gz /postgres/install
RUN chown -R postgres:postgres /postgres && \
    chmod -R 700 /postgres

# WORKDIR /PGDB_installed
# Extract the source code
RUN cd /postgres/install && \
    # tar -xzf postgresql-16.3.tar.gz && \
    cd postgresql-16.3 && \
    ./configure --prefix=/postgres/install && \
    make && \
    make install


RUN chown -R postgres:postgres /postgres && \
    chmod -R 755 /postgres


# Initialize PostgreSQL database in the custom directory
USER postgres
RUN /postgres/install/bin/initdb -D /postgres/Database/

# Set environment variables for PostgreSQL
ENV PATH=/postgres/install/bin:$PATH \
    PGDATA=/postgres/Database

# Expose the PostgreSQL port
EXPOSE 5432

# Set the default command to start PostgreSQL
CMD ["postgres", "-D", "/postgres/Database/"]
