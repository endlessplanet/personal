#!/bin/sh

docker container run --interactive --tty fedora:26 dnf provides "*bin/${@}" &&
    