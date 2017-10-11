#!/bin/sh

docker volume create registry-certs &&
    cat \
        /opt/docker/ssl/registry.txt | docker \
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
            -nodes &&
docker \
    container \
    run \
    --publish-all \
    --detach \
    --mount type=volume,source=registry-certs,destination=/certs \
    --env REGISTRY_HTTP_ADDR=0.0.0.0:80 \
    --env REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt \
    --env REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
    --env REGISTRY_HTTP_SECRET=$(uuidgen) \
    registry:2.5.2