#!/bin/bash
# Idempotent: creates data dirs (+ ownership) and docker networks. Safe to run on every restart.
set -e
ROOT_DIR="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)"

[ -f "$ROOT_DIR/.env" ] || { echo "missing $ROOT_DIR/.env  (cp .env.example .env && edit)"; exit 1; }
source "$ROOT_DIR/.env"
: "${STACK_DATA_DIR:?set STACK_DATA_DIR in .env}"

# rootless podman: container uids live in the sub-uid range -> chown inside the user namespace
if [ "$(podman info --format '{{.Host.Security.Rootless}}' 2>/dev/null)" = true ]; then
  NS="podman unshare"; SUDO=""
else
  NS="";               SUDO="sudo"
fi

ensure_dir() {  # <path> <uid:gid as seen inside the container>
  [ -d "$1" ] || $SUDO mkdir -p "$1"
  [ "$($NS stat -c %u:%g "$1")" = "$2" ] || $NS $SUDO chown "$2" "$1"
}
ensure_net() { docker network inspect "$1" >/dev/null 2>&1 || docker network create "$1"; }

# data root (rootless podman needs it user-owned so mkdir works without sudo)
[ -d "$STACK_DATA_DIR" ] || { sudo mkdir -p "$STACK_DATA_DIR"; [ -z "$NS" ] || sudo chown "$USER:" "$STACK_DATA_DIR"; }

## ***** global *****
ensure_dir "$STACK_DATA_DIR/grafana"                1000:1000
ensure_dir "$STACK_DATA_DIR/timescaledb/postgres"   70:70
ensure_dir "$STACK_DATA_DIR/nodered-global"         1000:1000
ensure_dir "$STACK_DATA_DIR/redpanda-broker-global" 101:101
ensure_net postgres
ensure_net kafka-global

## ***** edge *****
ensure_dir "$STACK_DATA_DIR/nodered-edge"           1000:1000
ensure_dir "$STACK_DATA_DIR/redpanda-broker-edge"   101:101
ensure_dir "$STACK_DATA_DIR/mosquitto/data"         1883:1883
ensure_net kafka-edge
ensure_net mqtt
