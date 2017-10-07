#!/bin/sh

export PATH=${HOME}/bin:${PATH} &&
    (cd dockerfiles && sh build-images.sh) &&
    docker image pull gitlab/gitlab-ce:latest &&
    docker \
        container \
        create \
        --restart always \
        --mount type=bind,source=/srv/root/tmp/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
        --env DISPLAY \
        firefox &&
    docker \
        container \
        create \
        --name gitlab \
        --mount type=volume,source=gitlab-config,destination=/etc/gitlab,readonly=true \
        gitlab/gitlab-ce:latest &&
    docker container ps --all --quiet | while read ID
    do
        docker container start ${ID}
    done &&
    bash