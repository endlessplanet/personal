#!/bin/sh

export PROJECT_NAME="personal" &&
    export ORIGIN="git@github.com:endlessplanet/personal.git" &&
    export UPSTREAM="git@github.com:endlessplanet/personal.git" &&
    export REPORT="git@github.com:endlessplanet/personal.git" &&
    sh /opt/docker/start-cloud9.sh