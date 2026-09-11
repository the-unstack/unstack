#!/bin/bash
# Shared preamble. Source it, never run it.
#   ROOT_DIR   repo root (via readlink -f of this file)
#   SCRIPT_DIR dir of the invoked script, symlink NOT resolved (= service dir for per-service symlinks)
#   load_env   load_env global|edge: source $ROOT_DIR/.env.<side> or exit 1
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"
# shellcheck disable=SC2034  # used by sourcing scripts
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

load_env() {
    local f="$ROOT_DIR/.env.$1"
    [ -f "$f" ] || { echo "missing $f  (cp .env.$1.example .env.$1 && edit)" >&2; exit 1; }
    # shellcheck source=/dev/null
    source "$f"
}
