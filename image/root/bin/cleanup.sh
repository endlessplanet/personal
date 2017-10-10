#!/bin/sh

bash &&
    docker exec --interactive --tty gitlab-runner gitlab-runner unregister --name standard &&
    docker exec --interactive --tty gitlab gitlab-rake gitlab:backup:create