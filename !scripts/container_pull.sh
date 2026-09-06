#!/bin/bash
# shellcheck source=!scripts/_lib.sh
source "$(dirname "$(readlink -f "$0")")/_lib.sh"
cd "$SCRIPT_DIR"
docker compose pull
