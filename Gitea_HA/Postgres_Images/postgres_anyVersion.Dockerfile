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

COPY postgresql.conf.template /postgres/postgresql.conf.template
COPY entrypoint.sh /postgres/entrypoint.sh

RUN chmod +x /postgres/entrypoint.sh

# STAGE : 2
# Use the Alpine base image
FROM alpine:3.21.3

ENV DBPORT=5432 \
    PATH=/postgres/install/bin:${PATH} \
    MAX_CONN=100


# Install necessary packages
RUN apk update && \
    apk add --no-cache openssl-dev readline-dev zlib-dev shadow icu-dev envsubst

# Create a non-root user and necessary directories
RUN addgroup -S postgres && \
    adduser -S -G postgres -h /postgres postgres && \
    mkdir -p /postgres/Database && \
    mkdir -p /postgres/install 


COPY --from=base /postgres /postgres

#ownership change
RUN chown -R postgres:postgres /postgres && \
    chmod -R 700 /postgres 


# Initialize PostgreSQL database in the custom directory
USER postgres

# RUN cd /postgres/install/bin && 
# Initialize PostgreSQL (only if not initialized)
RUN if [ ! -d "/postgres/Database/base" ]; then pg_ctl initdb -D /postgres/Database; fi && \
    cp /postgres/postgresql.conf.template /postgres/Database/postgresql.conf.template



#expose port 
EXPOSE ${DBPORT}

#VOLUME
VOLUME [ "/postgres/Database" ]

#CREATE DEFAULT Database


#Entry point
ENTRYPOINT [ "./postgres/entrypoint.sh" ]