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
ADD postgresql-16.3.tar.gz /postgres/install
RUN chown -R postgres:postgres /postgres && \
    chmod -R 700 /postgres

# Build PostgreSQL from source
USER postgres
RUN cd /postgres/install && \
    # tar -xzf postgresql-16.3.tar.gz && \
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

# Initialize PostgreSQL database in the custom directory
USER postgres
RUN /postgres/install/bin/initdb -D /postgres/Database/

# Update PostgreSQL configuration to listen on all interfaces
RUN echo "listen_addresses='*'" >> /postgres/Database/postgresql.conf && \
    echo "host all all 0.0.0.0/0 md5" >> /postgres/Database/pg_hba.conf

# Set the password for the postgres user
RUN /postgres/install/bin/pg_ctl -D /postgres/Database/ -o "-c listen_addresses=''" start && \
    /postgres/install/bin/psql -c "ALTER USER postgres WITH PASSWORD 'postgres';" && \
    /postgres/install/bin/pg_ctl -D /postgres/Database/ stop

# Set environment variables for PostgreSQL
ENV PATH=/postgres/install/bin:$PATH \
    PGDATA=/postgres/Database

# Expose the PostgreSQL port
EXPOSE 5432

# Set the default command to start PostgreSQL
CMD ["postgres", "-D", "/postgres/Database/"]

# Get-NetTCPConnection -State Listen
# docker build -t pgdb_img:v1.0 .
# docker run -d --name pgdbc_v1 -p 5432:5432 pgdb_img:v1.0
## WITH VOLUME :
# docker run -d --name pgdbc_v1 -p 5432:5432 -v db_data:/postgres/Database pgdb_img:v1.1
