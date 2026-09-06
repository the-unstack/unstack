# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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
- **20_connect_factory1-to-global**: Connects Kafka edge topic to Kafka global topic
- **30_redpanda_broker-global**: Kafka broker for global message streaming

### Edge Components
- **55_connect_kafka-to-cloud**: Connects edge Kafka to cloud Kafka
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
# Data dirs + docker networks are created by ./container_all_restart.sh (idempotent !scripts/initialize.sh)
```

### Managing All Services
```bash
./container_all_restart.sh          # Start all services with .autostart files
./container_all_down.sh             # Stop all services
./container_all_pull.sh             # Pull latest images for all services
./container_ps.sh                   # View running containers
./container_stats.sh                # Monitor memory usage
```

### Managing Individual Services
Each numbered directory contains standard scripts:
```bash
cd XX_service_name/
./container_restart.sh    # Stop and start service
./container_down.sh       # Stop service
./container_logs.sh       # View logs
./container_pull.sh       # Pull latest image
```

### Database Operations
```bash
cd 11_timescaledb/
./container_exec_sql.sh                           # Execute SQL interactively
./container_exec_sql_dump.sh                      # Dump database
./container_exec_sql_get-postgres-version.sh      # Check PostgreSQL version
./container_exec_sql_get-timescale-version.sh     # Check TimescaleDB version
./container_exec_sql_upgrade-timescale.sh         # Upgrade TimescaleDB
```

## Key Configuration Files

### Credentials
- `.env` (repo root, gitignored): host settings (`STACK_DATA_DIR`, `CONTAINER_SOCKET`), DB passwords, Grafana admin credentials
- Service directories that need it contain a `.env -> ../.env` symlink (compose interpolation / env_file)

### Service Control
- `.autostart` files in service directories control which services start with global commands
- `docker-compose.yml` in each service directory defines the container configuration

### Data Processing
- `pipeline.yml` files in Connect services define ETL transformations
- `10_connect_global-to-postgres/pipeline.yml`: Kafka to TimescaleDB with data type handling
- `65_connect_mqtt-to-kafka/pipeline.yml`: MQTT to Kafka bridging

## Network Architecture

The stack uses Docker networks to isolate communication:
- `postgres`: TimescaleDB and related services
- `kafka-global`: Global Kafka messaging
- `kafka-edge`: Edge Kafka messaging  
- `mqtt`: MQTT broker and clients

## Data Storage

All persistent data lives under `${STACK_DATA_DIR}` (default `/srv/uns-data`, set in `.env`).
`!scripts/initialize.sh` creates the dirs with the container's uid (rootless Podman: via `podman unshare`):
- `grafana` (1000), `nodered-global` / `nodered-edge` (1000)
- `redpanda-broker-global` / `redpanda-broker-edge` (101)
- `timescaledb/postgres` (70), `mosquitto/data` (1883)

## Service Access Points

- **Grafana**: http://localhost:3000 (admin credentials in .env)
- **Redpanda Console Global**: http://localhost:8090
- **Redpanda Console Edge**: http://localhost:8091
- **TimescaleDB**: localhost:5432 (PostgreSQL protocol)
- **Global Kafka**: localhost:29092
- **Edge Kafka**: localhost:29093
- **Global Node-RED**: http://localhost:1880
- **Edge Node-RED**: http://localhost:1881

## Development Guidelines

1. **Service Isolation**: Each service runs in its own numbered directory with standard scripts
2. **Docker Networks**: Use appropriate networks for service communication isolation
3. **Credentials**: Never commit actual passwords; `.env` is gitignored, keep `.env.example` current
4. **Autostart Control**: Use `.autostart` files to control which services start automatically
5. **Data Persistence**: All data should persist under `${STACK_DATA_DIR}` volumes