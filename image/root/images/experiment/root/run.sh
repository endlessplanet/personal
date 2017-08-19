#!/bin/sh

apk update &&
    apk upgrade &&
    apk add --no-cache openssh &&
    adduser -D user &&
    mkdir /workspace &&
    chown user:user /workspace &&
    cp -r /root/.c9 /home/user/.c9 &&
    chown --recursive user:user /home/user/.c9 &&
    mkdir /home/user/.ssh &&
    chmod 0700 /home/user/.ssh &&
    cp /opt/docker/config /home/user/.ssh/config &&
    chmod 0600 /home/user/.ssh/config &&
    chown --recursive user:user /home/user/.ssh &&
    rm -rf /var/cache/apk/*
