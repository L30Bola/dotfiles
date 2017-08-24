#!/usr/bin/env bash

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

if [ -n "$SSH_AUTH_SOCK" ] ; then
    eval "$(/usr/bin/ssh-agent -k)"
fi

if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval "$(ssh-agent -s)"
    ssh-add
fi


# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

