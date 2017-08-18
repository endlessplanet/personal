#!/bin/sh

apk update &&
apk upgrade &&
apk add --no-cache git &&
apk add --no-cache openssh &&
apk add --no-cache docker &&
rm -rf /var/cache/apk/*
