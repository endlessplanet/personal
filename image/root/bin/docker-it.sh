#!/bin/sh

WORK=$(mktemp -d) &&
    (cat > ${WORK}/Dockerfile <<EOF
FROM alpine:3.4
RUN \
    apk update && \
    apk upgrade && \
    apk add --no-cache "${2}" && \
    adduser -D user && \
    rm -rf /var/cache/apk/*
ENTRYPOINT [ \
EOF
    ) &&
    true