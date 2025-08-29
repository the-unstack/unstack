#!/bin/bash

# Print header
printf "%-28s %-32s %-20s %s\n" "NAMES" "IMAGE" "CREATED" "STATUS"

docker ps --format "{{.Names}}|{{.Image}}|{{.RunningFor}}|{{.Status}}|{{.Ports}}" | \
while IFS='|' read -r names image created status ports; do
    printf "%-28s %-32s %-20s %s\n" "$names" "$image" "$created" "$status"
    if [ -n "$ports" ]; then
        # Split ports by comma and wrap them nicely, aligned with IMAGE column
        echo "                             PORTS: $ports" | fold -w 90 -s | sed '2,$s/^/                                    /'
    else
        printf "                            PORTS: <none>\n"
    fi
done

