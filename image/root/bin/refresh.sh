#!/bin/sh

docker container exec --interactive --tty gitlab gitlab-ctl reconfigure &&
    docker container exec --interactive --tty gitlab gitlab-ctl stop unicorn &&
    docker container exec --interactive --tty gitlab gitlab-ctl stop sidekiq &&
    docker \
        container \
        run \
        --interactive \
        --rm \
        --tty \
        --mount type=volume,source=gitlab-backup,destination=/var/backups \
        --workdir /var/backups/gitlab \
        alpine:3.4 \
            ls -1 | sort | tail -n 1 | while read BACKUP2
            do
                echo ${BACKUP2} &&
                    echo ${BACKUP1} &&
                    BACKUP1=${BACKUP2%_*} &&
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
                        BACKUP=${BACKUP1%_*}
            done &&
        docker container exec --interactive --tty gitlab gitlab-ctl start