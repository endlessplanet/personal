#!/bin/sh

cleanup(){
    docker container stop $(cat dind.id) $(cat personal.id) &&
        docker rm --volumes $(cat dind.id) $(cat personal.id) &&
        docker network rm $(cat network.id) &&
        rm --force dind.id personal.id network.id
}
    trap cleanup EXIT &&
    docker network create $(uuidgen) > network.id &&
    docker container create --cidfile dind.id --privileged docker:17.09.0-ce-dind --host tcp://0.0.0.0:2376 &&
    docker \
        container \
        create \
        --cidfile personal.id \
        --interactive \
        --tty \
        --env DOCKER_HOST=tcp://docker:2376 \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        endlessplanet/personal:$(git rev-parse --verify HEAD) &&
    docker network connect --alias docker $(cat network.id) $(cat dind.id) &&
    docker network connect $(cat network.id) $(cat personal.id)
    docker container start $(cat dind.id) &&
    docker container start --interactive $(cat personal.id)