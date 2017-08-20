#!/bin/sh

if [ ! -d ~/workspace/${PROJECT_NAME} ]
then
    mkdir /workspace/${PROJECT_NAME}
fi &&
    forever ~/.c9/server.js -w /workspace/${PROJECT_NAME} --listen 127.0.0.1
