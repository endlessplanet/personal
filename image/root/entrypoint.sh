#!/bin/sh

export PATH=${HOME}/bin:${PATH} &&
    (cd dockerfiles && sh build-images.sh) &&
    docker image pull gitlab/gitlab-ce:latest &&
    docker container create --restart always --mount type=bind,source=/srv/root/tmp/.X11-unix,destination=/tmp/.X11-unix,readonly=true firefox &&
    docker container ps --all --quiet | while read ID
    do
        docker container start ${ID}
    done &&
    bash