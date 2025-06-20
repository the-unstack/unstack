#!/bin/bash

if [ ! -f ../!credentials/credentials.env ]; then
   echo "Credentials file not found!"
   exit 1
fi

source ../!credentials/credentials.env

# https://github.com/timescale/timescaledb/releases
to_version="2.20.2"

# install / upgrade timescaledb_toolkit
#docker exec -it timescaledb psql -d "postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost/postgres" -c "CREATE EXTENSION IF NOT EXISTS timescaledb_toolkit;"
#docker exec -it timescaledb psql -d "postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost/postgres" -c "ALTER EXTENSION timescaledb_toolkit UPDATE;"

# upgrade timescaledb
docker exec -it timescaledb psql -d "postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost/postgres" -c "ALTER EXTENSION timescaledb UPDATE TO '$to_version';"