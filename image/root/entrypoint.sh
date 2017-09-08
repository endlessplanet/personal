#!/bin/sh

trap cleanup EXIT &&
	docker \
		container \
		create \
		--cidfile ${HOME}/docker/containers/sshd \
		rastasheep/ubuntu-sshd:16.04 &&
	docker \
		container \
		create \
		--cidfile ${HOME}/docker/containers/cloud9 \
		rawmind/cloud9-sdk:0.3.0 \
		--listen 0.0.0.0 \
		--auth username:password &&
		--publish-all &&
	docker network create $(uuidgen) > ${HOME}/docker/networks/default &&
	docker network connect --alias $(cat ${HOME}/docker/networks/default) $(cat ${HOME}/docker/containers/sshd) &&
	docker network connect $(cat ${HOME}/docker/networks/default) $(cat ${HOME}/docker/containers/cloud9) &&
	docker network start $(cat ${HOME}/docker/containers/sshd) &&
	docker network start $(cat ${HOME}/docker/containers/cloud9)


