#!/usr/bin/env bash

# Number of lines or commands to be added to history file
export HISTSIZE=-1

# Number of lines or commands that are allowed to be stored on history file
export HISTFILESIZE=-1

# Date and time added to history before each command is written on the history file
# It's formatted as: year/month/day - hour:minute:second
export HISTTIMEFORMAT="%Y/%m/%d - %T: "

# avoid duplicates..
# Comandos iguais não são adicionados e adicionados ao histórico
HISTCONTROL="ignoreboth"
export HISTCONTROL

HISTIGNORE="&,'[ ]*',history:hstr:bashHist"
export HISTIGNORE

if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

if [ -f ~/.asdf/plugins/java/set-java-home.bash ]; then
  source ~/.asdf/plugins/java/set-java-home.bash
fi

#if [ -n "$SSH_AUTH_SOCK" ] ; then
#    eval "$(ssh-agent -k)"
#fi
#
#if [ -z "$SSH_AUTH_SOCK" ] ; then
#    eval "$(ssh-agent -s)"
#    ssh-add
#fi
