#!/bin/sh

FILE="${1}" &&
    shift &&
    echo ${@} > "${FILE}"