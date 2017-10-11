#!/bin/sh

CIDFILE=$(mktemp) &&
    rm ${CIDFILE} &&
    docker \
        container \
        run \
        --cidfile ${CIDFILE} \
        --detach \
        sapk/cloud9
            --auth \
            user:password &&
    docker network connect --alias ${1} system $(cat ${CIDFILE})