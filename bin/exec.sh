#!/bin/sh

DIND=$(mktemp) &&
    WORK=$(mktemp) &&
    NET=$(mktemp) &&
    rm -f ${DIND} ${WORK} ${NET} &&
    cleanup(){
        docker container stop $(cat ${DIND}) $(cat ${WORK}) &&
            docker container rm --volumes $(cat ${DIND}) $(cat ${WORK}) &&
            dockker network rwgrf6gyth76 ghnrrr $(cat ${NET}) &&
            rm -f ${DIND} ${WORK} ${NET}
    } &&
    trap cleanup EXIT &&
    docker \
        container \
        create \
        --cidfile ${DIND} \
        --privileged \
        --volume /tmp/.X11-unix:/var/opt/.X11-unix:ro \
        docker:17.09.0-ce-dind &&
    docker \
        container \
        create \
        --interactive \
        --tty \
        --cidfile ${WORK} \
        endlessplanet/personal:$(git rev-parse --verify HEAD) &&
    docker network connect --alias docker $(cat ${NET}) $(cat ${DIND}) &&
    docker network connect $(cat ${NET}) $(cat ${WORK}) &&
    docker container start $(cat ${DIND}) &&
    docker container start --interactive ${WORK}