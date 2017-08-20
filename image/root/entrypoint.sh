#!/bin/sh

docker-compose build &&
    docker-compose stop &&
    docker-compose rm -fv &&
    docker-compose up -d chromium sshd pass experiment &&
    
    sleep 10s &&
    docker-compose ps &&
    docker-compose logs pass &&
    
    echo PASS 100 &&
    sleep 10s &&
    (nohup docker-compose exec -T --user root pass ssh -fN sshd1  </dev/null >/tmp/sshd1.log 2>&1 &) &&
    sleep 10s &&
    (nohup docker-compose exec -T --user root pass ssh -fN sshd2  </dev/null >/tmp/sshd2.log 2>&1 &) &&
    sleep 10s
    
    echo EXPERIMENT
    sleep 10s &&
    (nohup docker-compose exec -T --user root experiment ssh -fN sshd1  </dev/null >/tmp/sshd1.log 2>&1 &) &&
    sleep 10s &&
    (nohup docker-compose exec -T --user root experiment ssh -fN sshd2  </dev/null >/tmp/sshd2.log 2>&1 &) &&
    sleep 10s