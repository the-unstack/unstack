#!/bin/bash
# Shared preamble. Source it, never run it.
#   ROOT_DIR   repo root (via readlink -f of this file)
#   SCRIPT_DIR dir of the invoked script, symlink NOT resolved (= service dir for per-service symlinks)
#   load_env   source $ROOT_DIR/.env or exit 1
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"
# shellcheck disable=SC2034  # used by sourcing scripts
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

load_env() {
    [ -f "$ROOT_DIR/.env" ] || { echo "missing $ROOT_DIR/.env  (cp .env.example .env && edit)" >&2; exit 1; }
    # shellcheck source=/dev/null
    source "$ROOT_DIR/.env"
}
