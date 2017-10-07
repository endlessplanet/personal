#!/bin/sh

apk update &&
    apk upgrade &&
    apk add --no-cache bash util-linux libxslt &&
    adduser -D user &&
    mkdir /home/user/bin /home/user/dockerfiles &&
    ls -1 /opt/docker/bin | while read FILE
    do
        cp /opt/docker/bin/${FILE} /home/user/bin/${FILE%.*} &&
            chmod 0500 /home/user/bin/${FILE%.*}
    done &&
    xsltproc /opt/docker/style/alpine.xslt.xml /opt/docker/data.xml > /tmp/alpine.xml &&
    xsltproc /opt/docker/style/docker.xslt.xml /tmp/alpine.xml &&
    chown -R user:user /home/user/bin /home/user/dockerfiles &&
    rm -rf /var/cache/apk/*