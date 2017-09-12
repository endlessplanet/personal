#!/bin/sh

CID_FILE=$(mktemp) &&
    cleanup(){
        docker container stop $(cat ${CID_FILE}) &&
            docker container rm $(cat ${CID_FILE}) &&
            rm -f ${CID_FILE}
    } &&
    trap cleanup EXIT &&
    rm ${CID_FILE} &&
    docker \
    	container \
    	create \
    	--cidfile ${CID_FILE} \
    	--interactive \
    	--tty \
    	--env DISPLAY \
    	--env PROJECT_NAME \
    	--env ID_RSA="$(cat ~/.ssh/id_rsa)" \
    	--env KNOWN_HOSTS="$(cat ~/.ssh/known_hosts)" \
    	--env USERNAME="Emory Merryman" \
    	--env EMAIL="emory.merryman@gmail.com" \
    	--env ORIGIN \
    	--env UPSTREAM \
    	--env REPORT \
    	--env HOST_UID=1000 \
    	--volume /var/run/docker.sock:/var/run/docker.sock:ro \
    	endlessplanet/personal:$(git rev-parse --verify HEAD) &&
    docker container start --interactive $(cat ${CID_FILE})