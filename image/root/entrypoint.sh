#!/bin/sh

export PATH=${HOME}/bin:${PATH} &&
    (cd dockerfiles && sh build-images.sh) &&
    bash