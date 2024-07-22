# Stage 1: Build PostgreSQL from source
FROM alpine:latest AS builder

# Install necessary packages
RUN apk update && \
    apk add --no-cache bash build-base openssl-dev readline-dev zlib-dev shadow icu-dev linux-headers

# Create a non-root user and necessary directories
RUN addgroup -S postgres && \
    adduser -S -G postgres -h /postgres postgres && \
    mkdir -p /postgres/install

# Copy PostgreSQL source code to the container
ADD https://ftp.postgresql.org/pub/source/v16.3/postgresql-16.3.tar.bz2 /postgres/install
RUN chown -R postgres:postgres /postgres && \
    chmod -R 700 /postgres

# Build PostgreSQL from source
USER postgres
RUN cd /postgres/install && \
    tar -xjf postgresql-16.3.tar.bz2 && \
    cd postgresql-16.3 && \
    ./configure --prefix=/postgres/install && \
    make && \
    make install && \
    strip /postgres/install/bin/* /postgres/install/lib/*.a

# Stage 2: Create the runtime image
FROM alpine:latest

# Install necessary runtime packages
RUN apk update && \
    apk add --no-cache bash openssl readline zlib icu

# Create a non-root user and necessary directories
RUN addgroup -S postgres && \
    adduser -S -G postgres -h /postgres postgres && \
    mkdir -p /postgres/Database

# Copy the built PostgreSQL binaries from the builder stage
COPY --from=builder /postgres/install /postgres/install

# Set permissions for the directories
RUN chown -R postgres:postgres /postgres && \
    chmod -R 700 /postgres

# Set environment variables for PostgreSQL
ENV PATH=/postgres/install/bin:$PATH \
    PGDATA=/postgres/Database

# Initialize PostgreSQL database in the custom directory
USER postgres
RUN initdb -D /postgres/Database

# Update PostgreSQL configuration to listen on all interfaces
RUN echo "listen_addresses='*'" >> /postgres/Database/postgresql.conf && \
    echo "host all all 0.0.0.0/0 md5" >> /postgres/Database/pg_hba.conf

# Create the PostgreSQL role and database, and set permissions
USER postgres
RUN pg_ctl -D /postgres/Database/ -w start && \
    psql -U postgres -c "CREATE ROLE sonar WITH LOGIN PASSWORD 'sonar';" && \
    psql -U postgres -c "ALTER ROLE sonar CREATEDB;" && \
    psql -U postgres -c "ALTER ROLE sonar REPLICATION;" && \
    psql -U postgres -c "ALTER ROLE sonar BYPASSRLS;" && \
    psql -U postgres -c "CREATE DATABASE sonar;" && \
    psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE sonar TO sonar;" && \
    psql -U postgres -d sonar -c "ALTER SCHEMA public OWNER TO sonar;" && \
    psql -U postgres -d sonar -c "GRANT ALL PRIVILEGES ON SCHEMA public TO sonar;" && \
    pg_ctl -D /postgres/Database/ stop

# Expose the PostgreSQL port
EXPOSE 5432

# Set the default command to start PostgreSQL
CMD ["postgres", "-D", "/postgres/Database/"]