#!/bin/sh

dnf update --assumeyes &&
    dnf install --assumeyes java-1.8.0-openjdk-devel ant &&
    adduser user &&
    dnf update --assumeyes &&
    dnf clean all