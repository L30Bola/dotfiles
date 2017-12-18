#!/usr/bin/env bash

set -e 

ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vim/bashrc ~/.bashrc
ln -s ~/.vim/tmux.conf ~/.tmux.conf
ln -s ~/.vim/tmux ~/.tmux
ln -s ~/.vim/bash_profile ~/.bash_profile
ln -s ~/.vim/gitconfig ~/.gitconfig
pushd ~/.vim
git submodule init
git submodule update --recursive
popd
