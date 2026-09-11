#!/bin/bash
# shellcheck source=scripts/_lib.sh
source "$(dirname "$0")/../scripts/_lib.sh"
load_env global

# upgrade timescaledb
# https://github.com/timescale/timescaledb/releases
docker exec -it timescaledb psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "ALTER EXTENSION timescaledb UPDATE;"
# append TO '2.x.y' for a specific version

# install / upgrade timescaledb_toolkit
#docker exec -it timescaledb psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE EXTENSION IF NOT EXISTS timescaledb_toolkit;"
#docker exec -it timescaledb psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "ALTER EXTENSION timescaledb_toolkit UPDATE;"
