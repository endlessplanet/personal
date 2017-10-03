#!/bin/sh

cleanup(){
    docker container stop emacs &&
        docker container rm --volumes emacs
}
    docker \
        container \
        create \
        --name emacs \
        --env DISPLAY \
        --volume /var/opt/.X11-unix:/tmp/.X11-unix:ro \
        --volume home:/home \
        silex/emacs &&
    docker container start emacs