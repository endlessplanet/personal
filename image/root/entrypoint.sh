#!/bin/sh

docker-compose stop &&
docker-compose rm -fv &&
docker-compose build &&
docker-compose up -d