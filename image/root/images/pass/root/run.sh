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
    adduser user &&
    rm -rf /var/cache/apk/*
