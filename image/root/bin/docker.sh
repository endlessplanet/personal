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
    if [ -t 0 ]
    then
        echo ALPHA &&
        tee | /usr/bin/docker start --interactive $(cat ${CIDFILE})
    else
        echo BETA &&
        /usr/bin/docker start --interactive $(cat ${CIDFILE})
    fi