#!/bin/bash
cd "$(dirname "$0")"

if [ ! -f ../.env ]; then
   echo "../.env not found! (cp .env.example .env)"
   exit 1
fi

source ../.env

docker exec -it timescaledb psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "\dx"