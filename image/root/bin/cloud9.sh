#!/bin/sh

CIDFILE=$(mktemp) &&
    rm ${CIDFILE} &&
    docker \
        container \
        run \
        --cidfile ${CIDFILE} \
        --detach \
        sapk/cloud9 \
            --auth \
            user:password &&
    docker container exec --interactive --tty $(cat ${CIDFILE}) mkdir /root/.ssh &&
    docker container exec --interactive --tty $(cat ${CIDFILE}) chown 0700 /root/.ssh &&
    echo "${ID_RSA}" | docker container exec --interactive $(cat ${CIDFILE}) tee /root/.ssh/id_rsa &&
    docker container exec --interactive --tty $(cat ${CIDFILE}) chown 0600 /root/.ssh/id_rsa &&
    docker container exec --interactive --tty $(cat ${CIDFILE}) apt-get update --assume-yes &&
    docker container exec --interactive --tty $(cat ${CIDFILE}) apt-get install --assume-yes openssh-client git &&
    docker container exec --interactive --tty $(cat ${CIDFILE}) apt-get clean &&
    docker network connect --alias ${1} system $(cat ${CIDFILE})