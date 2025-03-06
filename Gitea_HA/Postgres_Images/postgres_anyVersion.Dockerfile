# STAGE : 1
# Use the Alpine base image
FROM alpine:3.21.3 AS base

ARG PGVERSION=17.4

ENV PGVERSION=${PGVERSION}
# Install necessary packages
RUN apk update && \
    apk add --no-cache build-base openssl-dev readline-dev zlib-dev shadow icu-dev linux-headers

# Create a non-root user and necessary directories
RUN addgroup -S postgres && \
    adduser -S -G postgres -h /postgres postgres && \
    mkdir -p /postgres/Database && \
    mkdir -p /postgres/install 


#download the bin
ADD https://ftp.postgresql.org/pub/source/v${PGVERSION}/postgresql-${PGVERSION}.tar.bz2 /postgres/install


#install postgres from src code 
RUN cd /postgres/install && \
    tar -xf postgresql-${PGVERSION}.tar.bz2 && \
    rm -rf *.bz2 && \
    mv postgresql-${PGVERSION} postgresql && \
    cd postgresql && sh ./configure --prefix=/postgres/install && \
    make && \
    make install && \
    strip /postgres/install/bin/* /postgres/install/lib/*.a && \
    rm -rf postgresql


#COPY templated conf files 
COPY postgresql.conf.template /postgres/postgresql.conf.template
COPY pg_hba.conf.template /postgres/pg_hba.conf.template

#copy entrypoint 
COPY entrypoint.sh /postgres/entrypoint.sh

RUN chmod +x /postgres/entrypoint.sh

# STAGE : 2
# Use the Alpine base image
FROM alpine:3.21.3

ENV DBPORT=5432 \
    PATH=/postgres/install/bin:${PATH} \
    MAX_CONN=100 \
    IP_RANGE="0.0.0.0/0"\
    ENC_ALGO=md5

# DEFAULT ENC_ALGO md5 but can changed to scram-sha-256

# Install necessary packages
RUN apk update && \
    apk add --no-cache bison openssl-dev readline-dev zlib-dev shadow icu-dev envsubst util-linux-dev flex

# Create a non-root user and necessary directories
RUN addgroup -S postgres && \
    adduser -S -G postgres -h /postgres postgres && \
    mkdir -p /postgres/Database && \
    mkdir -p /postgres/install 


COPY --from=base /postgres /postgres

#ownership change
RUN chown -R postgres:postgres /postgres && \
    chmod -R 755 /postgres 


# Initialize PostgreSQL database in the custom directory
USER postgres

# RUN cd /postgres/install/bin && 
# Initialize PostgreSQL (only if not initialized)
RUN if [ ! -d "/postgres/Database/base" ]; then pg_ctl initdb -D /postgres/Database; fi && \
    cp /postgres/postgresql.conf.template /postgres/Database/postgresql.conf.template &&\
    cp /postgres/pg_hba.conf.template /postgres/Database/pg_hba.conf.template &&\
    rm /postgres/postgresql.conf.template /postgres/pg_hba.conf.template

# Set the default password for the "postgres" user
RUN echo "ALTER USER postgres WITH PASSWORD 'postgres';" > /tmp/init.sql && \
    pg_ctl start -D /postgres/Database && \
    psql -U postgres -p ${DBPORT} -f /tmp/init.sql && \
    pg_ctl stop -D /postgres/Database && \
    rm /tmp/init.sql

#expose port 
EXPOSE ${DBPORT}

#VOLUME
VOLUME [ "/postgres/Database" ]

#Entry point
ENTRYPOINT [ "./postgres/entrypoint.sh" ]