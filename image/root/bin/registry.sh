#!/bin/sh

docker volume create registry-certs &&
    cat \
        /opt/docker/ssl/registry.txt | docker \
        container \
        run \
        --interactive \
        --rm \
        --mount type=volume,source=registry-certs,destination=/certs \
        --workdir /etc/gitlab/ssl \
        jordi/openssl \
            openssl \
            req -x509 \
            -newkey rsa:4096 \
            -keyout gitlab.key \
            -out gitlab.crt \
            -days 365 \
            -nodes &&
docker container run registry:2.5.2