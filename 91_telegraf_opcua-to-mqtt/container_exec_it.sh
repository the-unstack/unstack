#!/bin/bash
# shellcheck source=!scripts/_lib.sh
source "$(dirname "$0")/../!scripts/_lib.sh"
docker exec -it telegraf-opcua-to-mqtt sh
