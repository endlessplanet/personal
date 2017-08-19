#!/bin/sh

sed -i "s,#GatewayPorts no,GatewayPorts yes," /etc/ssh/sshd_config &&
    cat /opt/docker/authorized_keys /root/.ssh/authorized_keys &&
    chmod 0600 /root/.ssh/authorized_keys