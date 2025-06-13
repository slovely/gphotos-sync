#!/bin/bash

source /app/log.sh

pidof cron && (echo "cron is already running" && exit 1)

set -e

CRON_SCHEDULE=${CRON_SCHEDULE:-0 * * * *}

PUID=${PUID:-1001}
PGID=${PGID:-1001}

id abc 2>/dev/null || (
addgroup abc --gid "${PGID}" --quiet
adduser abc --uid "${PUID}" --gid "${PGID}" --disabled-password --gecos "" --quiet
)

info "running with user uid: $(id -u abc) and user gid: $(id -g abc)"

chown abc:abc /app

#sleep 1d

sudo -E -u abc sh /app/sync.sh

