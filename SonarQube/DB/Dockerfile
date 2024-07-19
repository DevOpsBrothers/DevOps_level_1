FROM pritamchk98/pgdb_img:v1.1

ENV POSTGRES_USER=postgres

# COPY init_sonarqube_db.sh /postgres/Database/docker-entrypoint-initdb.d/
COPY init_sonarqube_db.sh /postgres/Database/

RUN \
    /postgres/install/bin/pg_ctl -D /postgres/Database/ -o "-c listen_addresses=''" start && \
    cd /postgres/Database/ && sh init_sonarqube_db.sh && \
    /postgres/install/bin/pg_ctl -D /postgres/Database/ stop

