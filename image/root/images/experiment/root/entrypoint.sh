#!/bin/sh

if [ ! -f ~/.ssh/id_rsa ]
then
    echo "${ID_RSA}" > ~/.ssh/id_rsa &&
    chmod 0600 ~/.ssh/id_rsa
fi &&
    if [ ! -d ~/workspace/${PROJECT_NAME} ]
    then
        mkdir /workspace/${PROJECT_NAME}
    fi &&
    forever ~/.c9/server.js -w /workspace/${PROJECT_NAME} --auth "user:password" --listen 0.0.0.0
