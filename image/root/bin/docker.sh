#!/bin/sh

CIDFILE=$(mktemp) &&
    cleanup(){
        /usr/bin/docker stop $(cat ${CIDFILE}) &&
            docker rm --volumes $(cat ${CIDFILE}) &&
            rm -f ${CIDFILE}
    } &&
    rm ${CIDFILE} &&
    /usr/bin/docker \
        create \
        --cidfile ${CIDFILE} \
        --interactive \
        --env DISPLAY \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        docker:17.09.0-ce \
            "${@}" &&
        /usr/bin/docker start --interactive $(cat ${CIDFILE})