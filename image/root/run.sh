#!/bin/sh

apk update &&
    apk upgrade &&
    apk add --no-cache bash openssl &&
    adduser -D user &&
    mkdir /home/user/data &&
    chown -R user:user /home/user/data &&
    rm -rf /var/cache/apk/*