#!/bin/sh

docker exec --interactive --tty gitlab gitlab-rake gitlab:backup:create