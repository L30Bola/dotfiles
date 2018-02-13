#!/usr/bin/env bash

set -e 

declare force absoluteScriptDir
force=false

declare -a files_to_be_linked dirs_to_be_linked
files_to_be_linked=( "bash_profile" "bashrc" "gitconfig" "pythonrc" "tmux.conf" "vimrc" "mailrc" )
dirs_to_be_linked=( "tmux" "bundle" )

declare -i i j k 

function getScriptAbsoluteDir() {
    (
    unset CDPATH
    absoluteScriptDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    printf "%s\n" "${absoluteScriptDir}"
    ) 
}

absoluteScriptDir=$(getScriptAbsoluteDir)

function makeSymLinkAtHomeDir() { 
    if [ "${force}" = true ]; then
        ln -fs "${absoluteScriptDir}"/"${1}" "${HOME}"/."${1}"
        printf "Link from %s/%s created at %s/.%s\n" "${absoluteScriptDir}" "${1}" "${HOME}" "${1}"
    else
        if [ -f "${HOME}"/."${1}" ]; then
            printf "File %s/.%s already exists. Overwrite? (y/N)\n" "${HOME}" "${1}" 
            read -r substitute
            substitute=${substitute:-N}
            if [ "${substitute}" = "n" ] || [ "${substitute}" = "N" ]; then
                printf "%s/.%s was not overwritten.\n" "${HOME}" "${1}"
            elif [ "${substitute}" = "y" ] || [ "${substitute}" = "Y" ]; then
                ln -fs "${absoluteScriptDir}"/"${1}" "${HOME}"/."${1}"
                printf "%s/.%s overwritten.\n" "${HOME}" "${1}"
            else
                printf "'%s' isn't a recognized option.\n" "${substitute}"
            fi
        elif [ -d "${HOME}"/."${1}" ]; then
            printf "Directory %s/.%s already exists. Rename? (y/N)\n" "${HOME}" "${1}" 
            read -r substitute
            substitute=${substitute:-N}
            if [ "${substitute}" = "n" ] || [ "${substitute}" = "N" ]; then
                printf "%s/.%s was not renamed.\n" "${HOME}" "${1}"
            elif [ "${substitute}" = "y" ] || [ "${substitute}" = "Y" ]; then
                mv "${HOME}"/."${1}" "${HOME}"/."${1}".old
                printf "%s/.%s renamed to %s/.%s.old\n" "${HOME}" "${1}" "${HOME}" "${1}"
                ln -fs "${absoluteScriptDir}"/"${1}" "${HOME}"/."${1}"
                printf "Link from %s/%s created at %s/.%s\n" "${absoluteScriptDir}" "${1}" "${HOME}" "${1}"
            else
                printf "'%s' isn't a recognized option.\n" "${substitute}"
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
        printf "File %s/%s does not exist.\n" "${absoluteScriptDir}" "${file}"
        exit 1
    fi
done

for dir in "${dirs_to_be_linked[@]}"; do
    if [ ! -d ./"${dir}" ]; then
        printf "Directory %s/%s does not exist.\n" "${absoluteScriptDir}" "${dir}"
        exit 2
    fi
done

printf "Files to be linked:\n"
for ((i=0; i < "${#files_to_be_linked[@]}"; i++)); do
    printf "[%s]: %s\n" "${i}" "${files_to_be_linked[${i}]}"
done

printf "\nDirectories to be linked:\n"
for ((j=0; j < "${#dirs_to_be_linked[@]}"; j++)); do
    let k=i+j
    printf "[%s]: %s\n" "${k}" "${dirs_to_be_linked[${j}]}"
done

let k=i+j
printf "\n[%s]: All options above\n" "${k}"
printf "Ctrl + C to leave.\n\n"

printf "Which option would you like to create a link in your home directory?\n"
printf "Or would you like to create a link to all options above?\n"

while IFS= read -rp "> " option; do
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
        if [ "${option}" -gt ${k} ] || [ "${option}" -lt "$(( i - i ))" ]; then
            printf "%s is not a valid choice.\n" "${option}"
            printf "It must be between %i and %s.\n" "$(( i - i ))" "${k}"
        elif [ "${option}" -ge "$(( i - i ))" ] && [ "${option}" -le "${i}" ]; then
            makeSymLinkAtHomeDir "${files_to_be_linked[${option}]}"
        elif [ "${option}" -gt "${i}" ] && [ "${option}" -lt "${k}" ]; then
            let option=option-i
            makeSymLinkAtHomeDir "${dirs_to_be_linked[${option}]}"
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
