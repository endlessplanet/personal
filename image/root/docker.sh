#!/bin/sh

CIDFILE=$(mktemp) &&
    cleanup(){
        /usr/bin/docker container stop $(cat ${CIDFILE}) &&
            docker container rm --volumes $(cat ${CIDFILE}) &&
            rm ${CIDFILE}
    } &&
    rm ${CIDFILE} &&
    /usr/bin/docker container create --cid ${CIDFILE} --interactive --tty docker:17.09.0-ce "${@}" &&
    /usr/bin/docker container start --interactive $(cat ${CIDFILE})