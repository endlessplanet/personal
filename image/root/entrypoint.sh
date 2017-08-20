#!/bin/sh

docker-compose build &&
bash
# docker-compose stop &&
# docker-compose rm -fv &&
# docker-compose up -d &&
# docker-compose exec --user root ssh sshd1 
# docker-compose exec experiment ssh -fN sshd1 &&
# sleep 10s &&
# docker-compose exec experiment ssh -fN sshd2