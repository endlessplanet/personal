#!/bin/sh

apk update &&
    apk upgrade &&
    apk add --no-cache docker &&
    adduser -D user &&
    cp /opt/docker/docker-compose.yml /home/user &&
    chown user:user /home/user/docker-compose.yml &&
    # ls -1 /opt/docker/bin | while read FILE
    # do
    #     cp /opt/docker/bin/${FILE} /usr/local/bin/${FILE%.*} &&
    #         chmod 0555 /usr/local/bin/${FILE%.*}
    # done &&
    rm -rf /var/cache/apk/*