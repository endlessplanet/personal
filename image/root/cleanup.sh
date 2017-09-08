#!/bin/sh

ls -1 ${HOME}/docker/containers | while read FILE
do
	docker container stop $(cat ${HOME}/docker/containers/${FILE}) &&
		docker container rm --force --volumes $(cat ${HOME}/docker/containers/${FILE}) &&
		rm -f ${HOME}/docker/containers/${FILE}
done &&
	removeit(){
		ls -1 ${HOME}/docker/${1} | while read FILE
		do
			docker ${1} rm $(cat ${HOME}/docker/${1}/${FILE}) &&
				rm -f ${HOME}/docker/${1}/${FILE}
		done
	} &&
	removeit volumes &&
	removeit networks
