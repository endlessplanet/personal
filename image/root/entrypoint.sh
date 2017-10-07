#!/bin/sh

export PATH=${HOME}/bin:${PATH} &&
    docker image pull gitlab/gitlab-ce:latest &&
    docker image pull xueshanf/awscli &&
    docker image pull sassmann/debian-chromium &&
    docker \
        container \
        create \
        --name chromium \
        --restart always \
        --mount type=bind,source=/srv/root/tmp/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
        --env DISPLAY \
        sassmann/debian-chromium &&
    docker \
        container \
        create \
        --name gitlab \
        --restart always \
        gitlab/gitlab-ce:latest &&
    docker network connect bridge chromium &&
    docker network connect --alias gitlab bridge gitlab &&
    docker container ps --all --quiet | while read ID
    do
        docker container start ${ID}
    done &&
    bash