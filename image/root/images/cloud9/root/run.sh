#!/bin/sh

apk update &&
    apk upgrade &&
    apk add --no-cache git &&
    apk add --no-cache openssh &&
    apk add --no-cache docker &&
    adduser -D user &&
    mkdir /workspace &&
    chown user:user /workspace &&
    cp -r /root/.c9 /home/user/.c9 &&
    chown --recursive user:user /home/user/.c9 &&
    mkdir /root/.ssh &&
    chmod 0700 /root/.ssh &&
    cp /opt/docker/id_rsa /root/.ssh/id_rsa &&
    chmod 0600 /root/.ssh/id_rsa &&
    cp /opt/docker/config /root/.ssh/config &&
    chmod 0600 /root/.ssh/config &&
    rm -rf /var/cache/apk/*
