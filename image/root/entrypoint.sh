#!/bin/sh

cleanup() {
    bash
} &&
    trap cleanup EXIT &&
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
    while [[ ! "$(docker service ps gitlab --format {{.CurrentState}})" =~ "Running" ]]
    do
        echo waiting for gitlab to start &&
            sleep 10s
    done &&
    echo gitlab has started &&
    skipit(){
        ls -1 ${HOME}/data/gitlab-data | while read FILE
        do
            gunzip ${HOME}/data/gitlab-data/${FILE} &&
                rm -f ${HOME}/data/gitlab-data/${FILE%*.gz}
        done
    } &&
    bash