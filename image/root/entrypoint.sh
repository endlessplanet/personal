#!/bin/sh

cleanup() {
    true
} &&
    docker \
        service \
        create \
        --name gitlab \
        gitlab/gitlab-ce:latest &&
    docker \
        service \
        create \
        --name chromium \
        --env DISPLAY \
        --mount type=volume,source=/var/opt/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
        sassmann/debian-chromium:latest &&
    sh