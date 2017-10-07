#!/bin/sh

DIND=$(mktemp) &&
    WORK=$(mktemp) &&
    NET=$(mktemp) &&
    rm -f ${DIND} ${WORK} ${NET} &&
    cleanup(){
        docker container stop $(cat ${DIND}) $(cat ${WORK}) &&
            docker container rm --volumes $(cat ${DIND}) $(cat ${WORK}) &&
            docker network rm $(cat ${NET}) &&
            rm -f ${DIND} ${WORK} ${NET}
    } &&
    trap cleanup EXIT &&
    docker \
        container \
        create \
        --cidfile ${DIND} \
        --privileged \
        --volume /tmp/.X11-unix:/var/opt/.X11-unix:ro \
        --env DISPLAY \
        docker:17.09.0-ce-dind \
            --host tcp://0.0.0.0:3276 &&
    docker \
        container \
        create \
        --cidfile ${WORK} \
        --interactive \
        --tty \
        --env DOCKER_HOST=tcp://docker:3276 \
        --env DISPLAY \
        endlessplanet/personal:$(git rev-parse --verify HEAD) &&
    docker network create $(uuidgen) > ${NET} &&
    docker network connect --alias docker $(cat ${NET}) $(cat ${DIND}) &&
    docker network connect $(cat ${NET}) $(cat ${WORK}) &&
    docker container start $(cat ${DIND}) &&
    docker container start --interactive $(cat ${WORK})