#!/bin/sh

cleanup(){
    docker container stop $(cat manager.id) $(cat worker-00.id) $(cat worker-01.id) $(cat personal.id) &&
        docker rm --volumes $(cat manager.id) $(cat worker-00.id) $(cat worker-01.id) $(cat personal.id) &&
        docker network rm $(cat advertise.id) $(cat data.id) $(cat ctrl.id) &&
        rm --force manager.id worker-00.id worker-01.id personal.id advertise.id data.id ctrl.id
}
    trap cleanup EXIT &&
    docker network create $(uuidgen) --subnet 10.0.0.0/24 > advertise.id &&
    docker network create $(uuidgen) --subnet 10.0.1.0/24 > data.id &&
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
        --cidfile worker-00.id \
        --privileged \
        --volume /tmp/.X11-unix:/var/opt/.X11-unix:ro \
        docker:17.09.0-ce-dind \
            --host tcp://0.0.0.0:2376 &&
    docker \
        container \
        create \
        --cidfile worker-01.id \
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
        --env DOCKER_HOST=tcp://10.0.2.200:2376 \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        endlessplanet/personal:$(git rev-parse --verify HEAD) &&
    docker network connect --ip 10.0.0.200 $(cat advertise.id) $(cat manager.id) &&
    docker network connect --ip 10.0.1.200 $(cat data.id) $(cat manager.id) &&
    docker network connect --ip 10.0.2.200 $(cat ctrl.id) $(cat manager.id) &&
    docker network connect --ip 10.0.0.100 $(cat advertise.id) $(cat worker-00.id) &&
    docker network connect --ip 10.0.1.100 $(cat data.id) $(cat worker-00.id) &&
    docker network connect --ip 10.0.0.101 $(cat advertise.id) $(cat worker-01.id) &&
    docker network connect --ip 10.0.1.201 $(cat data.id) $(cat worker-01.id) &&
    docker network connect --ip 10.0.0.51 $(cat advertise.id) $(cat personal.id) &&
    docker network connect --ip 10.0.1.51 $(cat data.id) $(cat personal.id) &&
    docker network connect --ip 10.0.2.51 $(cat ctrl.id) $(cat personal.id) &&
    docker container start $(cat manager.id) $(cat worker-00.id) $(cat worker-01.id) &&
    docker container exec --interactive --tty $(cat manager.id) docker swarm init --advertise-addr 10.0.0.200 --data-path-addr 10.0.1.200 &&
    JOIN_TOKEN=$(docker container exec --interactive --tty $(cat manager.id) docker swarm join-token --quiet manager | tr -cd "[:print:]") &&
    docker container exec --interactive --tty $(cat worker-00.id) docker swarm join --token "${JOIN_TOKEN}" --advertise-addr 10.0.0.100 --data-path-addr 10.0.1.100 10.0.0.200:2377 &&
    docker container exec --interactive --tty $(cat worker-01.id) docker swarm join --token "${JOIN_TOKEN}" --advertise-addr 10.0.0.101 --data-path-addr 10.0.1.100 10.0.0.200:2377 &&
    docker container start --interactive $(cat personal.id)