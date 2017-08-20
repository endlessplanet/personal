#!/bin/sh

if [ ! -f ~/secret1.key ]
then
    echo "${GPG_PRIVATE_KEY}" > ~/secret1.key &&
        echo "${GPG_OWNER_TRUST}" > ~/owner1.trust &&
        gpg --batch --import ~/secret1.key &&
        gpg --batch --import-ownertrust ~/owner1.trust &&
        pass init ${GPG_KEY_ID} &&
        pass git init &&
        pass git config user.name "${USER_NAME}" &&
        pass git config user.email "${EMAIL}" &&
        pass git remote add origin git@github.com:desertedscorpion/passwordstore.git &&
        mkdir ~/.ssh &&
        chmod 0700 ~/.ssh &&
        echo "${ID_RSA}" > ~/.ssh/id_rsa &&
        chmod 0600 ~/.ssh/id_rsa &&
        echo "${KNOWN_HOSTS}" > ~/.ssh/known_hosts &&
        chmod 0600 ~/.ssh/known_hosts &&
        pass git fetch origin master &&
        pass git rebase origin/master &&
        cp /opt/docker/post-commit.sh ~/.password-store/.git/hooks/post-commit &&
        chmod 0555 ~/.password-store/.git/hooks/post-commit &&
        mkdir /workspace/pass
fi &&
    forever ~/.c9/server.js -w /workspace/pass --listen 127.0.0.1
