#!/bin/sh

CIDFILE=$(mktemp) &&
    cleanup(){
        docker container stop ${CIDFILE} &&
            docker container rm --volumes ${CIDFILE} &&
            rm -f ${CIDFILE}
    }
    rm -f ${CIDFILE} &&
    docker \
        container \
        create \
        --cidfile ${CIDFILE} \
        --env DISPLAY \
        --volume /var/opt/.X11-unix:/tmp/.X11-unix:ro \
        --volume home:/home \
        silex/emacs &&
    docker container start $(cat ${CIDFILE})