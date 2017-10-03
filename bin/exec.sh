#!/bin/sh

cleanup(){
    docker container stop $(cat dind0.id) $(cat dind1.id) $(cat personal.id) &&
        docker rm --volumes $(cat dind0.id) $(cat dind1.id) $(cat personal.id) &&
        docker network rm $(cat network.id) &&
        rm --force dind0.id dind1.id personal.id network.id
}
    trap cleanup EXIT &&
    docker network create $(uuidgen) > network.id &&
    docker \
        container \
        create \
        --cidfile dind0.id \
        --privileged \
        --volume /tmp/.X11-unix:/var/opt/.X11-unix:ro \
        docker:17.09.0-ce-dind \
            --host tcp://0.0.0.0:2376 &&
    docker \
        container \
        create \
        --cidfile dind1.id \
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
        --env DOCKER_HOST=tcp://docker0:2376 \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        endlessplanet/personal:$(git rev-parse --verify HEAD) &&
    docker network connect --alias docker0 $(cat network.id) $(cat dind0.id) &&
    docker network connect --alias docker1 $(cat network.id) $(cat dind1.id) &&
    docker network connect $(cat network.id) $(cat personal.id)
    docker container start $(cat dind0.id) $(cat dind1.id) &&
    docker container exec --interactive --tty $(cat dind0.id) docker swarm init --advertise-addr docker0 &&
    JOIN_TOKEN=$(docker container exec --interactive --tty $(cat dind0.id) docker swarm join-token --quiet manager | tr -cd "[:print:]") &&
    docker container exec --interactive --tty $(cat dind1.id) docker swarm join --token "${JOIN_TOKEN}" docker0:2377 &&
    docker container start --interactive $(cat personal.id)