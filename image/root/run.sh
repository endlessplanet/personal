#!/bin/sh

apk update &&
	apk upgrade &&
	adduser -D user &&
	mkdir /home/user/bin &&
	ls -1 /opt/docker/bin | while read FILE
	do
		cp /opt/docker/bin/${FILE} /home/user/bin/${FILE%.*} &&
			chmod 0500 /home/user/bin/${FILE%.*}
	done &&
	chown -R user:user /home/user/bin &&
	mkdir /home/user/docker &&
	mkdir /home/user/docker/containers &&
	mkdir /home/user/docker/volumes &&
	mkdir /home/user/docker/networks &&
	chown -R user:user /home/user/docker &&
	apk add --no-cache sudo &&
	cp /opt/docker/user.sudo /etc/sudoers.d/user &&
	chmod 0444 /etc/sudoers.d/user &&
	apk add --no-cache util-linux bash &&
	rm -rf /var/cache/apk/*
