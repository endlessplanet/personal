#!/bin/sh

docker build --tag endlessplanet/personal:$(git rev-parse --verify HEAD) image