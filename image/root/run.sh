#!/bin/sh

apk update &&
    apk upgrade &&
    apk add --no-cache docker &&
    adduser -D user &&
    cp /opt/docker/docker.sh /usr/local/bin/docker &&
    chmod 0555 /usr/local/bin/docker &&
    rm -rf /var/cache/apk/*