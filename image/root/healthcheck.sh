#!/bin/sh

if [ $(docker inspect --format "{{ .State.Health.Status }}" gitlab) == "healthy" ]
then
    exit 0
else
    exit 1
fi