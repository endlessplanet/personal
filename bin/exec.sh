#!/bin/sh

cleanup(){
    docker container stop $(cat docker.id) &&
        rm -f docker.id
}
    trap cleanup EXIT &&
    docker \
        container \
        create \
        --cidfile docker.id \
        --privileged \
        --volume /tmp/.X11-unix:/var/opt/.X11-unix:ro \
        docker:17.09.0-ce-dind &&
    docker container start $(cat docker.id) &&
    docker container exec --interactive --tty $(cat manager.id) docker swarm init --advertise-addr 10.0.2.200 &&
    docker container cp script.sh $(cat personal.id):/script.sh &&
    docker container start $(cat personal.id) &&
    docker container exec --interactive --tty $(cat personal.id) sh /script.sh