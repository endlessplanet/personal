#!/bin/sh

docker \
    run \
    container \
    create \
    --env DISPLAY \
    --volume /var/opt/.X11-unix:/tmp/.X11-unix:ro \
    --volume home:/home \
    silex/emacs