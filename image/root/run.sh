#!/bin/sh

apk update &&
    apk upgrade &&
    apk add --no-cache bash util-linux &&
    adduser -D user &&
    mkdir /home/user/bin &&
    ls -1 /opt/docker/bin | while read FILE
    do
        cp /opt/docker/bin/${FILE} /home/user/bin/${FILE%.*} &&
            chmod 0500 /home/user/bin/${FILE%.*}
    done &&
    chown -R user:user /home/user/bin &&
    rm -rf /var/cache/apk/*