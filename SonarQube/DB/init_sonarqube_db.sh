#!/bin/bash
set -e

# Check if the database exists
DB_EXIST=$(psql -U "$POSTGRES_USER" -tc "SELECT 1 FROM pg_database WHERE datname = 'sonarqube'" | tr -d '[:space:]')

# Create the database if it doesn't exist
if [ "$DB_EXIST" != "1" ]; then
  echo "Database 'sonarqube' does not exist. Creating..."
  psql -U "$POSTGRES_USER" -c "CREATE DATABASE sonarqube;"
else
  echo "Database 'sonarqube' already exists."
fi
