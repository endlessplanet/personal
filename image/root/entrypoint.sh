#!/bin/sh

export PATH=/home/user/bin:${PATH} &&
	cleanup() {
		sh /opt/docker/cleanup.sh
	}
	trap cleanup EXIT &&
	export GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN=$(uuidgen) &&
	docker network create $(uuidgen) > ${HOME}/docker/networks/default &&
	docker volume create > ${HOME}/docker/volumes/homey &&
	docker \
		container \
		create \
		--cidfile ${HOME}/docker/containers/chromium \
		--privileged \
		--tty \
		--shm-size 256m \
		--env DISPLAY \
		--env TARGETUID=${HOST_UID} \
		--env XDG_RUNTIME_DIR=/run/user/${HOST_UID} \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		--volume /run/user/${HOST_UID}/pulse:/run/user/${HOST_UID}/pulse:ro \
		--volume /etc/machine-id:/etc/machine-id:ro \
		--volume /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket:ro \
		--volume /var/lib/dbus:/var/lib/dbus:ro \
		--volume /tmp:/tmp \
		--volume /home/aaja0ify:/home/chromium/.config/pulse:ro \
		--volume $(cat ${HOME}/docker/volumes/homey):/data \
		--volume /dev/video0:/dev/video:ro \
		urgemerge/chromium-pulseaudio &&
	docker network connect $(cat ${HOME}/docker/networks/default) $(cat ${HOME}/docker/containers/chromium) &&
	docker \
		container \
		create \
		--tty \
		--cidfile ${HOME}/docker/containers/sshd \
		endlessplanet/sshd &&
	docker network connect --alias sshd $(cat ${HOME}/docker/networks/default) $(cat ${HOME}/docker/containers/sshd) &&
	docker \
		container \
		create \
		--env GITLAB_HOST=http://gitlab \
		--env GITLAB_ROOT_PASSWORD=password \
		--env GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN=${GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN} \
		--cidfile ${HOME}/docker/containers/gitlab \
		gitlab/gitlab-ce:latest &&
	docker network connect --alias gitlab $(cat ${HOME}/docker/networks/default) $(cat ${HOME}/docker/containers/gitlab) &&
	docker \
		container \
		create \
		--volume /var/run/docker.sock:/var/run/docker.sock:ro \
		--cidfile ${HOME}/docker/containers/gitlab-runner \
		gitlab/gitlab-runner:latest	 &&
	docker network connect $(cat ${HOME}/docker/networks/default) $(cat ${HOME}/docker/containers/gitlab-runner) &&
	docker container start $(cat ${HOME}/docker/containers/chromium) &&
	docker container start $(cat ${HOME}/docker/containers/sshd) &&
	docker container start $(cat ${HOME}/docker/containers/gitlab) &&
	while [ "$(docker inspect --format {{.State.Health.Status}} $(cat ${HOME}/docker/containers/gitlab))" == "starting" ]
	do
		echo STARTING gitlab &&
			sleep 10s
	done &&
	docker container start $(cat ${HOME}/docker/containers/gitlab-runner) &&
	docker \
		container \
		exec \
		--interactive \
		--tty \
		$(cat ${HOME}/docker/containers/gitlab-runner) \
		gitlab-runner register \
			--non-interactive \
			--url http://gitlab/ci \
			--registration-token ${GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN} \
			--limit 1 \
			--name "default" \
			--executor docker \
			--docker-network-mode $(cat ${HOME}/docker/networks/default) \
			--docker-volumes /var/run/docker.sock:/var/run/docker.sock:ro \
			--docker-image docker:latest &&
	bash


