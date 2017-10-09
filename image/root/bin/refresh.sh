#!/bin/sh

docker \
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
        s3://${GITLAB_BACKUP_BUCKET} /var/backups/gitlab/
        
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
            ls -1 | sort | tail -n 1 | while read TSTAMP
            do
                echo docker \
                    container \
                    exec \
                    --interactive \
                    gitlab \
                    gitlab-rake \
                    gitlab:backup:restore \
                    BACKUP=${TSTAMP%.*} &&
                docker \
                    container \
                    exec \
                    --interactive \
                    gitlab \
                    gitlab-rake \
                    gitlab:backup:restore \
                    BACKUP=${TSTAMP%.*}
            done &&
        docker container exec --interactive --tty gitlab gitlab-ctl start