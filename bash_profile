#!/usr/bin/env bash

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

#if [ -n "$SSH_AUTH_SOCK" ] ; then
#    eval "$(ssh-agent -k)"
#fi
#
#if [ -z "$SSH_AUTH_SOCK" ] ; then
#    eval "$(ssh-agent -s)"
#    ssh-add
#fi

# User specific environment and startup programs

#if xinput | grep --quiet --color=never "Multi-Touch"; then
#    xinput disable "$(xinput | grep --color=never "Multi-Touch" | cut -c 51-52)"
#fi

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

