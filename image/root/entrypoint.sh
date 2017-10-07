#!/bin/sh

export PATH=${HOME}/bin:${PATH} &&
    sh dockerfiles/build-images.sh &&
    bash