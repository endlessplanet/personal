#!/bin/sh

cleanup() {
    true
} &&
    docker \
        service \
        create \
        --detach=true \
        --name gitlab \
        gitlab/gitlab-ce:latest &&
    docker \
        service \
        create \
        --detach=true \
        --env DISPLAY \
        --mount type=bind,source=/var/opt/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
        sassmann/debian-chromium:latest &&
    sh