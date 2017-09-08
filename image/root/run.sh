#!/bin/sh

apk update &&
	apk upgrade &&
	adduser -D user &&
	echo PATH=/home/user/bin:\${PATH} > /home/user/.profile &&
	chown user:user /home/user/.profile &&
	mkdir /home/user/bin &&
	cp /opt/docker/docker.sh /home/user/bin/docker &&
	chmod 0500 /home/user/bin/docker &&
	cp /opt/docker/cleanup.sh /home/user/bin/cleanup &&
	chmod 0500 /home/user/bin/cleanup &&
	chown -R user:user /home/user/bin &&
	mkdir /home/user/docker &&
	mkdir /home/user/docker/containers &&
	mkdir /home/user/docker/volumes &&
	mkdir /home/user/docker/networks &&
	chown -R user:user /home/user/docker &&
	apk add --no-cache sudo &&
	cp /opt/docker/user.sudo /etc/sudoers.d/user &&
	chmod 0444 /etc/sudoers.d/user &&
	rm -rf /var/cache/apk/*
