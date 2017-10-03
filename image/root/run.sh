#!/bin/sh

apk update &&
    apk upgrade &&
    apk add --no-cache docker &&
    adduser -D user &&
    ls -1 /opt/docker/bin | while read FILE
    do
        cp /opt/docker/${FILE} /usr/local/bin/${FILE%.*} &&
            chmod 0555 /usr/local/bin/${FILE%.*}
    done &&
    rm -rf /var/cache/apk/*