#!/bin/sh

# docker image pull sassmann/debian-chromium:latest &&
#     docker image pull gitlab/gitlab-ce:10.0.2-ce.0 &&
#     # docker image pull gitlab/gitlab-runner:v10.0.1 &&
#     docker network create --driver overlay --subnet 10.0.3.0/24 swarm-network &&
#     docker volume create homey &&
#     docker volume create workspace &&
#     # --device /dev/dri/card0 -v /run/user/$UID/pulse/native:/tmp/pulse -v /dev/shm:/home/user/Download \
#     docker \
#         service \
#         create \
#         --env DISPLAY \
#         --mount type=bind,source=/var/opt/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
#         --name chromium \
#         --hostname chromium \
#         docker.io/sassmann/debian-chromium:latest &&
#     docker \
#         service \
#         create \
#         --publish 443:443 \
#         --publish 80:80 \
#         --publish 22:22 \
#         --name gitlab \
#         --hostname gitlab \
#         gitlab/gitlab-ce:latest &&
#     docker service update gitlab --network-add swarm-network &&
#     docker service update chromium --network-add swarm-network &&
    sh