#!/bin/bash
# compose pull in every autostart dir, then container_all_restart.sh. Cron target. Exit 1 if any service failed.
# shellcheck source=scripts/_lib.sh
source "$(dirname "$(readlink -f "$0")")/_lib.sh"
DIR="$ROOT_DIR/scripts"
rc=0
"$DIR/_for_each_service.sh" pull   || rc=1 # a failed pull must not skip restart
"$DIR/container_all_restart.sh"    || rc=1
exit $rc
