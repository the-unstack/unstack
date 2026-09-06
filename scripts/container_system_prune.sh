#!/bin/bash
# removes ALL unused images, networks and volumes without asking
# shellcheck source=scripts/_lib.sh
source "$(dirname "$(readlink -f "$0")")/_lib.sh"
docker system prune -a -f --volumes
