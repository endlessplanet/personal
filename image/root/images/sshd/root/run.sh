#!/bin/sh

sed -i "s,#GatewayPorts no,GatewayPorts yes," /etc/ssh/sshd_config
