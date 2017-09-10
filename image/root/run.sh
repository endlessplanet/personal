#!/bin/sh

dnf update --assumeyes &&
    dnf install --assumeyes 
    adduser user &&
    dnf update --assumeyes &&
    dnf clean all