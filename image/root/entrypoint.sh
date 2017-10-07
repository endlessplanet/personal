#!/bin/sh

export PATH=${HOME}/bin:${PATH} &&
    (cd dockerfiles && sh build-images.sh) &&
    docker image pull gitlab/gitlab-ce:latest &&
    docker container create --restart always --mount /srv/root/tmp/.X11-unix:/tmp/.X11-unix:ro firefox &&
    docker container ps --all --quiet | while read ID
    do
        docker container start ${ID}
    done &&
    bash