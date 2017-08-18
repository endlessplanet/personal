#!/bin/sh

docker \
    run \
    --interactive \
    --tty \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --env DISPLAY \
    --env ID_RSA="$(cat ~/.ssh/vxD3wgSe_id_rsa)" \
    --env KNOWN_HOSTS="$(cat ~/.ssh/known_hosts)" \
    --env USERNAME="Emory Merryman" \
    --env EMAIL="emory.merryman@gmail.com" \
    personal
