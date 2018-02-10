#!/usr/bin/env bash

set -e 

declare force=false
declare -a to_be_linked
files_to_be_linked=( "bash_profile" "bashrc" "gitconfig" "pythonrc" "tmux.conf" "vimrc" )
dirs_to_be_linked=( "tmux" )

function getScriptAbsolutePath() {
    (
    unset CDPATH
    scriptDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    echo "${scriptDir}"
    ) 
}

function makeSymLinkAtHomeDir() { 
    scriptDir=$(getScriptAbsolutePath)

    if [ "${force}" = true ]; then
        ln -fs "${scriptDir}"/"${1}" "${HOME}"/."${1}"
    else
        while [ -f "${HOME}"/."${1}" ]; do
            read -pr "${HOME}/.${1} already exists. Overwrite? (y/N)" substitute
            substitute=${substitute:-N}
            if [ "${substitute}" = "n" ] || [ "${substitute}" = "N" ]; then
                echo "${HOME}/.${1} was not overwritten."
                break
            elif [ "${substitute}" = "y" ] || [ "${substitute}" = "Y" ]; then
                ln -fs "${scriptDir}"/"${1}" "${HOME}"/."${1}"
                echo "${HOME}/.${1} overwritten."
                break
            else
                echo "'${substitute}' isn't a recognized option."
            fi
        done
    fi
}

for file in "${files_to_be_linked[@]}"; do
    if [ ! -f ./"${file}" ]; then
        echo "./${file} does not exist."
        exit 1
    fi
done

for dir in "${dirs_to_be_linked[@]}"; do
    if [ ! -d ./"${dir}" ]; then
        echo "./${dir} does not exist."
        exit 1
    fi
done

echo "Files to be linked:"
for ((i=0; i < "${#files_to_be_linked[@]}"; i++)); do
    echo "[${i}]: ${files_to_be_linked[${i}]}"
done

echo "Directories to be linked:"
for ((j=0; j < "${#dirs_to_be_linked[@]}"; j++)); do
    echo "[${j}]: ${dirs_to_be_linked[${j}]}"
done


echo "Which option would you like to create a link in your home directory?"
#read -pr "Or would you like to create a like to a like to all options?" option

#ln -s ~/.vim/vimrc ~/.vimrc
#ln -s ~/.vim/bashrc ~/.bashrc
#ln -s ~/.vim/tmux.conf ~/.tmux.conf
#ln -s ~/.vim/tmux ~/.tmux
#ln -s ~/.vim/bash_profile ~/.bash_profile
#ln -s ~/.vim/gitconfig ~/.gitconfig
#pushd ~/.vim
#git submodule init
#git submodule update --recursive
#popd
