#!/bin/sh

apk update &&
apk upgrade &&
apk add --no-cache git &&
apk add --no-cache openssh &&
rm -rf /var/cache/apk/*
