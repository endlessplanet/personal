#!/bin/sh

docker image pull sassmann/debian-chromium:latest &&
    docker image pull gitlab/gitlab-ce:10.0.2-ce.0 &&
    docker image pull gitlab/gitlab-runner:v10.0.1 &&
    docker network create --driver overlay swarm-network &&
    sh