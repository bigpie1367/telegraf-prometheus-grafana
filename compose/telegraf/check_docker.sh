#!/bin/bash

/usr/bin/docker ps -a --format '{{.Names}} {{.State}}' | while read name state; do
    case "$state" in
        "running")
            state_value=1
            ;;
        "exited")
            state_value=0
            ;;
        *)
            state_value=-1
            ;;
    esac
    echo "docker_ps_info{name=\"$name\", state=\"$state\"} $state_value"
done