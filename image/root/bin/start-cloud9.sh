#!/bin/sh

export PROJECT_NAME="cloud9" &&
    export ORIGIN="git@github.com:endlessplanet/cloud9.git" &&
    export UPSTREAM="git@github.com:endlessplanet/cloud9.git" &&
    export REPORT="git@github.com:endlessplanet/cloud9.git" &&
    sh /opt/docker/start-cloud9.sh