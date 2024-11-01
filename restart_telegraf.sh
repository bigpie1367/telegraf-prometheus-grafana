#!/bin/bash

# 현재 /var/run/docker.sock 파일의 그룹 ID를 확인하여 .env 파일에 기록
DOCKER_GROUP_ID=$(stat -f '%g' /var/run/docker.sock)
echo "DOCKER_GROUP_ID=${DOCKER_GROUP_ID}" > ./compose/telegraf/.env

docker-compose -p telegraf -f ./compose/telegraf/telegraf.yml down

if [ "$1" == "build" ]; then
    docker compose -f ./compose/telegraf/telegraf.yml up --build -d      
else
    docker compose -f ./compose/telegraf/telegraf.yml up -d      
fi