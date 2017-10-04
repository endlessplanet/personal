#!/bin/sh

apk update &&
    apk upgrade &&
    apk add --no-cache bash &&
    adduser -D user &&
    rm -rf /var/cache/apk/*