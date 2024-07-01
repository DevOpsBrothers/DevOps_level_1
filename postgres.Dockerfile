FROM alpine:latest

LABEL maintainer="your-email@example.com"
LABEL version="1.0"
LABEL description="This is a base image built from scratch using Alpine Linux with PostgreSQL."

RUN apk update && apk upgrade && \
    apk add --no-cache bash postgresql postgresql-contrib

RUN addgroup -S postgres && adduser -S postgres -G postgres

SHELL ["/bin/bash", "-c"]

RUN mkdir -p /var/lib/postgresql/data && \
    chown -R postgres:postgres /var/lib/postgresql && \
    su postgres -c "initdb -D /var/lib/postgresql/data"

USER postgres

ENV PGDATA=/var/lib/postgresql/data

EXPOSE 5432

CMD ["postgres", "-D", "/var/lib/postgresql/data"]
