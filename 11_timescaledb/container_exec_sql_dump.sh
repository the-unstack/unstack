#!/bin/bash
cd "$(dirname "$0")"

if [ ! -f ../.env ]; then
   echo "../.env not found! (cp .env.example .env)"
   exit 1
fi

source ../.env

docker exec -i timescaledb pg_dump -d "postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost/${POSTGRES_DB}" -Fc > "${POSTGRES_DB}_$(date +%Y%m%d-%H%M%S).dump"