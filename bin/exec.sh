#!/bin/sh

docker container create --volume /var/run/docker.sock:/var/run/docker.sock:ro endlessplanet/personal 
