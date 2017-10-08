#!/bin/sh

docker exec --interactive --tty gitlab gitlab-rake gitlab:backup:create &&
    for BACKUP in $(docker exec --interactive --tty gitlab ls /var/opt/gitlab/backups)
    do
        docker \
            run \
            --env AWS_ACCESS_KEY_ID \
            --env AWS_SECRET_ACCESS_KEY \
            --env AWS_DEFAULT_REGION \
            --interactive \
            --tty \
            --rm \
            --mount type=volume,source=gitlab-data,destination=/opt/gitlab \
            xueshanf/awscli:latest \
                aws \
                s3 \
                cp \
                /opt/gitlab/backups/${BACKUP} \
                s3://${GITLAB_BACKUP_BUCKET}/${BACKUP}
    done