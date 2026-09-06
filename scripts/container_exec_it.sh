#!/bin/bash
# usage: container_exec_it.sh [SERVICE]   shell in SERVICE (default: first service key of this dir)
# shellcheck source=scripts/_lib.sh
source "$(dirname "$(readlink -f "$0")")/_lib.sh"
cd "$SCRIPT_DIR"
svc="${1:-$(awk '/^services:/{f=1;next} f&&/^  [a-zA-Z]/{sub(":","",$1);print $1;exit}' docker-compose.yml)}"
docker compose exec "$svc" sh -c 'exec bash 2>/dev/null || exec sh'
