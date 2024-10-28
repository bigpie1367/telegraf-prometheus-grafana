#!/bin/bash

docker-compose -p monitor -f monitor.yml down

if [ "$1" == "build" ]; then
    docker compose -p monitor -f monitor.yml up --build -d
else
    docker compose -p monitor -f monitor.yml up -d
fi