#!/bin/sh

docker network create --driver overlay --subnet 10.0.3.0/24 test &&
    docker \
        service \
        create \
        --hostname gitlab \
        --name gitlab \
        --network test \
         gitlab/gitlab-ce:latest &&
    docker \
        service \
        create \
        --env DISPLAY \
        --mount type=bind,source=/var/opt/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
        --network test \
        sassmann/debian-chromium:latest &&
    echo docker service ps gitlab --format {{.CurrentState}} &&
    sh &&
    echo gitlab has started