#!/bin/sh

mkdir ~/.ssh &&
    chmod 0700 ~/.ssh &&
    echo "${ID_RSA}" > ~/.ssh/id_rsa &&
    chmod 0600 ~/.ssh/id_rsa &&
    echo "${KNOWN_HOSTS}" > ~/.ssh/known_hosts &&
    chmod 0600 ~/.ssh/known_hosts &&
    mkdir /workspace &&
    mkdir /workspace/${GROUP_NAME} &&
    mkdir /workspace/${GROUP_NAME}/${PROJECT_NAME} &&
    cd /workspace/${GROUP_NAME}/${PROJECT_NAME} &&
    git init &&
    git config user.name "${USERNAME}" &&
    git config user.email "${EMAIL}" &&
    cp /opt/docker/post-commit.sh .git/hooks/post-commit &&
    chmod 0500 .git/hooks/post-commit &&
    git remote add origin git@github.com:${GROUP_NAME}/${PROJECT_NAME}.git &&
    git fetch origin ${BRANCH} &&
    git checkout origin/${BRANCH} &&
    forever /root/.c9/server.js -w /workspace/${PROJECT_NAME} --auth "user:password" --listen 0.0.0.0
