#!/bin/bash

# Configuration
CONNECT_CONTAINER="connect-global-to-postgres"
REDIS_CONTAINER="connect-global-to-postgres-redis"
INITIAL_WAIT=60
CHECK_INTERVAL=60
LOG_PREFIX="[MONITOR]"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $LOG_PREFIX $1"
}


log "Starting monitor for $CONNECT_CONTAINER and $REDIS_CONTAINER"
log "Initial state for $CONNECT_CONTAINER: $(docker inspect --format='{{.State.Status}} {{.State.Health.Status}}' "$CONNECT_CONTAINER")"
log "Initial state for $REDIS_CONTAINER: $(docker inspect --format='{{.State.Status}} {{.State.Health.Status}}' "$REDIS_CONTAINER")"

log "Waiting for containers to be ready..."
sleep $INITIAL_WAIT



while true; do
    CONNECT_HEALTH=$(docker inspect --format='{{.State.Health.Status}}' "$CONNECT_CONTAINER")
    log "$CONNECT_CONTAINER="$CONNECT_HEALTH

    if [ "$CONNECT_HEALTH" = "unhealthy" ]; then
        log "Connect container unhealthy -> restarting redis"
        docker restart "$REDIS_CONTAINER"
    fi

    sleep $CHECK_INTERVAL
done