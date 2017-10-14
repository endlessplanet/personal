#!/bin/sh

DIND=$(mktemp) &&
    WORK=$(mktemp) &&
    NET=$(mktemp) &&
    CERTS=$(mktemp) &&
    rm -f ${DIND} ${WORK} ${NET} &&
    cleanup(){
        docker container stop $(cat ${DIND}) $(cat ${WORK}) &&
            docker container rm --volumes $(cat ${DIND}) $(cat ${WORK}) &&
            docker network rm $(cat ${NET}) &&
            docker volume rm $(cat ${CERTS}) &&
            rm -f ${DIND} ${WORK} ${NET} ${CERTS}
    } &&
    trap cleanup EXIT &&
    docker volume create certs &&
    cat \
        image/root/ssl/registry.txt | docker \
        container \
        run \
        --interactive \
        --rm \
        --mount type=volume,source=registry-certs,destination=/certs \
        --workdir /certs \
        jordi/openssl \
            openssl \
            req -x509 \
            -newkey rsa:4096 \
            -keyout registry.key \
            -out registry.crt \
            -days 365 \
            -nodes 
    docker \
        container \
        create \
        --cidfile ${DIND} \
        --privileged \
        --volume /:/srv/root:ro \
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
        --env AWS_ACCESS_KEY_ID \
        --env AWS_SECRET_ACCESS_KEY \
        --env AWS_DEFAULT_REGION \
        --env GITLAB_BACKUP_BUCKET \
        --env GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN \
        --env ID_RSA="$(cat id_rsa)" \
        endlessplanet/personal:$(git rev-parse --verify HEAD) &&
    docker network create $(uuidgen) > ${NET} &&
    docker network connect --alias docker $(cat ${NET}) $(cat ${DIND}) &&
    docker network connect $(cat ${NET}) $(cat ${WORK}) &&
    docker container start $(cat ${DIND}) &&
    docker container start --interactive $(cat ${WORK})