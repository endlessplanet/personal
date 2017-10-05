#!/bin/sh

apk update &&
    apk upgrade &&
    apk add --no-cache bash openssl &&
    adduser -D user &&
    rm -rf /var/cache/apk/*