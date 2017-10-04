#!/bin/sh

WORKDIR=$(mktemp -d) &&
    cleanup() {
        rm -rf ${WORKDIR} &&
            true
    } &&
    docker \
        service \
        create \
        --detach=true \
        --hostname gitlab \
        --name gitlab \
        gitlab/gitlab-ce:latest &&
    docker \
        service \
        create \
        --detach=true \
        --env DISPLAY \
        --mount type=bind,source=/var/opt/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
        sassmann/debian-chromium:latest &&
    while [[ ! "$(docker service ps gitlab --format {{.CurrentState}})" =~ "Running" ]]
    do
        echo waiting for gitlab to start &&
            sleep 10s
    done &&
    echo gitlab has started &&
    # ls -1 ${HOME}/data/gitlab-data | while read FILE
    # do
    #     cp ${HOME}/data/gitlab-data/${FILE} ${WORKDIR}/${FILE} &&
    #     cd ${WORKDIR} &&
    #     rm -f ${FILE}
    # done &&
    bash