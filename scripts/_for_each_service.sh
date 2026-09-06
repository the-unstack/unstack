#!/bin/bash
# usage: _for_each_service.sh [-r] [-f REGEX | -x REGEX] <docker compose args...>
#   -r  descending order   -f only dirs matching REGEX   -x skip dirs matching REGEX
# runs `docker compose <args>` in every NN_* dir that has .autostart; keeps going, exit 1 if any failed
# shellcheck source=scripts/_lib.sh
source "$(dirname "$(readlink -f "$0")")/_lib.sh"

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

# process substitution: grep "no match" (rc 1) cannot trip errexit/pipefail here
mapfile -d '' dirs < <(find "$ROOT_DIR" -maxdepth 1 -type d -name '[0-9][0-9]_*' -print0 | "${SORT[@]}" | "${FILTER[@]}")

rc=0
for dir in "${dirs[@]}"; do
    dir_name=$(basename "$dir")
    echo "***** $dir_name *****"
    [ -f "$dir/docker-compose.yml" ] || { echo "  no docker-compose.yml, skipping"; continue; }
    [ -f "$dir/.autostart" ]         || { echo "  no .autostart file, skipping";   continue; }
    echo "docker compose $*..."
    (cd "$dir" && docker compose "$@") || { rc=1; echo "FAILED: $dir_name (docker compose $*)" >&2; }
    echo ""
done
exit $rc
