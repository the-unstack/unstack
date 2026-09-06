#!/bin/bash
cd "$(dirname "$0")"

if [ ! -f ../.env ]; then
   echo "../.env not found! (cp .env.example .env)"
   exit 1
fi

source ../.env

# upgrade timescaledb
# https://github.com/timescale/timescaledb/releases
to_version="2.21.0"
docker exec -it timescaledb psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "ALTER EXTENSION timescaledb UPDATE;"
# TO '$to_version';"

# install / upgrade timescaledb_toolkit
#docker exec -it timescaledb psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE EXTENSION IF NOT EXISTS timescaledb_toolkit;"
#docker exec -it timescaledb psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "ALTER EXTENSION timescaledb_toolkit UPDATE;"
