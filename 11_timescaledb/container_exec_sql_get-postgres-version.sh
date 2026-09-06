#!/bin/bash
cd "$(dirname "$0")"

if [ ! -f ../.env ]; then
   echo "../.env not found! (cp .env.example .env)"
   exit 1
fi

source ../.env

docker exec -it timescaledb psql -d "postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost/${POSTGRES_DB}" -c "SELECT version();"