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