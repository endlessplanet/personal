#!/bin/sh

docker \
	run \
	--interactive \
	--tty \
	--rm \
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
	endlessplanet/personal 
