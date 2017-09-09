#!/bin/sh

ls -1 ${HOME}/docker/containers | while read FILE
do
	docker container stop $(cat ${HOME}/docker/containers/${FILE}) &&
		docker container rm $(cat ${HOME}/docker/containers/${FILE}) &&
		rm -f ${HOME}/docker/containers/${FILE}
done &&
	removeit(){
		ls -1 ${HOME}/docker/${1}s | while read FILE
		do
			docker ${1} rm $(cat ${HOME}/docker/${1}s/${FILE}) &&
				rm -f ${HOME}/docker/${1}s/${FILE}
		done
	} &&
	removeit volume &&
	removeit network
