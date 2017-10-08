#!/bin/sh

export PATH=${HOME}/bin:${PATH} &&
    docker network create system &&
    docker volume create gitlab-config &&
    docker \
        container \
        run \
        --interactive \
        --rm \
        --mount type=volume,source=gitlab-config,destination=/etc/gitlab \
        --workdir /etc/gitlab \
        alpine:3.4 \
            mkdir \
            ssl &&
    cat \
        /opt/docker/openssl.txt | docker \
        container \
        run \
        --interactive \
        --rm \
        --mount type=volume,source=gitlab-config,destination=/etc/gitlab \
        --workdir /etc/gitlab/ssl \
        jordi/openssl \
            openssl \
            req -x509 \
            -newkey rsa:4096 \
            -keyout gitlab.key \
            -out gitlab.crt \
            -days 365 \
            -nodes &&
    cat \
        /opt/docker/gitlab.rb | docker \
        container \
        run \
        --interactive \
        --rm \
        --mount type=volume,source=gitlab-config,destination=/etc/gitlab \
        --workdir /etc/gitlab \
        alpine:3.4 \
            tee \
            gitlab.rb &&
    export GITLAB_ROOT_PASSWORD=$(uuidgen) &&
    export GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN=$(uuidgen) &&
    docker \
        container \
        create \
        --name gitlab \
        --restart always \
        --mount type=volume,source=gitlab-config,destination=/etc/gitlab \
        --env GITLAB_ROOT_PASSWORD \
        --env GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN \
        gitlab/gitlab-ce:latest &&
    docker network connect --alias gitlab system gitlab &&
    docker container start gitlab &&
    docker \
        container \
        run \
        --detach \
        --restart always \
        --mount type=bind,source=/srv/root/tmp/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
        --mount type=volume,source=gitlab-config,destination=/etc/gitlab,readonly=true \
        --env DISPLAY \
        --network system \
        sassmann/debian-chromium &&
    echo GITLAB_ROOT_PASSWORD=${GITLAB_ROOT_PASSWORD} &&
    echo GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN=${GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN} &&
    bash