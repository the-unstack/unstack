#!/bin/bash
# initialize, pull, down (descending), then up in two passes: infra first, rest after. Cron target. Exit 1 if any service failed.
# shellcheck source=!scripts/_lib.sh
source "$(dirname "$(readlink -f "$0")")/_lib.sh"
DIR="$ROOT_DIR/!scripts"; INFRA='timescaledb|_broker-|mosquitto'
"$DIR/initialize.sh"                                  # hard stop (set -e)
rc=0
"$DIR/_for_each_service.sh" pull              || rc=1 # a failed pull must not skip restart
"$DIR/_for_each_service.sh" -r down           || rc=1 # a failed down must not skip up
"$DIR/_for_each_service.sh" -f "$INFRA" up -d || rc=1
"$DIR/_for_each_service.sh" -x "$INFRA" up -d || rc=1
exit $rc
