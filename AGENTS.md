# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, Codex, etc.) when working with code in this repository.

## Repository Overview

The UNStack is a modular, open-architecture, Unified Namespace focused Industrial-IoT data stack. It uses Docker containers exclusively and follows a numbered directory structure for different components.

## Architecture
The stack follows an edge-to-cloud data flow pattern.
The numbering schema follows the automation hierarchy, so when sorting the folders in regular order,
the order resembles the hierarchy.

### Global Components (Cloud/Central)
- **05_grafana**: Dashboard and visualization layer
- **09_adminer**: Database management interface  
- **10_connect_global-to-postgres**: Redpanda Connect ETL from Kafka to TimescaleDB
- **11_timescaledb**: PostgreSQL with TimescaleDB extension for time-series data
- **19_nodered_global**: Node-RED for global logic processing
- **20_connect_factory1-to-global**: Redpanda Connect, renames topic `factory1` → `global` inside the global broker (edge→global hop is `55_`)
- **30_redpanda_broker-global**: Kafka broker for global message streaming

### Edge Components
- **55_connect_kafka-to-cloud**: Redpanda Connect, forwards edge topic `factory1` to the global broker
- **60_redpanda_broker-edge**: Kafka broker for edge message streaming
- **65_connect_mqtt-to-kafka**: Redpanda Connect ETL from MQTT to Kafka
- **80_nodered_edge**: Node-RED for edge logic processing
- **90_mosquitto_broker-edge**: MQTT broker for edge devices
- **91_telegraf_opcua-to-mqtt**: OPC-UA to MQTT gateway using Telegraf
- **99_opcplc_opcua-simulator**: OPC-UA simulator for testing

## Common Development Commands

### Initial Setup
```bash
# Copy template and edit: passwords, STACK_DATA_DIR
cp .env.example .env
# Data dirs + docker networks are created by ./container_all_restart.sh (idempotent scripts/initialize.sh)
```

### Managing All Services
Root `container_*.sh` are symlinks into `scripts/`. They act on every `NN_*` dir that has a `.autostart` file.
```bash
./container_all_restart.sh          # initialize.sh, down (99→05), up: DB + brokers first, then the rest (05→99)
./container_all_down.sh             # Stop all services
```
Full script inventory, destructive flags and cron setup: `scripts/README.md`.

### Managing Individual Services
Each numbered directory contains standard scripts:
```bash
cd XX_service_name/
./container_restart.sh    # Stop and start service
./container_down.sh       # Stop service
./container_logs.sh       # View logs
./container_pull.sh       # Pull latest image
./container_exec_it.sh    # Shell in the first service of this dir (bash, else sh); pass a service key to pick another
```

### Database Operations
```bash
cd 11_timescaledb/
./container_exec_sql.sh                           # Execute SQL interactively
./container_exec_sql_dump.sh                      # Dump database (pg_dump -Fc, timestamped file)
./container_exec_sql_get-postgres-version.sh      # Check PostgreSQL version
./container_exec_sql_get-timescale-version.sh     # Check TimescaleDB version
./container_exec_sql_upgrade-timescale.sh         # Upgrade TimescaleDB
```

## Key Configuration Files

### Credentials
- `.env` (repo root, gitignored): host settings (`STACK_DATA_DIR`), DB passwords, Grafana admin credentials
- Service directories that need it contain a `.env -> ../.env` symlink (compose interpolation)

### Service Control
- `.autostart` files in service directories control which services start with global commands
- `docker-compose.yml` in each service directory defines the container configuration; service keys equal `container_name` (`timescaledb`, `redpanda-global`, `connect-mqtt-to-kafka`, ...)
- Cross-service endpoints are compose `environment:` vars consumed by the config file (`KAFKA_BROKER*`, `MQTT_BROKER_LOCAL`, `REDIS_URL`, `DB_HOST`/`DB_PORT`, `OPCUA_ENDPOINT`)

### Data Processing
- `pipeline.yml` files in Connect services define ETL transformations
- `65_connect_mqtt-to-kafka/pipeline.yml`: MQTT `#` → edge Kafka topic `factory1` (key = MQTT topic)
- `55_connect_kafka-to-cloud/pipeline.yml`: edge `factory1` → global `factory1` (WAN hop: zstd, batches 500/1s; edge broker is the buffer, no local disk buffer)
- `20_connect_factory1-to-global/pipeline.yml`: global `factory1` → global `global`
- `10_connect_global-to-postgres/pipeline.yml`: global `global` → TimescaleDB (topic-id cache in Redis, numeric/text split, bad data → Kafka topic `dlq`)
- Kafka in/out use the `redpanda` plugin (franz-go). Its output forwards **no headers by default**: every output sets `metadata.include_prefixes: [uns_]` (`10_` DLQ: `[dlq_, uns_]`). `10_` needs the `uns_timestamp_ms` header.
- Topics are created by the one-shot `topic-init` service in `30_`/`60_` (1 partition, retention: `factory1`/`global` 7d, `dlq` 30d; re-applied on every start)

## Network Architecture
The stack uses Docker networks to isolate communication:
- `postgres`: TimescaleDB and related services
- `kafka-global`: Global Kafka messaging
- `kafka-edge`: Edge Kafka messaging  
- `mqtt`: MQTT broker and clients

Edge and global share no docker network: `55_` is on `kafka-edge` only and reaches the global broker via
its published port (`host.docker.internal:29092`, the "WAN"). Inside global, `10_`/`20_` use `redpanda-global:9092`.

Not on the shared networks: `10_` has a private `global-to-postgres` bridge for its Redis sidecar;
`91_telegraf` and `99_opcplc` have no `networks:` and reach the host via `host.docker.internal`.

## Data Storage
All persistent data lives under `${STACK_DATA_DIR}` (default `/srv/uns-data`, set in `.env`).
`scripts/initialize.sh` creates the dirs with the container's uid (rootless Podman: via `podman unshare`):
- `grafana` (1000), `nodered-global` / `nodered-edge` (1000)
- `redpanda-broker-global` / `redpanda-broker-edge` (101)
- `timescaledb/postgres` (70, PGDATA in subdir `pgdata`), `mosquitto/data` (1883)

## Service Access Points
Host ports as published in the `docker-compose.yml` files (see `INSECURITY.md` for what is unauthenticated).

| Service | Dir | Bind | Host port | Notes |
|---------|-----|------|-----------|-------|
| Grafana | `05_` | 0.0.0.0 | 3000 | admin credentials in `.env` |
| Adminer | `09_` | 0.0.0.0 | 3010 | |
| TimescaleDB | `11_` | – | – | not published; `timescaledb:5432` on `postgres` net only |
| Node-RED global | `19_` | 0.0.0.0 | 1881 | |
| Redpanda global Kafka | `30_` | 0.0.0.0 | 29092 | advertises `host.docker.internal:29092` |
| Redpanda global SR / proxy / admin | `30_` | 127.0.0.1 | 28081 / 28082 / 29644 | |
| Redpanda Console global | `30_` | 0.0.0.0 | 8090 | |
| Redpanda edge Kafka | `60_` | 127.0.0.1 | 19092 | |
| Redpanda edge SR / proxy / admin | `60_` | 127.0.0.1 | 18081 / 18082 / 19644 | |
| Redpanda Console edge | `60_` | 0.0.0.0 | 8080 | |
| Node-RED edge | `80_` | 0.0.0.0 | 1880 | |
| Mosquitto | `90_` | 0.0.0.0 | 1883 | |
| OPC PLC simulator | `99_` | 0.0.0.0 | 4840 | |

The Connect health endpoint (`10_`, `20_`, `55_`, `65_`, port 4195) is not published; only the compose healthcheck uses it.

## Intent & Design Goals
### Architecture
- In a production environment, 01-50 would run on a single linux device ("global") and 51-99 on a separate linux device ("edge").
  For lab purposes, both are combined here in a single repo. But "global" and "edge" should communicate in a simple and clearly defined way. (e.g. no docker networks)

### Edge
- one topic per tag
- bare payloads are the standard. structured payloads are possible.
- The data is collected via mqtt. That is the main data interface for additional data sources.
  OPCUA-Simulator and telegraf only exist in this stack for demo purposes.

## Development Guidelines
1. **Service Isolation**: Each service runs in its own numbered directory with standard scripts
2. **Docker Networks**: Use appropriate networks for service communication isolation
3. **Credentials**: Never commit actual passwords; `.env` is gitignored, keep `.env.example` current
4. **Autostart Control**: Use `.autostart` files to control which services start automatically
5. **Data Persistence**: All data should persist under `${STACK_DATA_DIR}` volumes
6. **Scripts**: `source scripts/_lib.sh` (strict mode, `ROOT_DIR`, `SCRIPT_DIR`, `load_env`); shared scripts live in `scripts/` and are symlinked, never copied
7. **Compose style**: 2-space indent, map-style `environment:`, unquoted `host:container` ports, `restart: unless-stopped`, `:ro` on config mounts, no `expose:`; all files share the `x-defaults`/`x-healthcheck` anchors (log rotation, memory limit, healthcheck)
