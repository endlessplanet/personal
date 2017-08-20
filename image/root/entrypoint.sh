#!/bin/sh

docker-compose build &&
    docker-compose stop &&
    docker-compose rm -fv &&
    docker-compose up -d chromium sshd pass experiment &&
    
    sleep 10s &&
    docker-compose ps &&
    docker-compose logs pass &&
    
    echo PASS 100 &&
    docker-compose exec -T pass sh /opt/docker/write_it.sh /home/user/secret1.key "${GPG_SECRET_KEY}" &&
    echo PASS 200 &&
    docker-compose exec -T --user root pass apk update &&
    echo PASS 300 &&
    docker-compose exec -T --user root pass apk upgrade &&
    echo PASS 400 &&
    docker-compose exec -T --user root pass apk add --no-cache git openssh findutils tree make bash gpgme &&
    echo PASS 500 &&
    docker-compose exec -T pass sh /opt/docker/write_it.sh /home/user/owner1.trust "${GPG_OWNER_TRUST}" &&
    echo PASS 600 &&
    (docker-compose exec -T pass gpg --batch --import /home/user/secret1.key | true) &&
    echo PASS 700 &&
    docker-compose exec -T pass gpg --batch --import-ownertrust /home/user/owner1.trust &&
    echo PASS 800 &&
    docker-compose exec -T pass init ${GPG_KEY_ID} &&
    echo PASS 900 &&
    docker-compose exec -T pass git init &&
    echo PASS 1000 &&
    docker-compose exec -T pass git config user.name "${USER_NAME}" &&
    echo PASS 1100 &&
    docker-compose exec -T pass git config user.email "${EMAIL}" &&
    echo PASS 1200 &&
    docker-compose exec -T pass git remote add origin git@github.com:desertedscorpion/passwordstore.git &&
    echo PASS 1300 &&
    docker-compose exec -T pass mkdir /home/user/.ssh &&
    echo PASS 5200 &&
    docker-compose exec -T pass chmod 0700 /home/user/.ssh &&
    docker-compose exec -T pass sh /opt/docker/write_it.sh /home/user/.ssh/id_rsa "${ID_RSA}" &&
    docker-compose exec -T pass chmod 0600 /home/user/.ssh/id_rsa &&
    docker-compose exec -T pass sh /opt/docker/write_it.sh /home/user/.ssh/known_hosts "${KNOWN_HOSTS}" &&
    docker-compose exec -T pass chmod 0600 /home/user/.ssh/known_hosts &&
    docker-compose exec -T pass git fetch origin master &&
    docker-compose exec -T pass git rebase origin/master &&
    docker-compose exec -T pass cp /opt/docker/post-commit.sh /home/user/.password-store/.git/hooks/post-commit &&
    docker-compose exec -T pass chmod 0555 /home/user/.password-store/.git/hooks/post-commit &&
    sleep 10s &&
    (nohup docker-compose exec -T --user root pass ssh -fN sshd1  </dev/null >/tmp/sshd1.log 2>&1 &) &&
    sleep 10s &&
    (nohup docker-compose exec -T --user root pass ssh -fN sshd2  </dev/null >/tmp/sshd2.log 2>&1 &) &&
    sleep 10s &&
    
    echo EXPERIMENT
    # sleep 10s &&
    # (nohup docker-compose exec -T --user root experiment ssh -fN sshd1  </dev/null >/tmp/sshd1.log 2>&1 &) &&
    # sleep 10s &&
    # (nohup docker-compose exec -T --user root experiment ssh -fN sshd2  </dev/null >/tmp/sshd2.log 2>&1 &) &&
    # sleep 10s