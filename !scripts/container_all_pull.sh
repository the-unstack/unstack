#!/bin/bash
# compose pull in every autostart dir
DIR="$(dirname "$(readlink -f "$0")")"
"$DIR/_for_each_service.sh" pull
