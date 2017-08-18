#!/bin/sh

docker \
    run \
    --interactive \
    --tty \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --env DISPLAY \
    --env ID_RSA="$(cat ~/.ssh/vxD3wgSe_id_rsa)" \
    --env ID_RSA_PUB="$(cat ~/.ssh/vxD3wgSe_id_rsa.pub)" \
    --env KNOWN_HOSTS="$(cat ~/.ssh/known_hosts)" \
    --env USERNAME="Emory Merryman" \
    --env EMAIL="emory.merryman@gmail.com" \
    --env GPG_KEY_ID="D65D3F8C" \
    --env GPG_PRIVATE_KEY="$(cat ~/important/gpg/secret1.key)" \
    --env GPG_OWNER_TRUST="$(cat ~/important/gpg/owner1.trust)" \
    personal
