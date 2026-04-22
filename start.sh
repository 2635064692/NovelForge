#!/bin/bash
set -e
cd "$(dirname "$0")"

# Auto-detect docker compose command
if docker compose version &>/dev/null; then
    DC="docker compose"
elif docker-compose --version &>/dev/null; then
    DC="docker-compose"
else
    echo "Error: docker compose not found" >&2; exit 1
fi

if [ "$1" = "stop" ]; then
    $DC down
elif [ "$1" = "rebuild" ]; then
    $DC build --no-cache
    $DC up
elif [ "$1" = "-d" ] || [ "$1" = "--detach" ]; then
    $DC up -d
else
    $DC up --build
fi
