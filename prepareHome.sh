#!/usr/bin/env bash

set -e 

declare force
force=false

declare -a files_to_be_linked dirs_to_be_linked
files_to_be_linked=( "bash_profile" "bashrc" "gitconfig" "pythonrc" "tmux.conf" "vimrc" "mailrc" )
dirs_to_be_linked=( "tmux" )

declare -i i j k 

function getScriptAbsolutePath() {
    (
    unset CDPATH
    scriptDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    printf "${scriptDir}\n"
    ) 
}

scriptDir=$(getScriptAbsolutePath)

function makeSymLinkAtHomeDir() { 
    if [ "${force}" = true ]; then
        ln -fs "${scriptDir}"/"${1}" "${HOME}"/."${1}"
        printf "Link from ${scriptDir}/${1} created at ${HOME}/.${1}\n"
    else
        if [ -f "${HOME}"/."${1}" ]; then
            printf "${HOME}/.${1} already exists. Overwrite? (y/N)\n" 
            read -r substitute
            substitute=${substitute:-N}
            if [ "${substitute}" = "n" ] || [ "${substitute}" = "N" ]; then
                printf "${HOME}/.${1} was not overwritten.\n"
            elif [ "${substitute}" = "y" ] || [ "${substitute}" = "Y" ]; then
                ln -fs "${scriptDir}"/"${1}" "${HOME}"/."${1}"
                printf "${HOME}/.${1} overwritten."
            else
                printf "'${substitute}' isn't a recognized option."
            fi
        else
            force=true
            makeSymLinkAtHomeDir "${1}"
            force=false
        fi
    fi
}

for file in "${files_to_be_linked[@]}"; do
    if [ ! -f ./"${file}" ]; then
        printf "File ${scriptDir}/${file} does not exist."
        exit 1
    fi
done

for dir in "${dirs_to_be_linked[@]}"; do
    if [ ! -d ./"${dir}" ]; then
        printf "Directory ${scriptDir}/${dir} does not exist."
        exit 1
    fi
done

printf "Files to be linked:"
for ((i=0; i < "${#files_to_be_linked[@]}"; i++)); do
    printf "[${i}]: ${files_to_be_linked[${i}]}"
done

printf "Directories to be linked:"
for ((j=0; j < "${#dirs_to_be_linked[@]}"; j++)); do
    let k=i+j
    printf "[${k}]: ${dirs_to_be_linked[${j}]}"
done

let k=i+j
printf
printf "[${k}]: All options above"
printf

printf "Which option would you like to create a link in your home directory?"
printf "Or would you like to create a like to a like to all options?"

while IFS= read -r option; do
    if [ "${option}" -eq "${k}" ]; then
        force=true
        for ((i=0; i < "${#files_to_be_linked[@]}"; i++)); do
            makeSymLinkAtHomeDir "${files_to_be_linked[${i}]}"
        done
        for ((j=0; j < "${#dirs_to_be_linked[@]}"; j++)); do
            makeSymLinkAtHomeDir "${dirs_to_be_linked[${j}]}"
        done
        break
    else
        if [ "${option}" -gt ${k} ]; then
            printf "${option} is not a valid choice."
            break
        fi
    fi
done

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
