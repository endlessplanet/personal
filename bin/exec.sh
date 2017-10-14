#!/bin/sh

DIND=$(mktemp) &&
    WORK=$(mktemp) &&
    REG=$(mktemp) &&
    NET=$(mktemp) &&
    CERTS=$(mktemp) &&
    rm -f ${DIND} ${WORK} ${NET} ${REG} ${CERTS} &&
    cleanup(){
        docker container stop $(cat ${DIND}) $(cat ${WORK}) $(cat ${REG}) &&
            docker container rm --volumes $(cat ${DIND}) $(cat ${WORK}) $(cat ${REG}) &&
            docker network rm $(cat ${NET}) &&
            docker volume rm $(cat ${CERTS}) &&
            rm -f ${DIND} ${WORK} ${REG} ${NET}
    } &&
    trap cleanup EXIT &&
    docker volume create > ${CERTS} &&
    cat \
        /opt/docker/ssl/registry.txt | docker \
        container \
        run \
        --interactive \
        --rm \
        --volume $(cat ${CERTS}):/certs \
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
        --cidfile ${REG} \
        --volume $(cat ${CERTS}):/certs \
        --env REGISTRY_HTTP_ADDR=0.0.0.0:80 \
        --env REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt \
        --env REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
        --env REGISTRY_HTTP_SECRET=$(uuidgen) \
        --env REGISTRATION_AUTH_SILLY_REALM=silly-realm \
        --env REGISTRATION_AUTH_SILLY_SERVICE=silly-service \
        registry:2.5.2 
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
        --volume $(cat ${CERTS}):/certs:ro \
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
    docker network connect --alias registry $(cat ${NET}) $(cat ${REG}) &&
    docker network connect --alias docker $(cat ${NET}) $(cat ${DIND}) &&
    docker network connect $(cat ${NET}) $(cat ${WORK}) &&
    docker container start $(cat ${DIND}) &&
    docker container start --interactive $(cat ${WORK})