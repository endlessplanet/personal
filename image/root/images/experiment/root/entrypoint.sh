#!/bin/sh

if [ ! -d ~/workspace/${PROJECT_NAME} ]
then
    mkdir /workspace/${PROJECT_NAME}
fi &&
    forever ~/.c9/server.js -w /workspace/${PROJECT_NAME} --auth "user:password" --listen 0.0.0.0
