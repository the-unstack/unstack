#!/bin/bash
# shellcheck source=!scripts/_lib.sh
source "$(dirname "$0")/../!scripts/_lib.sh"
cd "$SCRIPT_DIR"
docker run --rm telegraf telegraf config > telegraf.example.conf
