#!/usr/bin/env bash

if [ -n "$SSH_AUTH_SOCK" ] ; then
    eval $(ssh-agent -k)
fi

if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval $(ssh-agent -s)
    ssh-add
fi

source ~/.bashrc
