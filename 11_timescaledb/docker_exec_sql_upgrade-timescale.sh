#!/bin/bash

if [ ! -f ../!credentials/credentials.env ]; then
   echo "Credentials file not found!"
   exit 1
fi

source ../!credentials/credentials.env

# upgrade timescaledb
# https://github.com/timescale/timescaledb/releases
to_version="2.21.0"
docker exec -it timescaledb psql -d "postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost/unifiednamespace" -c "ALTER EXTENSION timescaledb UPDATE;"
# TO '$to_version';"

# install / upgrade timescaledb_toolkit
#docker exec -it timescaledb psql -d "postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost/unifiednamespace" -c "CREATE EXTENSION IF NOT EXISTS timescaledb_toolkit;"
#docker exec -it timescaledb psql -d "postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost/unifiednamespace" -c "ALTER EXTENSION timescaledb_toolkit UPDATE;"
