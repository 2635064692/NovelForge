#!/bin/bash
set -e
cd "$(dirname "$0")"

if [ "$1" = "stop" ]; then
    docker compose down
elif [ "$1" = "rebuild" ]; then
    docker compose build --no-cache
    docker compose up
elif [ "$1" = "-d" ] || [ "$1" = "--detach" ]; then
    docker compose up -d
else
    docker compose up --build
fi
