#!/bin/sh

export PROJECT_NAME &&
	export ID_RSA &&
	export KNOWN_HOSTS &&
	export USERNAME &&
	export EMAIL &&
	export ORIGIN &&
	export UPSTREAM &&
	export REPORT &&
	export DISPLAY &&
	SHELL_CIDFILE=$(mktemp ${HOME}/docker/containers/shell-XXXXXXXX) &&
	rm -f ${SHELL_CIDFILE} &&
	docker \
		container \
		create \
		--cidfile ${SHELL_CIDFILE} \
		--env PROJECT_NAME \
		--env ID_RSA \
		--env KNOWN_HOSTS \
		--env USERNAME \
		--env EMAIL \
		--env ORIGIN \
		--env UPSTREAM \
		--env REPORT  \
		--env DISPLAY \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		endlessplanet/shell:58f3412432dbff15ad68fe6ceb6b12528346c507 &&
	docker network connect $(cat ${HOME}/docker/networks/default) $(cat ${SHELL_CIDFILE}) &&
	WORKPLACE_VOLUME=$(mktemp ${HOME}/docker/volumes/workplace-XXXXXXX) &&
	rm -f ${WORKPLACE_VOLUME} &&
    docker \
        inspect \
        --format "{{ range .Mounts }}{{ if eq .Destination \"/workspace\" }}{{ .Name }}{{ end }}{{ end }}" \
        $(cat ${SHELL_CIDFILE}) > ${WORKPLACE_VOLUME} &&
    CLOUD9_CIDFILE=$(mktemp ${HOME}/docker/containers/cloud9-XXXXXXX) &&
    rm -f ${CLOUD9_CIDFILE} &&
    docker \
		container \
		create \
		--cidfile ${CLOUD9_CIDFILE} \
		--env CONTAINER_ID=$(cat ${SHELL_CIDFILE}) \
		--env SSHD_CONTAINER=$(cat ${HOME}/docker/containers/sshd) \
		--volume /var/run/docker.sock:/var/run/docker.sock:ro \
		--volume $(cat ${WORKPLACE_VOLUME}):/workspace \
		endlessplanet/cloud9:ef76031eb6d81f47a84ea76abe43d8d3eeb9a0bf &&
	docker network connect --alias ${PROJECT_NAME} $(cat ${HOME}/docker/networks/default) $(cat ${CLOUD9_CIDFILE}) &&
	docker container start $(cat ${SHELL_CIDFILE}) &&
	docker container start $(cat ${CLOUD9_CIDFILE})
