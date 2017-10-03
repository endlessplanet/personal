#!/bin/sh

CIDFILE=$(mktemp) &&
    cleanup(){
        /usr/bin/docker stop $(cat ${CIDFILE}) &&
            docker rm --volumes $(cat ${CIDFILE}) &&
            rm ${CIDFILE}
    } &&
    rm ${CIDFILE} &&
    /usr/bin/docker create --cidfile ${CIDFILE} --interactive --tty --env DOCKER_HOST docker:17.09.0-ce "${@}" &&
    /usr/bin/docker start --interactive $(cat ${CIDFILE})