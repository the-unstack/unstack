#!/bin/bash
# compose down, descending (99 → 05). Exit 1 if any service failed.
# shellcheck source=scripts/_lib.sh
source "$(dirname "$(readlink -f "$0")")/_lib.sh"
"$ROOT_DIR/scripts/_for_each_service.sh" -r down --remove-orphans
