#!/bin/sh

# Replace environment variables in postgresql.conf.template
envsubst < /postgres/Database/postgresql.conf.template > /postgres/Database/postgresql.conf
envsubst < /postgres/Database/pg_hba.conf.template > /postgres/Database/pg_hba.conf

# Start PostgreSQL
exec postgres -D /postgres/Database
