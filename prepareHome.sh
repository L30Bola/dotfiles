#!/usr/bin/env bash

set -e 

declare force absoluteScriptDir chosenGitSubmoduleURLProtocol
force=false

declare -a files_to_be_linked dirs_to_be_linked
files_to_be_linked=( "bash_profile" "bashrc" "gitconfig" "pythonrc" "tmux.conf" "vimrc" )
dirs_to_be_linked=( "tmux" )

declare -i temp1 temp2 temp3 

function getScriptAbsoluteDir() {
    (
    unset CDPATH
    absoluteScriptDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    printf "%s\\n" "${absoluteScriptDir}"
    ) 
}

absoluteScriptDir=$(getScriptAbsoluteDir)

function makeSymLinkAtHomeDir() { 
    local toBeLinked="${1}"
    if [ "${force}" = true ]; then
        ln -fs "${absoluteScriptDir}"/"${toBeLinked}" "${HOME}"/."${toBeLinked}"
        printf "Link from %s/%s created at %s/.%s\\n" "${absoluteScriptDir}" "${toBeLinked}" "${HOME}" "${toBeLinked}"
    else
        if [ -f "${HOME}"/."${toBeLinked}" ]; then
            printf "File %s/.%s already exists. Overwrite? (y/N)\\n" "${HOME}" "${toBeLinked}" 
            read -r substitute
            substitute=${substitute:-N}
            if [ "${substitute}" = "n" ] || [ "${substitute}" = "N" ]; then
                printf "%s/.%s was not overwritten.\\n" "${HOME}" "${toBeLinked}"
            elif [ "${substitute}" = "y" ] || [ "${substitute}" = "Y" ]; then
                ln -fs "${absoluteScriptDir}"/"${toBeLinked}" "${HOME}"/."${toBeLinked}"
                printf "%s/.%s overwritten.\\n" "${HOME}" "${toBeLinked}"
            else
                printf "'%s' isn't a recognized option.\\n" "${substitute}"
            fi
        elif [ -d "${HOME}"/."${toBeLinked}" ]; then
            printf "Directory %s/.%s already exists. Rename? (y/N)\\n" "${HOME}" "${toBeLinked}" 
            read -r substitute
            substitute=${substitute:-N}
            if [ "${substitute}" = "n" ] || [ "${substitute}" = "N" ]; then
                printf "%s/.%s was not renamed.\\n" "${HOME}" "${toBeLinked}"
            elif [ "${substitute}" = "y" ] || [ "${substitute}" = "Y" ]; then
                mv "${HOME}"/."${toBeLinked}" "${HOME}"/."${toBeLinked}".old
                printf "%s/.%s renamed to %s/.%s.old\\n" "${HOME}" "${toBeLinked}" "${HOME}" "${toBeLinked}"
                ln -fs "${absoluteScriptDir}"/"${toBeLinked}" "${HOME}"/."${toBeLinked}"
                printf "Link from %s/%s created at %s/.%s\\n" "${absoluteScriptDir}" "${toBeLinked}" "${HOME}" "${toBeLinked}"
            else
                printf "'%s' isn't a recognized option.\\n" "${substitute}"
            fi
        else
            force=true
            makeSymLinkAtHomeDir "${toBeLinked}"
            force=false
        fi
    fi
}

function chooseBetweenHTTPSOrGitForSubmodulesURLProtocol() {
    if [ "${chosenGitSubmoduleURLProtocol,,}" == "https" ]; then
        sed -i "s|git@github.com:|https://github.com/|g" "${absoluteScriptDir}"/.gitmodules
        sed -i "s|git@github.com:|https://github.com/|g" "${absoluteScriptDir}"/.git/config
    elif [ "${chosenGitSubmoduleURLProtocol,,}" == "git" ]; then
        sed -i "s|https://github.com/|git@github.com:|g" "${absoluteScriptDir}"/.gitmodules
        sed -i "s|https://github.com/|git@github.com:|g" "${absoluteScriptDir}"/.git/config
    fi
}

function cloneGitSubmodules() {
    pushd "${absoluteScriptDir}"
    git submodule update --recursive --init
    popd
}

function control_c() {
    trap - SIGINT
    printf "\\nWhich protocol do you prefer to use to clone Submodules, "
    printf "HTTPS or Git?\\n"
    printf "Press Ctrl + C to exit.\\n"
    while IFS= read -rp "> " chosenGitSubmoduleURLProtocol; do
        if [ "${chosenGitSubmoduleURLProtocol,,}" != "https" ] && [ "${chosenGitSubmoduleURLProtocol,,}" != "git" ]; then
            printf "%s is not a valid option. Choose between HTTPS or Git.\\n" "${chosenGitSubmoduleURLProtocol}"
        else
            chooseBetweenHTTPSOrGitForSubmodulesURLProtocol
            cloneGitSubmodules
            exit 0
        fi
    done
}

if [ "$#" -eq 0 ]; then
    for file in "${files_to_be_linked[@]}"; do
        if [ ! -f "${absoluteScriptDir}"/"${file}" ]; then
            printf "File %s/%s does not exist inside ${absoluteScriptDir}.\\n" "${absoluteScriptDir}" "${file}"
            exit 13
        fi
    done
    
    for dir in "${dirs_to_be_linked[@]}"; do
        if [ ! -d "${absoluteScriptDir}"/"${dir}" ]; then
            printf "Directory %s/%s does not exist inside ${absoluteScriptDir}.\\n" "${absoluteScriptDir}" "${dir}"
            exit 14
        fi
    done
    
    printf "Files to be linked:\\n"
    for ((temp1=0; temp1 < "${#files_to_be_linked[@]}"; temp1++)); do
        printf "[%s]: %s\\n" "${temp1}" "${files_to_be_linked[${temp1}]}"
    done
    
    printf "\\nDirectories to be linked:\\n"
    for ((temp2=0; temp2 < "${#dirs_to_be_linked[@]}"; temp2++)); do
        (( temp3=temp1+temp2 ))
        printf "[%s]: %s\\n" "${temp3}" "${dirs_to_be_linked[${temp2}]}"
    done
    
    (( temp3=temp1+temp2 ))
    printf "\\n[%s]: All options above\\n" "${temp3}"
    trap control_c SIGINT
    printf "Press Ctrl + C to clone/update the submodules.\\n\\n"
    
    printf "Which option would you like to create a link in your home directory?\\n"
    printf "Or would you like to create a link to all options above?\\n"

    while IFS= read -rp "> " option; do
        if [ "${option}" -eq "${temp3}" ]; then
            force=true
            for ((temp1=0; temp1 < "${#files_to_be_linked[@]}"; temp1++)); do
                makeSymLinkAtHomeDir "${files_to_be_linked[${temp1}]}"
            done
            for ((temp2=0; temp2 < "${#dirs_to_be_linked[@]}"; temp2++)); do
                makeSymLinkAtHomeDir "${dirs_to_be_linked[${temp2}]}"
            done
            kill -SIGINT $$
        else
            if [ "${option}" -gt ${temp3} ] || [ "${option}" -lt "$(( temp1 - temp1 ))" ]; then
                printf "%s is not a valid choice.\\n" "${option}"
                printf "It must be between %i and %s.\\n" "$(( temp1 - temp1 ))" "${temp3}"
            elif [ "${option}" -ge "$(( temp1 - temp1 ))" ] && [ "${option}" -lt "${temp1}" ]; then
                makeSymLinkAtHomeDir "${files_to_be_linked[${option}]}"
            elif [ "${option}" -ge "${temp1}" ] && [ "${option}" -lt "${temp3}" ]; then
                option=$(( option - temp1 ))
                makeSymLinkAtHomeDir "${dirs_to_be_linked[${option}]}"
            fi
        fi
    done
else
    if [ "${1,,}" == "all" ] || [ "$1" -gt $(( ${#files_to_be_linked}+${#dirs_to_be_linked} )) ]; then
        temp3=${#files_to_be_linked}+${#dirs_to_be_linked}
    elif [ "$1" -ge 0 ] && [ "$1" -le $(( ${#files_to_be_linked}+${#dirs_to_be_linked} )) ]; then
        temp3="$1"
    else
        printf "%s is not a valid value for files/dirs to be linked.\\n" "$1"
        exit 15
    fi

    if [ "${2,,}" != "https" ] || [ "${2,,}" != "git" ]; then
        chosenGitSubmoduleURLProtocol="$2"
    else
        printf "%s is not a valid option. Choose between HTTPS or Git.\\n" "${chosenGitSubmoduleURLProtocol}"
        exit 16
    fi

    for ((temp1=0; temp1 < temp3; temp1++)); do
        makeSymLinkAtHomeDir "${files_to_be_linked[${temp1}]}"
    done
    for ((temp2=0; temp2 < temp3; temp2++)); do
        makeSymLinkAtHomeDir "${dirs_to_be_linked[${temp2}]}"
    done
    chooseBetweenHTTPSOrGitForSubmodulesURLProtocol
    cloneGitSubmodules
fi
