#!/bin/sh

apk update &&
    apk upgrade &&
    apk add --no-cache docker &&
    rm -rf /var/cache/apk/*