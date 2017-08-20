#!/bin/sh

docker-compose build &&
docker-compose stop &&
docker-compose rm -fv &&
docker-compose up -d chromium sshd experiment &&
docker-compose exec --user root experiment ssh -fN sshd1 &&
sleep 10s &&
docker-compose exec --user root experiment ssh -fN sshd2