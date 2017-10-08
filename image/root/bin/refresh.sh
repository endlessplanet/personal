#!/bin/sh

docker \
    run \
    --env AWS_ACCESS_KEY_ID \
    --env AWS_SECRET_ACCESS_KEY \
    --env AWS_DEFAULT_REGION \
    --interactive \
    --tty \
    --rm \
    --mount type=volume,source=gitlab-backup,destination=/var/backup \
    --workdir /var/backup/gitlab \
    xueshanf/awscli:latest \
        aws \
        s3 \
        cp \
        s3://${GITLAB_BACKUP_BUCKET} .