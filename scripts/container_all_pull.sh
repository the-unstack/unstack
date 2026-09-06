#!/bin/bash
# compose pull in every autostart dir. Exit 1 if any service failed.
# shellcheck source=scripts/_lib.sh
source "$(dirname "$(readlink -f "$0")")/_lib.sh"
"$ROOT_DIR/scripts/_for_each_service.sh" pull
