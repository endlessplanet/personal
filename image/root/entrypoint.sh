#!/bin/sh

docker image pull sassmann/debian-chromium:latest &&
    docker image pull gitlab/gitlab-ce:10.0.2-ce.0 &&
    docker image pull gitlab/gitlab-runner:v10.0.1 &&
    docker network create --driver overlay swarm-network &&
    docker image pull jare/emacs:emacs24 &&
    docker volume create homey &&
    docker volume create workspace &&
    # --device /dev/dri/card0 -v /run/user/$UID/pulse/native:/tmp/pulse -v /dev/shm:/home/user/Download \
    docker \
        service \
        create \
        --env DISPLAY \
        --mount type=bind,source=/var/opt/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
        --network swarm-network \
        docker.io/sassmann/debian-chromium:latest
    sh