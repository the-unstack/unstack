#!/bin/bash
set -e

# read-only grafana user; psql vars keep values out of the SQL text
psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
     --set=u="$GRAFANA_DB_USER" --set=p="$GRAFANA_DB_PASS" --set=d="$POSTGRES_DB" <<-'EOSQL'
    SELECT format('CREATE USER %I WITH PASSWORD %L', :'u', :'p')
    WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = :'u') \gexec
    GRANT CONNECT ON DATABASE :"d" TO :"u";
    GRANT USAGE ON SCHEMA public TO :"u";
    GRANT SELECT ON ALL TABLES IN SCHEMA public TO :"u";
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO :"u";
EOSQL
