#!/bin/bash

if [ ! -f ../!credentials/credentials.env ]; then
   echo "Credentials file not found!"
   exit 1
fi

source ../!credentials/credentials.env

docker exec -it timescaledb pg_dump -d "postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost/unifiednamespace" -Fc > unifiednamespace.dump