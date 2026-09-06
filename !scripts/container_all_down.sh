#!/bin/bash
# compose down, descending (99 → 05)
DIR="$(dirname "$(readlink -f "$0")")"
"$DIR/_for_each_service.sh" -r down
