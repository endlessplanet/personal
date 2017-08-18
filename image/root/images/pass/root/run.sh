#!/bin/sh

apk update &&
    apk upgrade &&
    apk add --no-cache git &&
    apk add --no-cache openssh &&
    apk add --no-cache findutils &&
    apk add --no-cache tree &&
    apk add --no-cache make &&
    apk add --no-cache bash &&
    apk add --no-cache gpgme &&
    mkdir /opt/password-store &&
    cd /opt/password-store &&
    git clone https://git.zx2c4.com/password-store &&
    cd password-store &&
    make && 
    make install &&
    adduser -D user &&
    mkdir /workspace &&
    chown user:user /workspace &&
    cp -r /root/.c9 /home/user/.c9 &&
    chown --recursive user:user /home/user/.c9 &&
    mkdir /home/user/.ssh &&
    chmod 0700 /home/user/.ssh &&
    cp /opt/docker/id_rsa /home/user/.ssh &&
    chmod 0600 /home/user/.ssh/id_rsa &&
    chown --recursive user:user /home/user/.ssh &&
    rm -rf /var/cache/apk/*
