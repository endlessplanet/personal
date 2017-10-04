#!/bin/sh

cleanup(){
    docker container stop $(cat manager.id) $(cat personal.id) &&
        docker rm --volumes $(cat manager.id) $(cat personal.id) &&
        docker network rm $(cat ctrl.id) &&
        rm --force manager.id personal.id ctrl.id
}
    trap cleanup EXIT &&
    docker network create $(uuidgen) --subnet 10.0.2.0/24 > ctrl.id &&
    docker \
        container \
        create \
        --cidfile manager.id \
        --privileged \
        --volume /tmp/.X11-unix:/var/opt/.X11-unix:ro \
        docker:17.09.0-ce-dind \
            --host tcp://0.0.0.0:2376 &&
    docker \
        container \
        create \
        --cidfile personal.id \
        --interactive \
        --tty \
        --env DISPLAY \
        --env DOCKER_HOST=tcp://manager:2376 \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        endlessplanet/personal:$(git rev-parse --verify HEAD) &&
    docker network connect --alias manager --ip 10.0.2.200 $(cat ctrl.id) $(cat manager.id) &&
    docker network connect $(cat ctrl.id) $(cat personal.id) &&
    docker container start $(cat manager.id) &&
    docker container exec --interactive --tty $(cat manager.id) docker swarm init --advertise-addr 10.0.2.200 &&
    docker container start --interactive $(cat personal.id)