#!/bin/sh

docker-compose build &&
docker-compose stop &&
docker-compose rm -fv &&
docker-compose up -d &&
docker-compose logs -f pass