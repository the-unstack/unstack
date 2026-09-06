#!/bin/bash
# shellcheck source=scripts/_lib.sh
source "$(dirname "$0")/../scripts/_lib.sh"
load_env
cd "$SCRIPT_DIR"   # dump lands in 11_timescaledb/
docker exec -i timescaledb pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" -Fc > "${POSTGRES_DB}_$(date +%Y%m%d-%H%M%S).dump"
