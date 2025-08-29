#!/bin/bash

# Get current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find and process directories
find "$SCRIPT_DIR" -maxdepth 1 -type d -name '[0-9][0-9]_*' -print0 | sort -rz | while IFS= read -r -d '' dir; do
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
    echo "docker compose down..."
    cd "$dir" && docker compose down
    cd "$SCRIPT_DIR"
    echo ""
done