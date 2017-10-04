#!/bin/sh

cleanup() {
    bash
} &&
    trap cleanup EXIT &&
    cat /opt/docker/openssl.txt | openssl req -x509 -newkey rsa:4096 -keyout gitlab.key -out gitlab.crt -days 365 -nodes &&
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
    docker container cp /opt/docker/gitlab.rb gitlab.1.$(docker service ps gitlab --no-trunc --format {{.ID}}):/etc/gitlab/gitlab.rb &&
    docker container exec --interactive --tty gitlab.1.$(docker service ps gitlab --no-trunc --format {{.ID}}) mkdir /etc/gitlab/ssl &&
    docker container exec --interactive --tty gitlab.1.$(docker service ps gitlab --no-trunc --format {{.ID}}) chmod 0664 /etc/gitlab/ssl &&
    docker container cp gitlab.crt gitlab.1.$(docker service ps gitlab --no-trunc --format {{.ID}}):/etc/gitlab/ssl/gitlab.crt &&
    docker container cp gitlab.key gitlab.1.$(docker service ps gitlab --no-trunc --format {{.ID}}):/etc/gitlab/ssl/gitlab.key &&
    docker container exec --interactive --tty gitlab.1.$(docker service ps gitlab --no-trunc --format {{.ID}}) gitlab-ctl start &&
    skipit(){
        ls -1 ${HOME}/data/gitlab-data | while read FILE
        do
            gunzip ${HOME}/data/gitlab-data/${FILE} &&
                rm -f ${HOME}/data/gitlab-data/${FILE%*.gz}
        done
    } &&
    bash