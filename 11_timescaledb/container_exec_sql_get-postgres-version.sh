#!/bin/bash
# shellcheck source=scripts/_lib.sh
source "$(dirname "$0")/../scripts/_lib.sh"
load_env
docker exec -it timescaledb psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT version();"
