#!/bin/sh

export PATH=${HOME}/bin:${PATH} &&
    (cd dockerfiles && sh build-images.sh) &&
    docker image pull gitlab/gitlab-ce:latest &&
    bash