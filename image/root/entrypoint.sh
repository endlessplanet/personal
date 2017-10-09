#!/bin/sh

export PATH=${HOME}/bin:${PATH} &&
    trap cleanup EXIT &&
    docker network create system &&
    docker volume create gitlab-config &&
    docker volume create gitlab-backup &&
    docker \
        container \
        run \
        --interactive \
        --rm \
        --mount type=volume,source=gitlab-config,destination=/etc/gitlab \
        --workdir /etc/gitlab \
        alpine:3.4 \
            mkdir \
            ssl &&
    cat \
        /opt/docker/openssl.txt | docker \
        container \
        run \
        --interactive \
        --rm \
        --mount type=volume,source=gitlab-config,destination=/etc/gitlab \
        --workdir /etc/gitlab/ssl \
        jordi/openssl \
            openssl \
            req -x509 \
            -newkey rsa:4096 \
            -keyout gitlab.key \
            -out gitlab.crt \
            -days 365 \
            -nodes &&
    sed \
        -e "s#d8b207ab-5e71-4b6e-bd6a-aa14dec16443#${AWS_DEFAULT_REGION}#g" \
        -e "s#0b37a2a1-00cb-4145-a3a2-bb1490fb5c4e#${AWS_ACCESS_KEY_ID}#g" \
        -e "s#3901d14f-6aee-4d23-8894-36ec77749b57#${AWS_SECRET_ACCESS_KEY}#g" \
        -e "s#640023b9-70b9-4a07-8a6d-481e0d275d8b#${GITLAB_BACKUP_BUCKET}#g" \
        /opt/docker/gitlab.rb | docker \
        container \
        run \
        --interactive \
        --rm \
        --mount type=volume,source=gitlab-config,destination=/etc/gitlab \
        --workdir /etc/gitlab \
        alpine:3.4 \
            tee \
            gitlab.rb &&
    docker \
        container \
        run \
        --interactive \
        --tty \
        --rm \
        --mount type=volume,source=gitlab-backup,destination=/var/backups \
        --workdir /var/backups \
        alpine:3.4 \
            mkdir gitlab &&
    docker \
        container \
        run \
        --interactive \
        --tty \
        --rm \
        --mount type=volume,source=gitlab-backup,destination=/var/backups \
        --workdir /var/backups \
        alpine:3.4 \
            chmod 0777 gitlab &&
    docker \
        container \
        run \
        --env AWS_ACCESS_KEY_ID \
        --env AWS_SECRET_ACCESS_KEY \
        --env AWS_DEFAULT_REGION \
        --interactive \
        --tty \
        --rm \
        --mount type=volume,source=gitlab-backup,destination=/var/backups \
        --workdir /var/backups/gitlab \
        xueshanf/awscli:latest \
            aws \
            s3 \
            cp \
            --include '*gitlab_backup.tar' \
            --recursive \
            s3://${GITLAB_BACKUP_BUCKET} .
    docker \
        container \
        create \
        --name gitlab \
        --restart always \
        --mount type=volume,source=gitlab-config,destination=/etc/gitlab \
        --mount type=volume,source=gitlab-backup,destination=/var/backups \
        --env GITLAB_ROOT_PASSWORD=$(uuidgen) \
        --env GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN=$(uuidgen) \
        gitlab/gitlab-ce:latest &&
    docker network connect --alias gitlab system gitlab &&
    docker container start gitlab &&
    docker \
        container \
        run \
        --detach \
        --name gitlab-runner \
        --restart always \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        gitlab/gitlab-runner:v10.0.2 &&
    docker \
        container \
        run \
        --detach \
        --restart always \
        --mount type=bind,source=/srv/root/tmp/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
        --mount type=volume,source=gitlab-config,destination=/etc/gitlab,readonly=true \
        --env DISPLAY \
        --network system \
        sassmann/debian-chromium &&
    while [ $(docker inspect --format "{{ .State.Health.Status }}" gitlab) != "healthy" ]
    do
        echo starting gitlab &&
            sleep 10s
    done &&
    docker container exec --interactive --tty gitlab gitlab-ctl reconfigure &&
    docker container exec --interactive --tty gitlab gitlab-ctl stop unicorn &&
    docker container exec --interactive --tty gitlab gitlab-ctl stop sidekiq &&
    export BACKUP=$(docker \
        container \
        run \
        --interactive \
        --rm \
        --tty \
        --mount type=volume,source=gitlab-backup,destination=/var/backups \
        --workdir /var/backups/gitlab \
        alpine:3.4 \
            ls -1 | sort | tail -n 1 | head -n 1 | sed -e "s#^[^0-9]*##" -e "s#_gitlab.backup.tar.*\$##" -e "s#^.*m##") &&
    (cat <<EOF
yes
yes

EOF
    ) | docker \
        container \
        exec \
        --interactive \
        gitlab \
        gitlab-rake \
        gitlab:backup:restore \
        BACKUP=${BACKUP} &&
    docker container exec --interactive --tty gitlab gitlab-ctl start &&
    while [ $(docker inspect --format "{{ .State.Health.Status }}" gitlab) != "healthy" ]
    do
        echo restarting gitlab &&
            sleep 10s
    done &&
    docker \
        container \
        exec \
        --interactive \
        --tty \
        gitlab-runner \
            gitlab-runner \
            register \
            --non-interactive \
            --registration-token ${GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN} \
            --run-untagged true \
            --name "standard" \
            --limit 1 \
            --executor docker \
            --docker-image docker \
            --docker-volumes /var/run/docker.sock:/var/run/docker.sock:ro &&
    bash