#!/bin/sh

docker-compose build &&
    docker-compose stop &&
    docker-compose rm -fv &&
    docker-compose up -d chromium sshd pass experiment &&
    
    echo PASS &&
    echo "${GPG_PRIVATE_KEY}" docker-compose exec -T tee ~/secret1.key &&
    echo "${GPG_OWNER_TRUST}" docker-compose exec -T tee ~/owner1.trust &&
    docker-compose exec -T gpg --batch --import ~/secret1.key &&
    docker-compose exec -T gpg --batch --import-ownertrust ~/owner1.trust &&
    docker-compose exec pass init ${GPG_KEY_ID} &&
    docker-compose exec -T pass git init &&
    docker-compose exec -T pass git config user.name "${USER_NAME}" &&
    docker-compose exec -T pass git config user.email "${EMAIL}" &&
    docker-compose exec -T pass git remote add origin git@github.com:desertedscorpion/passwordstore.git &&
    docker-compose exec -T mkdir ~/.ssh &&
    docker-compose exec -T chmod 0700 ~/.ssh &&
    echo "${ID_RSA}" docker-compose exec -T | tee ~/.ssh/id_rsa &&
    docker-compose exec -T chmod 0600 ~/.ssh/id_rsa &&
    echo "${KNOWN_HOSTS}" | docker-compose exec -T  ~/.ssh/known_hosts &&
    docker-compose exec -T chmod 0600 ~/.ssh/known_hosts &&
    docker-compose exec -T pass git fetch origin master &&
    docker-compose exec -T pass git rebase origin/master &&
    docker-compose exec -T cp /opt/docker/post-commit.sh ~/.password-store/.git/hooks/post-commit &&
    docker-compose exec -T chmod 0555 ~/.password-store/.git/hooks/post-commit &&
    docker-compose exec -T mkdir /workspace/pass
    sleep 10s &&
    (nohup docker-compose exec -T --user root experiment ssh -fN sshd1  </dev/null >/tmp/sshd1.log 2>&1 &) &&
    sleep 10s &&
    (nohup docker-compose exec -T --user root experiment ssh -fN sshd2  </dev/null >/tmp/sshd2.log 2>&1 &) &&
    sleep 10s
    
    echo EXPERIMENT
    # sleep 10s &&
    # (nohup docker-compose exec -T --user root experiment ssh -fN sshd1  </dev/null >/tmp/sshd1.log 2>&1 &) &&
    # sleep 10s &&
    # (nohup docker-compose exec -T --user root experiment ssh -fN sshd2  </dev/null >/tmp/sshd2.log 2>&1 &) &&
    # sleep 10s