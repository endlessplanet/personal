#!/bin/sh

cleanup(){
    docker container stop $(cat manager.id) $(cat worker-01.id) $(cat personal.id) &&
        docker rm --volumes $(cat manager.id) $(cat worker-01.id) $(cat personal.id) &&
        docker network rm $(cat network.id) $(cat overlay.id) &&
        rm --force manager.id worker-01.id personal.id network.id overlay.id
}
    trap cleanup EXIT &&
    docker network create $(uuidgen) > network.id &&
    docker network create --driver overlay $(uuidgen) > overlay.id &&
    docker \
        container \
        create \
        --cidfile manager.id \
        --privileged \
        --volume /tmp/.X11-unix:/var/opt/.X11-unix:ro \
        --network $(cat overlay.id) \
        docker:17.09.0-ce-dind \
            --host tcp://0.0.0.0:2376 &&
    docker \
        container \
        create \
        --cidfile worker-01.id \
        --privileged \
        --volume /tmp/.X11-unix:/var/opt/.X11-unix:ro \
        --network $(cat overlay.id) \
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
    docker network connect --alias docker0 $(cat network.id) $(cat manager.id) &&
    docker network connect --alias docker1 $(cat network.id) $(cat worker-01.id) &&
    docker network connect $(cat network.id) $(cat personal.id)
    docker container start $(cat manager.id) $(cat worker-01.id) &&
    docker container exec --interactive --tty $(cat manager.id) docker swarm init --advertise-addr docker0 &&
    JOIN_TOKEN=$(docker container exec --interactive --tty $(cat manager.id) docker swarm join-token --quiet worker | tr -cd "[:print:]") &&
    docker container exec --interactive --tty $(cat worker-01.id) docker swarm join --token "${JOIN_TOKEN}" docker0:2377 &&
    docker container start --interactive $(cat personal.id)