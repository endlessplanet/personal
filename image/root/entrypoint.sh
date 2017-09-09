#!/bin/sh

source /home/user/bin/environment_setup &&
	trap cleanup EXIT &&
	docker network create $(uuidgen) > ${HOME}/docker/networks/default &&
	docker \
		container \
		create \
		--tty \
		--cidfile ${HOME}/docker/containers/sshd \
		endlessplanet/sshd &&
	docker network connect --alias sshd $(cat ${HOME}/docker/networks/default) $(cat ${HOME}/docker/containers/sshd) &&
	echo ABOUT TO CREATE SHELL CONTAINER WITH PROJECT_NAME=${PROJECT_NAME} &&
	docker \
		container \
		create \
		--cidfile ${HOME}/docker/containers/shell \
		--env PROJECT_NAME="${PROJECT_NAME}" \
		--env ID_RSA="${ID_RSA}" \
		--env KNOWN_HOSTS="${KNOWN_HOSTS}" \
		--env USERNAME="${USERNAME}" \
		--env EMAIL="${EMAIL}" \
		--env ORIGIN="${ORIGIN}" \
		--env UPSTREAM="${UPSTREAM}" \
		--env REPORT="${REPORT}" \
		--env DISPLAY="${DISPLAY}" \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		endlessplanet/shell &&
	docker network connect $(cat ${HOME}/docker/networks/default) $(cat ${HOME}/docker/containers/shell) &&
    docker \
        inspect \
        --format "{{ range .Mounts }}{{ if eq .Destination \"/workspace\" }}{{ .Name }}{{ end }}{{ end }}" \
        $(cat ${HOME}/docker/containers/shell) > ${HOME}/docker/volumes/workspace &&
    docker \
		container \
		create \
		--cidfile ${HOME}/docker/containers/cloud9 \
		--env CONTAINER_ID=$(cat ${HOME}/docker/containers/shell) \
		--env SSHD_CONTAINER=$(cat ${HOME}/docker/containers/sshd) \
		--volume /var/run/docker.sock:/var/run/docker.sock:ro \
		--volume $(cat ${HOME}/docker/volumes/workspace):/workspace \
		endlessplanet/cloud9 &&
	docker network connect $(cat ${HOME}/docker/networks/default) $(cat ${HOME}/docker/containers/cloud9) &&
	docker network connect --alias ${PROJECT_NAME} entrypoint_default $(cat ${HOME}/docker/containers/cloud9) &&
	docker container start $(cat ${HOME}/docker/containers/sshd) &&
	docker container start $(cat ${HOME}/docker/containers/shell) &&
	docker container start $(cat ${HOME}/docker/containers/cloud9) &&
	docker container logs $(cat ${HOME}/docker/containers/cloud9) &&
	bash


