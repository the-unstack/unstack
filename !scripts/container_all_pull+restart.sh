#!/bin/bash

# Repo root (works via root symlink and from !scripts/)
ROOT_DIR="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)"
"$ROOT_DIR/!scripts/initialize.sh" || exit 1

# Find and process directories
find "$ROOT_DIR" -maxdepth 1 -type d -name '[0-9][0-9]_*' -print0 | sort -rz | while IFS= read -r -d '' dir; do
    dir_name=$(basename "$dir")
    echo "***** $dir_name *****"

    # Check for docker-compose.yml
    if [ ! -f "$dir/docker-compose.yml" ]; then
        echo "no docker-compose.yml, skipping"
        continue
    fi

    # Check for .autostart file
    if [ ! -f "$dir/.autostart" ]; then
        echo "  no .autostart file, skipping"
        continue
    fi

    # run docker compose
    echo "docker compose pull & docker compose down & docker compose up -d..."
    cd "$dir" && docker compose pull && docker compose down && docker compose up -d
    cd "$ROOT_DIR"
    echo ""
done