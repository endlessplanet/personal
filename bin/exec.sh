#!/bin/sh

docker \
	run \
	--interactive \
	--tty \
	--rm \
	--entrypoint sh \
	--volume /var/run/docker.sock:/var/run/docker.sock:ro \
	endlessplanet/personal 
