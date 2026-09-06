#!/bin/bash
# initialize, down (descending), then up in two passes: infra first, rest after
DIR="$(dirname "$(readlink -f "$0")")"
INFRA='timescaledb|_broker-|mosquitto'
"$DIR/initialize.sh" || exit 1
"$DIR/_for_each_service.sh" -r down
"$DIR/_for_each_service.sh" -f "$INFRA" up -d
"$DIR/_for_each_service.sh" -x "$INFRA" up -d
