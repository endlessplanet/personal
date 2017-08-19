#!/bin/sh

echo "${ID_RSA_PUB}" > ~/.ssh/authorized_keys &&
    chmod 0600 ~/.ssh/authorized_keys &&
    ./entry.sh "${@}"