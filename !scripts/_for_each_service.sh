#!/bin/bash
# usage: _for_each_service.sh [-r] [-f REGEX | -x REGEX] <docker compose args...>
#   -r  descending order   -f only dirs matching REGEX   -x skip dirs matching REGEX
# runs `docker compose <args>` in every NN_* dir that has .autostart
ROOT_DIR="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)"

SORT=(sort -z); FILTER=(cat)
while getopts "rf:x:" opt; do
    case $opt in
        r) SORT=(sort -rz) ;;
        f) FILTER=(grep -zE  "$OPTARG") ;;
        x) FILTER=(grep -zvE "$OPTARG") ;;
        *) exit 1 ;;
    esac
done
shift $((OPTIND - 1))
[ $# -gt 0 ] || { echo "usage: $0 [-r] [-f REGEX | -x REGEX] <docker compose args...>"; exit 1; }

find "$ROOT_DIR" -maxdepth 1 -type d -name '[0-9][0-9]_*' -print0 | "${SORT[@]}" | "${FILTER[@]}" | while IFS= read -r -d '' dir; do
    dir_name=$(basename "$dir")
    echo "***** $dir_name *****"

    if [ ! -f "$dir/docker-compose.yml" ]; then
        echo "no docker-compose.yml, skipping"
        continue
    fi
    if [ ! -f "$dir/.autostart" ]; then
        echo "  no .autostart file, skipping"
        continue
    fi

    echo "docker compose $*..."
    (cd "$dir" && docker compose "$@")
    echo ""
done
