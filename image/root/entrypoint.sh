#!/bin/sh

docker-compose stop &&
docker-compose rm -fv &&
docker-compose build &&
docker-compose up -d &&
sleep 10s &&
docker-compose restart pass