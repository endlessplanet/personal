#!/bin/sh

docker volume create registry-auth &&
    docker \
        container \
        run \
        --entrypoint htpasswd \
        --mount type=volume,source=auth,destination=/auth \
        --workdir /auth \
        registry:2.5.2 \
            -cBb \
            htpasswd \
            user \
            password &&
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
    docker volume create docker-certs &&
    docker container run --interactive --tty --rm --volume docker-certs:/etc/docker/certs.d alpine:3.4 mkdir /etc/docker/certs.d/registry:5000 &&
    docker container run --interactive --tty --rm --volume docker-certs:/etc/docker/certs.d --volume registry-certs:/certs:ro alpine:3.4 cp /certs/registry.crt /etc/docker/certs.d/registry:5000/ca.crt &&
    docker \
        container \
        create \
        --name registry \
        --publish 80:80 \
        --publish 443:443 \
        --publish 5000:5000 \
        --mount type=volume,source=registry-certs,destination=/certs \
        --env REGISTRY_HTTP_ADDR=0.0.0.0:80 \
        --env REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt \
        --env REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
        --env REGISTRY_HTTP_SECRET=$(uuidgen) \
        --mount type=volume,source=registry-auth,destination=/auth \
        --env REGISTRATION_AUTH_SILLY_REALM=silly-realm \
        --env REGISTRATION_AUTH_SILLY_SERVICE=silly-service \
        registry:2.5.2 &&
    docker network connect --alias registry system registry &&
    docker container start registry &&
    docker run --interactive --tty --rm --volume /var/run/docker.sock:/var/run/docker.sock:ro --volume dind-certs:/etc/docker/certs.d --network system docker:17.09.0 docker image tag docker:17.09.0 registry/docker:17.09.0 &&
    docker run --interactive --tty --rm --volume /var/run/docker.sock:/var/run/docker.sock:ro --network system docker:17.09.0 docker image push registry/docker:17.09.0 &&

    docker run --interactive --tty --rm --env DOCKER_HOST=tcp://dind:3276 --network system docker:17.09.0 docker image tag docker:17.09.0 registry/docker:17.09.0 &&
    docker run --interactive --tty --rm --volume /var/run/docker.sock:/var/run/docker.sock:ro --network system docker:17.09.0 docker image push registry/docker:17.09.0 &&
    true